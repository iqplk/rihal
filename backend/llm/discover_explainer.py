import json
import os

from dotenv import load_dotenv
from openai import OpenAI

load_dotenv()

client = OpenAI(api_key=os.getenv("OPENAI_API_KEY"))


def explain_discover_now(
    discover_result: dict,
    available_minutes: int,
) -> str:
    """
    Explains Discover Now results.

    The LLM does NOT select, add, remove,
    recalculate, or reorder places.

    It only explains the options returned
    by the backend.
    """

    # ========================================================
    # 1. Search service unavailable
    # ========================================================

    if not discover_result.get("search_available", True):
        return "تعذر البحث عن الأماكن القريبة مؤقتًا. " "جرّب مرة أخرى بعد قليل."

    # ========================================================
    # 2. Places
    # ========================================================

    places = discover_result.get("places", [])

    # ========================================================
    # 3. No suitable places
    # ========================================================

    if not places:
        return "ما لقينا مكان مناسب ضمن وقتك الحالي. " "جرّب زيادة الوقت المتاح."

    # ========================================================
    # 4. Prepare simplified data for LLM
    # ========================================================

    simplified_places = []

    for index, place in enumerate(
        places,
        start=1,
    ):

        simplified_places.append(
            {
                "order": index,
                "name": place.get("name"),
                "category": place.get("category"),
                "travel_mode": place.get("travel_mode"),
                "outbound_minutes": place.get("outbound_minutes"),
                "return_minutes": place.get("return_minutes"),
                "visit_minutes": place.get("visit_minutes"),
                "total_required_minutes": place.get("total_required_minutes"),
                "remaining_minutes": place.get("remaining_minutes"),
                "outbound_distance_km": place.get("outbound_distance_km"),
                "address": place.get("address"),
            }
        )

    # ========================================================
    # 5. Data sent to LLM
    # ========================================================

    data = {
        "available_minutes": available_minutes,
        "places": simplified_places,
        "continues_to_next_activity": discover_result.get("next_destination") is not None,
        "next_activity_start": discover_result.get("next_activity_start"),
    }

    # ========================================================
    # 6. LLM Instructions
    # ========================================================

    instructions = """
أنت المساعد السياحي داخل تطبيق رِحال.

ستصلك قائمة أماكن تم التحقق منها مسبقًا بواسطة النظام
على أنها تناسب الوقت المتاح للمستخدم.

مهمتك فقط شرح الخيارات للمستخدم بطريقة عربية طبيعية وواضحة.

قواعد صارمة:

- لا تضف أي مكان غير موجود في البيانات.
- لا تحذف أي مكان.
- لا تغير ترتيب الأماكن.
- لا تعيد حساب الوقت.
- لا تغير أوقات الذهاب أو العودة أو الزيارة.
- لا تخترع عنوانًا أو وصفًا للمكان.
- لا تقل إن المكان مفتوح الآن إلا إذا كانت هذه المعلومة موجودة صراحة.
- لا تستخدم كلمات تقنية مثل API أو ORS أو Geoapify.
- لا تقل إن الوصول مضمون.
- إذا كانت continues_to_next_activity صحيحة، فمدة العودة تعني الانتقال إلى الوجهة التالية، وليس الرجوع إلى نقطة البداية. وضح ذلك دون اختراع اسم الوجهة.
- استخدم فقط الأرقام الموجودة في البيانات.
- لا تقرر بالنيابة عن المستخدم.
- لا تقل إن مكانًا أفضل من الآخر إلا بناءً على الأرقام الموجودة فقط.
- اجعل الصياغة مناسبة لتطبيق سياحي ومختصرة وواضحة.

معاني وسائل التنقل:

walking = مشيًا
driving = بالسيارة

ابدأ بجملة قصيرة مثل:

"عندك 40 دقيقة متاحة الآن، وهذه الخيارات تناسب وقتك:"

لكل مكان اعرض:

- اسم المكان.
- نوع المكان.
- مدة الوصول.
- وسيلة الوصول.
- الوقت المقترح للزيارة.
- مدة العودة.
- إجمالي الوقت المطلوب.
- الوقت المتبقي بعد العودة.

إذا كان remaining_minutes من 0 إلى 5 دقائق،
وضح بلطف أن الوقت ضيق.

إذا كان الوقت المتبقي أكبر من 5 دقائق،
لا تحتاج إلى التنبيه أن الوقت ضيق.

مثال للصياغة:

1. لايدر كاف ☕
يبعد عنك حوالي 7 دقائق مشيًا.
تقدر تقضي فيه قرابة 20 دقيقة،
والعودة تستغرق حوالي 7 دقائق.
إجمالي الوقت المتوقع 39 دقيقة،
ويبقى لك دقيقة واحدة فقط، لذلك الوقت فيه ضيق.

إذا كان هناك أكثر من خيار،
اعرض جميع الخيارات بنفس الترتيب الذي وصلتك به.

في النهاية قل:

"اختر المكان اللي يناسبك، ورِحال يعرض لك موقعه ومساره."
"""

    # ========================================================
    # 7. Call OpenAI
    # ========================================================

    response = client.responses.create(
        model="gpt-6-luna",
        instructions=instructions,
        input=json.dumps(
            data,
            ensure_ascii=False,
        ),
    )

    # ========================================================
    # 8. Return explanation
    # ========================================================

    return response.output_text
