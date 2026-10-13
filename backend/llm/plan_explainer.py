import json
import os

from dotenv import load_dotenv
from openai import OpenAI

load_dotenv()

client = OpenAI(api_key=os.getenv("OPENAI_API_KEY"))


def explain_plan(plan_result: dict) -> str:
    """
    Takes the final Rule-Based Planner result
    and turns it into a professional Arabic itinerary explanation.
    """

    if not plan_result.get("plan"):
        return "لم نتمكن من إنشاء خطة مناسبة ضمن الوقت والأماكن المختارة."

    activities = []

    for day, day_activities in plan_result["plan"].items():

        for index, item in enumerate(
            day_activities,
            start=1,
        ):

            activities.append(
                {
                    "order": index,
                    "day": day,
                    "place": item.get("name_ar"),
                    "category": item.get("category"),
                    "visit_start": item.get("start"),
                    "visit_end": item.get("end"),
                    "visit_minutes": item.get("visit_minutes"),
                    "travel_mode": item.get("travel_mode"),
                    "travel_minutes": item.get("estimated_travel_minutes"),
                    "distance_km": item.get("distance_from_previous_km"),
                    "recommended_mode": item.get("recommended_mode"),
                    "walking_option": item.get("walking_option"),
                    "driving_option": item.get("driving_option"),
                    "opening_hours_note": item.get("opening_hours_note"),
                    "reason": item.get("reason"),
                }
            )

    unscheduled_places = []

    for place in plan_result.get("unscheduled_places", []):
        unscheduled_places.append(
            {
                "place_id": place.get("place_id"),
                "name": place.get("name_ar"),
            }
        )

    planner_data = {
        "activities": activities,
        "unscheduled_places": unscheduled_places,
    }

    instructions = """
أنت المساعد السياحي داخل تطبيق رِحال.

ستصلك خطة رحلة محسوبة مسبقًا بواسطة
Rule-Based Planner ونظام طرق حقيقي.

مهمتك ليست إنشاء الخطة.
مهمتك فقط شرح الخطة للمستخدم بطريقة احترافية وواضحة.

قواعد صارمة:

- لا تغير ترتيب الأماكن.
- لا تضف أماكن جديدة.
- لا تحذف أماكن.
- لا تعدل أوقات الزيارة.
- لا تعيد حساب أي مدة أو مسافة.
- لا تخترع معلومات غير موجودة في البيانات.
- استخدم أوقات الزيارة كما هي تمامًا.
- استخدم وقت التنقل كما هو موجود في travel_minutes.
- travel_minutes هو وقت الانتقال إلى هذا المكان من المكان السابق.
- لأول مكان، travel_minutes هو وقت الانتقال من نقطة البداية إلى أول مكان.

طريقة العرض المطلوبة:

1. ابدأ بعنوان قصير وأنيق لليوم.

2. اذكر وقت الانطلاق.

3. لكل محطة:
   - وضح الانتقال إليها.
   - وضح وسيلة التنقل المستخدمة:
     walking = مشيًا
     driving = بالسيارة
   - اذكر مدة التنقل.
   - اذكر المسافة إذا كانت مفيدة.
   - ثم اذكر وقت بداية ونهاية الزيارة.
   - اذكر مدة الزيارة بشكل طبيعي.

4. إذا كان walking_option و driving_option موجودين،
   لا تعرض كل التفاصيل بشكل مزعج.
   اذكر الخيار المستخدم في الخطة فقط،
   ويمكن الإشارة باختصار إلى وجود خيار بديل إذا كان مفيدًا.

5. لا تقل:
   "من 10:37 إلى 10:45 انتقال"
   إلا إذا كانت هذه الفترة متطابقة فعلاً مع بيانات الخطة.

6. لا تحسب وقتًا من نفسك.
   اعتمد فقط على:
   visit_start
   visit_end
   travel_minutes

7. استخدم تنسيقًا مريحًا للقراءة، مثل:

09:00 ص | الانطلاق
توجه مشيًا إلى المكان الأول، ويستغرق الوصول نحو 7 دقائق.

09:07 ص – 10:37 ص | اسم المكان
زيارة لمدة ساعة ونصف.

ثم انتقل بالسيارة إلى المكان التالي، ويستغرق الطريق نحو 8 دقائق.

10:45 ص – 12:15 م | اسم المكان
...

8. لا تكرر عبارة "بعدها" في كل سطر.
استخدم تنويعًا طبيعيًا مثل:
- ثم
- بعد الزيارة
- المحطة التالية
- بعد ذلك

9. استخدم العربية البسيطة والمهنية.
لا تجعل النص آليًا أو جامدًا.

10. في النهاية اكتب ملخصًا قصيرًا جدًا يوضح أن الترتيب
يراعي الوقت والمسافات بين الأماكن قدر الإمكان.

11. إذا كانت هناك أماكن لم تدخل الخطة،
اذكرها في نهاية الرد فقط.

12. لا تذكر كلمات تقنية مثل:
Rule-Based Planner
ORS
Matrix
API
Haversine
للمستخدم النهائي.
"""

    response = client.responses.create(
        model="gpt-6-luna",
        instructions=instructions,
        input=json.dumps(planner_data, ensure_ascii=False),
    )

    return response.output_text
