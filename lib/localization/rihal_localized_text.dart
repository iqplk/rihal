import 'package:flutter/material.dart' as m;

/// ترجمة موحّدة للنصوص الحالية في رِحال بدون تغيير منطق الشاشات.
/// تعتمد على Locale الخاص بالتطبيق؛ العربية والأردية RTL، والإنجليزية والتركية LTR.
class RihalTranslations {
  RihalTranslations._();

  static String languageCode(m.BuildContext context) =>
      m.Localizations.localeOf(context).languageCode;

  static bool isRtl(m.BuildContext context) {
    final code = languageCode(context);
    return code == 'ar' || code == 'ur';
  }

  static m.TextDirection direction(m.BuildContext context) =>
      isRtl(context) ? m.TextDirection.rtl : m.TextDirection.ltr;

  static String currentLanguageLabel(m.BuildContext context) {
    switch (languageCode(context)) {
      case 'en': return 'English';
      case 'tr': return 'Türkçe';
      case 'ur': return 'اردو';
      default: return 'العربية';
    }
  }

  static const Map<String, List<String>> _values = {
    "الحساب": <String>["Account", "Hesap", "اکاؤنٹ"],
    "رحلاتي": <String>["My Trips", "Gezilerim", "میرے سفر"],
    "الرئيسية": <String>["Home", "Ana Sayfa", "ہوم"],
    "استكشاف لحظي": <String>["Explore Now", "Anlık Keşif", "فوری دریافت"],
    "الاستكشاف اللحظي": <String>["Explore Now", "Anlık Keşif", "فوری دریافت"],
    "يمكنك تغيير الموقع بالضغط على الخريطة": <String>["You can change the location by tapping the map", "Haritaya dokunarak konumu değiştirebilirsin", "نقشے پر ٹیپ کرکے مقام تبدیل کر سکتے ہیں"],
    "اضغط على الخريطة لتحديد موقع إقامتك": <String>["Tap the map to select your accommodation location", "Konaklama konumunu seçmek için haritaya dokun", "اپنی رہائش کا مقام منتخب کرنے کے لیے نقشے پر ٹیپ کریں"],
    "اضغطي على الخريطة لتحديد الموقع": <String>["Tap the map to select a location", "Konum seçmek için haritaya dokun", "مقام منتخب کرنے کے لیے نقشے پر ٹیپ کریں"],
    "الموقع المختار": <String>["Selected location", "Seçilen konum", "منتخب مقام"],
    "الموقع المحدد": <String>["Selected location", "Seçilen konum", "منتخب مقام"],
    "تأكيد موقع الإقامة": <String>["Confirm accommodation location", "Konaklama konumunu onayla", "رہائش کے مقام کی تصدیق کریں"],
    "ابحث عن معلم، مطعم، مقهى...": <String>["Search for a landmark, restaurant, café...", "Bir simge yapı, restoran, kafe ara...", "کسی مقام، ریستوران یا کیفے کو تلاش کریں..."],
    "مكان مختار": <String>["place selected", "yer seçildi", "مقام منتخب"],
    "أماكن مختارة": <String>["places selected", "yer seçildi", "مقامات منتخب"],
    "عرض الخريطة": <String>["Map view", "Harita görünümü", "نقشہ منظر"],
    "سنضيف أنماط عرض إضافية للخريطة لاحقاً": <String>["More map view modes will be added later", "Daha fazla harita görünümü daha sonra eklenecek", "مزید نقشہ ویوز بعد میں شامل کیے جائیں گے"],
    "تعديل الملف الشخصي": <String>["Edit profile", "Profili düzenle", "پروفائل میں ترمیم"],
    "تغيير الصورة": <String>["Change photo", "Fotoğrafı değiştir", "تصویر تبدیل کریں"],
    "الاسم": <String>["Name", "Ad", "نام"],
    "البريد الإلكتروني": <String>["Email", "E-posta", "ای میل"],
    "رقم الجوال": <String>["Mobile number", "Telefon numarası", "موبائل نمبر"],
    "المدينة": <String>["City", "Şehir", "شہر"],
    "المدينة المنورة": <String>["Madinah", "Medine", "مدینہ منورہ"],
    "تم حفظ التغييرات": <String>["Changes saved", "Değişiklikler kaydedildi", "تبدیلیاں محفوظ ہوگئیں"],
    "حفظ التغييرات": <String>["Save changes", "Değişiklikleri kaydet", "تبدیلیاں محفوظ کریں"],
    "الإشعارات": <String>["Notifications", "Bildirimler", "اطلاعات"],
    "تنبيهات الرحلات": <String>["Trip alerts", "Gezi bildirimleri", "سفر کی اطلاعات"],
    "تذكير بخطة الرحلة والمواعيد": <String>["Reminders for your trip plan and schedule", "Gezi planı ve saatleri için hatırlatmalar", "سفر کے منصوبے اور اوقات کی یاد دہانی"],
    "اقتراحات رِحال": <String>["Rihal suggestions", "Rihal önerileri", "رِحال کی تجاویز"],
    "أماكن وتجارب مقترحة لك": <String>["Places and experiences suggested for you", "Sana önerilen yerler ve deneyimler", "آپ کے لیے تجویز کردہ مقامات اور تجربات"],
    "أماكن قريبة": <String>["Nearby places", "Yakındaki yerler", "قریبی مقامات"],
    "اقتراحات حسب موقعك الحالي": <String>["Suggestions based on your current location", "Mevcut konumuna göre öneriler", "آپ کے موجودہ مقام کے مطابق تجاویز"],
    "العربية": <String>["Arabic", "Arapça", "عربی"],
    "اللغة": <String>["Language", "Dil", "زبان"],
    "اردو": <String>["Urdu", "Urduca", "اردو"],
    "الخصوصية والأمان": <String>["Privacy & Security", "Gizlilik ve Güvenlik", "رازداری اور سیکیورٹی"],
    "تغيير كلمة المرور": <String>["Change password", "Şifreyi değiştir", "پاس ورڈ تبدیل کریں"],
    "تحديث كلمة مرور الحساب": <String>["Update your account password", "Hesap şifreni güncelle", "اپنے اکاؤنٹ کا پاس ورڈ اپ ڈیٹ کریں"],
    "صلاحية الموقع": <String>["Location permission", "Konum izni", "مقام کی اجازت"],
    "التحكم باستخدام موقعك": <String>["Control access to your location", "Konumuna erişimi yönet", "اپنے مقام تک رسائی کو کنٹرول کریں"],
    "حذف الحساب": <String>["Delete account", "Hesabı sil", "اکاؤنٹ حذف کریں"],
    "حذف الحساب والبيانات نهائيًا": <String>["Permanently delete the account and data", "Hesabı ve verileri kalıcı olarak sil", "اکاؤنٹ اور ڈیٹا مستقل طور پر حذف کریں"],
    "المساعدة والدعم": <String>["Help & Support", "Yardım ve Destek", "مدد اور معاونت"],
    "الأسئلة الشائعة": <String>["FAQ", "Sık Sorulan Sorular", "عمومی سوالات"],
    "إجابات لأكثر الأسئلة شيوعًا": <String>["Answers to common questions", "En sık sorulan soruların yanıtları", "عام سوالات کے جوابات"],
    "تواصل معنا": <String>["Contact us", "Bize ulaşın", "ہم سے رابطہ کریں"],
    "إرسال استفسار أو ملاحظة": <String>["Send a question or feedback", "Soru veya geri bildirim gönder", "سوال یا رائے بھیجیں"],
    "الإبلاغ عن مشكلة": <String>["Report a problem", "Sorun bildir", "مسئلہ رپورٹ کریں"],
    "ساعدينا في تحسين رِحال": <String>["Help us improve Rihal", "Rihal’i geliştirmemize yardımcı ol", "رِحال کو بہتر بنانے میں ہماری مدد کریں"],
    "عن رِحال": <String>["About Rihal", "Rihal Hakkında", "رِحال کے بارے میں"],
    "رِحال": <String>["Rihal", "Rihal", "رِحال"],
    "مساعدك الذكي لاكتشاف المدينة وبناء رحلة تناسب اهتماماتك.": <String>["Your smart companion for exploring the city and building a trip around your interests.", "Şehri keşfetmen ve ilgi alanlarına uygun bir gezi oluşturman için akıllı yardımcın.", "شہر دریافت کرنے اور اپنی دلچسپیوں کے مطابق سفر بنانے کے لیے آپ کا ذہین ساتھی۔"],
    "الإصدار 1.0.0": <String>["Version 1.0.0", "Sürüm 1.0.0", "ورژن 1.0.0"],
    "رجوع": <String>["Back", "Geri", "واپس"],
    "ابدئي رحلتك مع رِحال": <String>["Start your journey with Rihal", "Rihal ile yolculuğuna başla", "رِحال کے ساتھ اپنا سفر شروع کریں"],
    "أنشئي حسابك وابدئي تخطيط رحلاتك بسهولة": <String>["Create your account and start planning your trips with ease", "Hesabını oluştur ve gezilerini kolayca planlamaya başla", "اپنا اکاؤنٹ بنائیں اور آسانی سے سفر کی منصوبہ بندی شروع کریں"],
    "إنشاء حساب": <String>["Create account", "Hesap oluştur", "اکاؤنٹ بنائیں"],
    "أدخلي بياناتك لإنشاء حساب جديد": <String>["Enter your details to create a new account", "Yeni hesap oluşturmak için bilgilerini gir", "نیا اکاؤنٹ بنانے کے لیے اپنی معلومات درج کریں"],
    "اسم المستخدم": <String>["Username", "Kullanıcı adı", "صارف نام"],
    "أدخلي اسم المستخدم": <String>["Enter your username", "Kullanıcı adını gir", "اپنا صارف نام درج کریں"],
    "كلمة المرور": <String>["Password", "Şifre", "پاس ورڈ"],
    "أدخلي كلمة المرور": <String>["Enter your password", "Şifreni gir", "اپنا پاس ورڈ درج کریں"],
    "تأكيد كلمة المرور": <String>["Confirm password", "Şifreyi doğrula", "پاس ورڈ کی تصدیق"],
    "أعيدي إدخال كلمة المرور": <String>["Re-enter your password", "Şifreni tekrar gir", "پاس ورڈ دوبارہ درج کریں"],
    "لديك حساب بالفعل؟": <String>["Already have an account?", "Zaten hesabın var mı?", "پہلے سے اکاؤنٹ ہے؟"],
    "تسجيل الدخول": <String>["Log in", "Giriş yap", "لاگ اِن"],
    "بإنشاء الحساب فإنك توافقين على سياسة الخصوصية وشروط الاستخدام": <String>["By creating an account, you agree to the Privacy Policy and Terms of Use", "Hesap oluşturarak Gizlilik Politikası ve Kullanım Koşullarını kabul etmiş olursun", "اکاؤنٹ بنا کر آپ رازداری کی پالیسی اور استعمال کی شرائط سے اتفاق کرتے ہیں"],
    "إظهار كلمة المرور": <String>["Show password", "Şifreyi göster", "پاس ورڈ دکھائیں"],
    "إخفاء كلمة المرور": <String>["Hide password", "Şifreyi gizle", "پاس ورڈ چھپائیں"],
    "الرجاء تعبئة جميع الحقول": <String>["Please fill in all fields", "Lütfen tüm alanları doldur", "براہ کرم تمام خانے پُر کریں"],
    "أدخلي بريدًا إلكترونيًا صحيحًا": <String>["Enter a valid email address", "Geçerli bir e-posta adresi gir", "درست ای میل ایڈریس درج کریں"],
    "يجب أن تكون كلمة المرور 6 أحرف على الأقل": <String>["Password must be at least 6 characters", "Şifre en az 6 karakter olmalı", "پاس ورڈ کم از کم 6 حروف کا ہونا چاہیے"],
    "كلمتا المرور غير متطابقتين": <String>["Passwords do not match", "Şifreler eşleşmiyor", "پاس ورڈ مطابقت نہیں رکھتے"],
    "تم إنشاء الحساب بنجاح": <String>["Account created successfully", "Hesap başarıyla oluşturuldu", "اکاؤنٹ کامیابی سے بن گیا"],
    "رحلتك على طريقتك": <String>["Your journey, your way", "Yolculuğun, senin tarzın", "آپ کا سفر، آپ کے انداز میں"],
    "مرحبًا بعودتك": <String>["Welcome back", "Tekrar hoş geldin", "واپسی پر خوش آمدید"],
    "سجّلي الدخول وكمّلي رحلتك مع رِحال": <String>["Log in and continue your journey with Rihal", "Giriş yap ve Rihal ile yolculuğuna devam et", "لاگ اِن کریں اور رِحال کے ساتھ اپنا سفر جاری رکھیں"],
    "أدخلي بيانات حسابك للمتابعة": <String>["Enter your account details to continue", "Devam etmek için hesap bilgilerini gir", "جاری رکھنے کے لیے اپنے اکاؤنٹ کی معلومات درج کریں"],
    "نسيت كلمة المرور؟": <String>["Forgot password?", "Şifreni mi unuttun?", "پاس ورڈ بھول گئے؟"],
    "ليس لديك حساب؟": <String>["Don't have an account?", "Hesabın yok mu?", "اکاؤنٹ نہیں ہے؟"],
    "رِحال — رحلتك على طريقتك": <String>["Rihal — Your journey, your way", "Rihal — Yolculuğun, senin tarzın", "رِحال — آپ کا سفر، آپ کے انداز میں"],
    "الرجاء إدخال اسم المستخدم وكلمة المرور": <String>["Please enter your username and password", "Lütfen kullanıcı adı ve şifreni gir", "براہ کرم صارف نام اور پاس ورڈ درج کریں"],
    "جبل أحد": <String>["Mount Uhud", "Uhud Dağı", "جبل اُحد"],
    "08:00 – 09:30 ص": <String>["08:00 – 09:30 AM", "08:00 – 09:30", "08:00 – 09:30 صبح"],
    "زيارة معلم تاريخي": <String>["Visit a historic landmark", "Tarihi bir simge yapıyı ziyaret et", "تاریخی مقام کی سیر"],
    "متحف دار المدينة": <String>["Dar Al Madinah Museum", "Dar Al Madinah Müzesi", "دار المدینہ میوزیم"],
    "11:00 ص – 12:30 م": <String>["11:00 AM – 12:30 PM", "11:00 – 12:30", "11:00 صبح – 12:30 دوپہر"],
    "تاريخ المدينة وتراثها": <String>["Madinah history and heritage", "Medine tarihi ve mirası", "مدینہ کی تاریخ اور ورثہ"],
    "مسجد قباء": <String>["Quba Mosque", "Kuba Mescidi", "مسجد قباء"],
    "09:00 – 10:00 ص": <String>["09:00 – 10:00 AM", "09:00 – 10:00", "09:00 – 10:00 صبح"],
    "زيارة المسجد والصلاة": <String>["Visit the mosque and pray", "Camiyi ziyaret et ve namaz kıl", "مسجد کی زیارت اور نماز"],
    "جادة قباء": <String>["Quba Walkway", "Kuba Yürüyüş Yolu", "قباء واک وے"],
    "10:15 – 11:45 ص": <String>["10:15 – 11:45 AM", "10:15 – 11:45", "10:15 – 11:45 صبح"],
    "نزهة في الممشى": <String>["Walk along the promenade", "Yürüyüş yolunda gezinti", "واک وے پر سیر"],
    "خطتي": <String>["My Plan", "Planım", "میرا منصوبہ"],
    "رحلتي إلى المدينة المنورة": <String>["My trip to Madinah", "Medine gezim", "میرا مدینہ کا سفر"],
    "يومان": <String>["2 days", "2 gün", "2 دن"],
    "4 أماكن": <String>["4 places", "4 yer", "4 مقامات"],
    "أماكنك جاهزة للترتيب": <String>["Your places are ready to organize", "Yerlerin düzenlenmeye hazır", "آپ کے مقامات ترتیب دینے کے لیے تیار ہیں"],
    "سنوزّع الأماكن الأربعة على يومين، مع مراعاة قرب الوجهات ومواعيد زيارتها.": <String>["We’ll arrange the four places over two days, considering distance and visiting times.", "Dört yeri iki güne, yakınlık ve ziyaret saatlerini dikkate alarak dağıtacağız.", "ہم چار مقامات کو دو دنوں میں فاصلے اور دورے کے اوقات کو مدِنظر رکھتے ہوئے ترتیب دیں گے۔"],
    "اليوم الأول": <String>["Day 1", "1. Gün", "پہلا دن"],
    "اليوم الثاني": <String>["Day 2", "2. Gün", "دوسرا دن"],
    "وقت فراغ: 9:30 – 11:00 ص": <String>["Free time: 9:30 – 11:00 AM", "Boş zaman: 09:30 – 11:00", "فارغ وقت: 9:30 – 11:00 صبح"],
    "استكشف مكانًا قبل متحف دار المدينة": <String>["Explore a place before Dar Al Madinah Museum", "Dar Al Madinah Müzesi’nden önce bir yer keşfet", "دار المدینہ میوزیم سے پہلے کوئی جگہ دریافت کریں"],
    "الأوقات مقترحة للعرض، ويُراعى التحقق من مواعيد الأماكن قبل الزيارة.": <String>["Times are suggested for demonstration; check venue hours before visiting.", "Saatler örnek amaçlıdır; ziyaretten önce mekan saatlerini kontrol edin.", "اوقات صرف مثال کے لیے ہیں؛ دورے سے پہلے مقامات کے اوقات ضرور چیک کریں۔"],
    "تم حفظ رحلتي": <String>["Trip saved", "Gezim kaydedildi", "سفر محفوظ ہوگیا"],
    "حفظ رحلتي": <String>["Save my trip", "Gezimi kaydet", "میرا سفر محفوظ کریں"],
    "رتّب رحلتي": <String>["Organize my trip", "Gezimi düzenle", "میرا سفر ترتیب دیں"],
    "الكل": <String>["All", "Tümü", "سب"],
    "المسجد النبوي": <String>["Prophet's Mosque", "Mescid-i Nebevi", "مسجد نبوی"],
    "دينية": <String>["Religious", "Dini", "مذہبی"],
    "معالم": <String>["Landmarks", "Simgesel Yerler", "اہم مقامات"],
    "مسجد القبلتين": <String>["Qiblatain Mosque", "Kıbleteyn Mescidi", "مسجد قبلتین"],
    "متاحف": <String>["Museums", "Müzeler", "عجائب گھر"],
    "سكة الحجاز": <String>["Hejaz Railway", "Hicaz Demiryolu", "حجاز ریلوے"],
    "ترفيه": <String>["Leisure", "Eğlence", "تفریح"],
    "الراشد ميغا مول": <String>["Al Rashid Mega Mall", "Al Rashid Mega Mall", "الراشد میگا مال"],
    "أسواق": <String>["Shopping", "Alışveriş", "خریداری"],
    "فعّلي خدمات الموقع من إعدادات الجهاز": <String>["Enable location services in device settings", "Cihaz ayarlarından konum hizmetlerini aç", "ڈیوائس کی سیٹنگز سے مقام کی سروسز فعال کریں"],
    "يرجى السماح للتطبيق بالوصول إلى الموقع": <String>["Please allow the app to access your location", "Lütfen uygulamanın konumuna erişmesine izin ver", "براہ کرم ایپ کو مقام تک رسائی کی اجازت دیں"],
    "فعّلي إذن الموقع من إعدادات التطبيق": <String>["Enable location permission from app settings", "Uygulama ayarlarından konum iznini aç", "ایپ کی سیٹنگز سے مقام کی اجازت فعال کریں"],
    "تم تحديث موقعك الحالي": <String>["Your current location was updated", "Mevcut konumun güncellendi", "آپ کا موجودہ مقام اپ ڈیٹ ہوگیا"],
    "تأخر تحديد الموقع، حاولي مرة أخرى": <String>["Location is taking longer than expected. Try again.", "Konum belirleme gecikti. Tekrar dene.", "مقام معلوم ہونے میں تاخیر ہو رہی ہے، دوبارہ کوشش کریں"],
    "تعذر تحديد الموقع، تأكدي من تشغيل GPS": <String>["Could not determine location. Make sure GPS is enabled.", "Konum belirlenemedi. GPS’in açık olduğundan emin ol.", "مقام معلوم نہیں ہوسکا، یقینی بنائیں کہ GPS فعال ہے"],
    "مطاعم": <String>["Restaurants", "Restoranlar", "ریستوران"],
    "مقاهي": <String>["Cafés", "Kafeler", "کیفے"],
    "فعاليات": <String>["Events", "Etkinlikler", "تقریبات"],
    "لخطة العرض اختاري الأماكن الأربعة: جبل أحد، متحف دار المدينة، مسجد قباء، جادة قباء": <String>["For the demo plan, select these four places: Mount Uhud, Dar Al Madinah Museum, Quba Mosque, and Quba Walkway.", "Demo planı için şu dört yeri seç: Uhud Dağı, Dar Al Madinah Müzesi, Kuba Mescidi ve Kuba Yürüyüş Yolu.", "ڈیمو منصوبے کے لیے یہ چار مقامات منتخب کریں: جبل اُحد، دار المدینہ میوزیم، مسجد قباء اور قباء واک وے۔"],
    "لديك وقت فراغ؟": <String>["Have some free time?", "Boş vaktin mi var?", "کچھ فارغ وقت ہے؟"],
    "اكتشف مكانًا مناسبًا قبل موعدك التالي": <String>["Discover a suitable place before your next appointment", "Bir sonraki randevundan önce uygun bir yer keşfet", "اپنی اگلی مصروفیت سے پہلے مناسب جگہ دریافت کریں"],
    "موقعك الحالي": <String>["Your current location", "Mevcut konumun", "آپ کا موجودہ مقام"],
    "وجهتك التالية": <String>["Your next destination", "Sonraki hedefin", "آپ کی اگلی منزل"],
    "متحف دار المدينة — 11:00 صباحًا": <String>["Dar Al Madinah Museum — 11:00 AM", "Dar Al Madinah Müzesi — 11:00", "دار المدینہ میوزیم — 11:00 صبح"],
    "الوقت المتاح": <String>["Available time", "Uygun süre", "دستیاب وقت"],
    "من 9:30 إلى 11:00 صباحًا في مثال رحلتك": <String>["From 9:30 to 11:00 AM in this trip example", "Bu gezi örneğinde 09:30–11:00 arası", "اس سفری مثال میں صبح 9:30 سے 11:00 تک"],
    "الاهتمامات (اختياري)": <String>["Interests (optional)", "İlgi alanları (isteğe bağlı)", "دلچسپیاں (اختیاری)"],
    "طريقة التنقل": <String>["Transport mode", "Ulaşım şekli", "سفر کا طریقہ"],
    "مشي": <String>["Walking", "Yürüyüş", "پیدل"],
    "سيارة": <String>["Car", "Araba", "گاڑی"],
    "تفضيل مسار المشي": <String>["Walking route preference", "Yürüyüş rotası tercihi", "پیدل راستے کی ترجیح"],
    "اختياري — اختاري المسار الأنسب لك": <String>["Optional — choose the route that suits you", "İsteğe bağlı — sana en uygun rotayı seç", "اختیاری — اپنے لیے مناسب راستہ منتخب کریں"],
    "المسار الأسرع": <String>["Fastest route", "En hızlı rota", "تیز ترین راستہ"],
    "تعرض للشمس 68%": <String>["Sun exposure 68%", "Güneşe maruz kalma %68", "دھوپ کی نمائش 68%"],
    "أقل تعرضًا للشمس": <String>["Lower sun exposure", "Daha az güneş maruziyeti", "کم دھوپ والا راستہ"],
    "تعرض للشمس 25%": <String>["Sun exposure 25%", "Güneşe maruz kalma %25", "دھوپ کی نمائش 25%"],
    "هذا المسار يقلل التعرض للشمس من 68% إلى 25% تقريبًا، وقد يكون أطول قليلًا.": <String>["This route reduces estimated sun exposure from 68% to 25% and may be slightly longer.", "Bu rota tahmini güneş maruziyetini %68’den %25’e düşürür ve biraz daha uzun olabilir.", "یہ راستہ اندازاً دھوپ کی نمائش 68% سے 25% تک کم کرتا ہے اور تھوڑا طویل ہوسکتا ہے۔"],
    "ابحث بأقل تعرض للشمس": <String>["Search with lower sun exposure", "Daha az güneşli rota ara", "کم دھوپ والا راستہ تلاش کریں"],
    "ابحث عن أماكن قريبة": <String>["Find nearby places", "Yakındaki yerleri bul", "قریبی مقامات تلاش کریں"],
    "اقتراحات بأقل تعرض للشمس": <String>["Lower-sun-exposure suggestions", "Daha az güneşli öneriler", "کم دھوپ والی تجاویز"],
    "اقتراحات قبل زيارة المتحف": <String>["Suggestions before the museum visit", "Müze ziyareti öncesi öneriler", "میوزیم کے دورے سے پہلے تجاویز"],
    "سيتم تفضيل مسار مشي أقل تعرضًا للشمس. النسبة الحالية تقديرية لواجهة العرض.": <String>["A walking route with lower sun exposure will be preferred. The current percentage is an interface estimate.", "Daha az güneş maruziyetli yürüyüş rotası tercih edilecek. Mevcut oran arayüz için tahminidir.", "کم دھوپ والا پیدل راستہ ترجیح دیا جائے گا۔ موجودہ شرح صرف انٹرفیس کا اندازہ ہے۔"],
    "يجب التحقق من المسافات وأوقات العمل والتنقل.": <String>["Distances, opening hours, and travel times should be verified.", "Mesafeler, çalışma saatleri ve ulaşım süreleri doğrulanmalıdır.", "فاصلے، اوقاتِ کار اور سفر کے اوقات کی تصدیق ضروری ہے۔"],
    "مسار مشي بتعرض شمسي تقريبي 25%": <String>["Walking route with about 25% sun exposure", "Yaklaşık %25 güneş maruziyetli yürüyüş rotası", "تقریباً 25% دھوپ والا پیدل راستہ"],
    "تسوق ومقاهٍ ومطاعم": <String>["Shopping, cafés, and restaurants", "Alışveriş, kafeler ve restoranlar", "خریداری، کیفے اور ریستوران"],
    "استراحة في مقهى": <String>["Coffee break", "Kafede mola", "کیفے میں وقفہ"],
    "مسار أقل تعرضًا للشمس قدر الإمكان": <String>["A route with as little sun exposure as possible", "Mümkün olduğunca az güneşli rota", "حتی الامکان کم دھوپ والا راستہ"],
    "اختاري مقهى مناسبًا بعد التحقق من موقعه": <String>["Choose a suitable café after checking its location", "Konumunu kontrol ettikten sonra uygun bir kafe seç", "مقام چیک کرنے کے بعد مناسب کیفے منتخب کریں"],
    "مهم: خصّصي وقتًا للوصول إلى المتحف قبل 11:00 ص. لا تُحسب أزمنة القيادة مباشرة في هذه النسخة.": <String>["Important: allow enough time to reach the museum before 11:00 AM. Driving times are not calculated live in this version.", "Önemli: Müzeye 11:00’den önce ulaşmak için yeterli süre ayır. Bu sürümde sürüş süreleri canlı hesaplanmıyor.", "اہم: میوزیم پہنچنے کے لیے صبح 11:00 سے پہلے کافی وقت رکھیں۔ اس ورژن میں ڈرائیونگ کا وقت براہِ راست شمار نہیں ہوتا۔"],
    "موقعي الحالي": <String>["My current location", "Mevcut konumum", "میرا موجودہ مقام"],
    "تكبير الخريطة": <String>["Zoom in", "Yakınlaştır", "نقشہ بڑا کریں"],
    "تصغير الخريطة": <String>["Zoom out", "Uzaklaştır", "نقشہ چھوٹا کریں"],
    "حدد موقع إقامتك": <String>["Select your accommodation location", "Konaklama konumunu seç", "اپنی رہائش کا مقام منتخب کریں"],
    "اختر موقع الفندق أو سكنك على الخريطة": <String>["Choose your hotel or accommodation location on the map", "Otel veya konaklama yerini haritada seç", "نقشے پر اپنے ہوٹل یا رہائش کا مقام منتخب کریں"],
    "القادمة": <String>["Upcoming", "Yaklaşan", "آنے والے"],
    "السابقة": <String>["Past", "Geçmiş", "گزشتہ"],
    "لا توجد رحلات محفوظة بعد": <String>["No saved trips yet", "Henüz kayıtlı gezi yok", "ابھی کوئی محفوظ سفر نہیں"],
    "لا توجد رحلات سابقة": <String>["No past trips", "Geçmiş gezi yok", "کوئی گزشتہ سفر نہیں"],
    "8 أكتوبر – 9 أكتوبر 2026": <String>["8 Oct – 9 Oct 2026", "8 Ekim – 9 Ekim 2026", "8 اکتوبر – 9 اکتوبر 2026"],
    "4 أماكن  •  يومان": <String>["4 places  •  2 days", "4 yer  •  2 gün", "4 مقامات  •  2 دن"],
    "عرض الخطة": <String>["View plan", "Planı görüntüle", "منصوبہ دیکھیں"],
    "شرق المدينة المنورة": <String>["East Madinah", "Medine’nin doğusu", "مدینہ کا مشرقی حصہ"],
    "شمال المدينة المنورة": <String>["North Madinah", "Medine’nin kuzeyi", "مدینہ کا شمالی حصہ"],
    "1 – 2 ساعة (مقترحة)": <String>["1–2 hours (suggested)", "1–2 saat (önerilen)", "1–2 گھنٹے (تجویز کردہ)"],
    "1 – 3 ساعات (مقترحة)": <String>["1–3 hours (suggested)", "1–3 saat (önerilen)", "1–3 گھنٹے (تجویز کردہ)"],
    "متحف وتجربة ثقافية": <String>["Museum & cultural experience", "Müze ve kültürel deneyim", "میوزیم اور ثقافتی تجربہ"],
    "معلم ديني وتاريخي": <String>["Religious & historic landmark", "Dini ve tarihi simge yapı", "مذہبی و تاریخی مقام"],
    "معلم سياحي": <String>["Tourist landmark", "Turistik simge yapı", "سیاحتی مقام"],
    "وجهة ترفيهية": <String>["Leisure destination", "Eğlence noktası", "تفریحی مقام"],
    "مفتوح الآن": <String>["Open now", "Şu anda açık", "ابھی کھلا ہے"],
    "السبت – الخميس": <String>["Saturday – Thursday", "Cumartesi – Perşembe", "ہفتہ – جمعرات"],
    "11:00 ص – 6:00 م": <String>["11:00 AM – 6:00 PM", "11:00 – 18:00", "11:00 صبح – 6:00 شام"],
    "الجمعة": <String>["Friday", "Cuma", "جمعہ"],
    "مغلق": <String>["Closed", "Kapalı", "بند"],
    "المواعيد قابلة للتغيير في الإجازات والمناسبات.": <String>["Hours may change during holidays and special occasions.", "Saatler tatillerde ve özel günlerde değişebilir.", "تعطیلات اور خاص مواقع پر اوقات تبدیل ہوسکتے ہیں۔"],
    "مفتوح على مدار الساعة": <String>["Open 24 hours", "24 saat açık", "24 گھنٹے کھلا"],
    "جميع أيام الأسبوع": <String>["Every day of the week", "Haftanın her günü", "ہفتے کے تمام دن"],
    "مفتوح للزيارة — لا توجد ساعات محددة مذكورة": <String>["Open for visits — no specific hours listed", "Ziyarete açık — belirtilen sabit saat yok", "زیارت کے لیے کھلا — مخصوص اوقات درج نہیں"],
    "مواعيد العمل غير متوفرة حاليًا": <String>["Opening hours are currently unavailable", "Çalışma saatleri şu anda mevcut değil", "اوقاتِ کار فی الحال دستیاب نہیں"],
    "عن المكان": <String>["About the place", "Yer hakkında", "مقام کے بارے میں"],
    "ممشى متكامل": <String>["A complete pedestrian experience", "Kapsamlı yürüyüş deneyimi", "مکمل واک وے تجربہ"],
    "البُعد التاريخي لجادة قباء": <String>["Historical background of Quba Walkway", "Kuba Yürüyüş Yolu’nun tarihi boyutu", "قباء واک وے کا تاریخی پس منظر"],
    "تاريخ المدينة وآثارها": <String>["Madinah history and heritage", "Medine tarihi ve eserleri", "مدینہ کی تاریخ اور آثار"],
    "الموقع": <String>["Location", "Konum", "مقام"],
    "مدينة المعرفة الاقتصادية، أمام محطة قطار الحرمين، شرق المدينة المنورة.": <String>["Knowledge Economic City, opposite Haramain Train Station, east Madinah.", "Knowledge Economic City, Haramain Tren İstasyonu karşısı, Medine’nin doğusu.", "نالج اکنامک سٹی، حرمین ٹرین اسٹیشن کے سامنے، مشرقی مدینہ۔"],
    "صور المكان": <String>["Place photos", "Mekan fotoğrafları", "مقام کی تصاویر"],
    "آراء الزوار": <String>["Visitor reviews", "Ziyaretçi yorumları", "زائرین کی آراء"],
    "مدة الزيارة": <String>["Visit duration", "Ziyaret süresi", "دورے کا دورانیہ"],
    "معلومات": <String>["Info", "Bilgiler", "معلومات"],
    "صور": <String>["Photos", "Fotoğraflar", "تصاویر"],
    "إضافة إلى خطتي": <String>["Add to my plan", "Planıma ekle", "میرے منصوبے میں شامل کریں"],
    "الاسم والبريد الإلكتروني وبيانات الحساب": <String>["Name, email, and account details", "Ad, e-posta ve hesap bilgileri", "نام، ای میل اور اکاؤنٹ کی معلومات"],
    "التحكم بتنبيهات الرحلات والاقتراحات": <String>["Manage trip alerts and suggestions", "Gezi bildirimlerini ve önerileri yönet", "سفر کی اطلاعات اور تجاویز کنٹرول کریں"],
    "كلمة المرور وخصوصية الحساب": <String>["Password and account privacy", "Şifre ve hesap gizliliği", "پاس ورڈ اور اکاؤنٹ کی رازداری"],
    "الأسئلة الشائعة والتواصل معنا": <String>["FAQ and contact us", "SSS ve iletişim", "عمومی سوالات اور رابطہ"],
    "معلومات التطبيق والإصدار": <String>["App information and version", "Uygulama bilgileri ve sürüm", "ایپ کی معلومات اور ورژن"],
    "متحف دار المدينة هو ذاكرة الحضارة الإسلامية في طيبة الطيبة، يجسد فصول السيرة النبوية، ويحفظ معالم المدينة التراثية وآثارها العمرانية وأحداثها التاريخية، ويستمتع زائروه برحلة ثقافية وجدانية فريدة.": <String>["Dar Al Madinah Museum preserves the memory of Islamic civilization in Madinah. It presents chapters from the Prophet’s biography, preserves the city’s heritage landmarks, architectural legacy, and historical events, and offers visitors a distinctive cultural journey.", "Dar Al Madinah Müzesi, Medine’deki İslam medeniyetinin hafızasını yaşatır. Siyer-i Nebi’den bölümler sunar, şehrin miras yapılarını, mimari izlerini ve tarihi olaylarını korur; ziyaretçilere özgün bir kültürel yolculuk sunar.", "دار المدینہ میوزیم مدینہ میں اسلامی تہذیب کی یاد کو محفوظ کرتا ہے۔ یہ سیرتِ نبوی کے ابواب، شہر کے تاریخی مقامات، معماری ورثے اور اہم تاریخی واقعات کو پیش کرتا ہے اور زائرین کو ایک منفرد ثقافتی تجربہ دیتا ہے۔"],
    "المسجد النبوي من أبرز المعالم الدينية في المدينة المنورة، ويقصده الزوار من مختلف أنحاء العالم.": <String>["The Prophet's Mosque is one of Madinah’s most important religious landmarks and welcomes visitors from around the world.", "Mescid-i Nebevi, Medine’nin en önemli dini simgelerinden biridir ve dünyanın dört bir yanından ziyaretçi ağırlar.", "مسجد نبوی مدینہ منورہ کے اہم ترین مذہبی مقامات میں سے ایک ہے اور دنیا بھر سے زائرین یہاں آتے ہیں۔"],
    "أسسه الرسول ﷺ واختطه بيده عند وصوله إلى المدينة المنورة مهاجرًا من مكة المكرمة، وشارك في وضع أحجاره الأولى، ثم أكمله الصحابة رضي الله عنهم. وكان النبي ﷺ يزور مسجد قباء ويصلي فيه، وغالبًا ما يقصده يوم السبت. وقد ورد في فضله: «من تطهّر في بيته وأتى مسجد قباء فصلى فيه صلاة فله أجر عمرة».\n\nيُعد من أكبر مساجد المدينة المنورة بعد المسجد النبوي، وحظي بالعناية والتوسعة مع الحفاظ على معالمه التراثية. وتبلغ مساحة المصلى 5035 مترًا مربعًا، ومساحة مبنى المسجد ومرافقه 13500 متر مربع. وأُعلن مشروع توسعة الملك سلمان بن عبدالعزيز لمسجد قباء لتصل مساحته المستهدفة إلى 50 ألف متر مربع، وبطاقة استيعابية مستهدفة تصل إلى 66 ألف مصلٍ.": <String>["The Prophet ﷺ established Quba Mosque upon arriving in Madinah during his migration from Makkah and took part in laying its first stones, after which the Companions completed it. The Prophet ﷺ used to visit Quba Mosque and pray there, often on Saturdays. Its virtue is mentioned in the saying that whoever purifies themselves at home, comes to Quba Mosque, and prays there receives the reward of an Umrah.\n\nIt is among the largest mosques in Madinah after the Prophet’s Mosque and has received continued care and expansion while preserving its heritage features. The prayer hall covers 5,035 m², while the mosque building and facilities cover 13,500 m². The King Salman expansion project targets a total area of 50,000 m² and a capacity of up to 66,000 worshippers.", "Peygamberimiz ﷺ, Mekke’den hicret ederek Medine’ye ulaştığında Kuba Mescidi’ni kurmuş ve ilk taşlarının yerleştirilmesine bizzat katılmış, ardından sahabiler mescidi tamamlamıştır. Peygamberimiz ﷺ Kuba Mescidi’ni ziyaret eder ve namaz kılardı; çoğu zaman cumartesi günleri giderdi. Faziletiyle ilgili olarak, evinde abdest alıp Kuba Mescidi’ne gelerek namaz kılan kişinin umre sevabı kazanacağı bildirilmiştir.\n\nMescid-i Nebevi’den sonra Medine’nin en büyük camilerinden biridir. Tarihi özellikleri korunarak bakım ve genişletme çalışmaları yapılmıştır. Namaz alanı 5.035 m², cami binası ve tesisleri ise 13.500 m²’dir. Kral Selman genişletme projesiyle hedeflenen toplam alan 50.000 m², kapasite ise 66.000 kişidir.", "نبی کریم ﷺ نے مکہ مکرمہ سے ہجرت کے بعد مدینہ پہنچ کر مسجد قباء کی بنیاد رکھی اور ابتدائی پتھر رکھنے میں حصہ لیا، پھر صحابہ کرامؓ نے اسے مکمل کیا۔ آپ ﷺ مسجد قباء تشریف لے جاتے اور نماز ادا کرتے، اکثر ہفتے کے دن۔ اس کی فضیلت میں آیا ہے کہ جو شخص گھر میں وضو کرکے مسجد قباء آئے اور نماز پڑھے اسے عمرے کا ثواب ملتا ہے۔\n\nیہ مسجد نبوی کے بعد مدینہ کی بڑی مساجد میں شمار ہوتی ہے۔ اس کے تاریخی خدوخال کو محفوظ رکھتے ہوئے توسیع اور دیکھ بھال کی گئی ہے۔ نماز ہال کا رقبہ 5,035 مربع میٹر جبکہ عمارت اور سہولیات کا رقبہ 13,500 مربع میٹر ہے۔ شاہ سلمان توسیعی منصوبے کا ہدف 50,000 مربع میٹر اور تقریباً 66,000 نمازیوں کی گنجائش ہے۔"],
    "يعتبر جبل أحد من أبرز المعالم التاريخية والجغرافية في المدينة المنورة، وله مكانة عظيمة في قلوب المسلمين. يقع الجبل في الجهة الشمالية من المسجد النبوي الشريف على بعد حوالي 5 كيلومترات. يبلغ طول الجبل 7 كيلومترات وعرضه بين 2 إلى 3 كيلومترات، ويصل ارتفاعه إلى 350 مترًا.": <String>["Mount Uhud is one of Madinah’s most prominent historical and geographical landmarks and holds great significance for Muslims. It lies north of the Prophet’s Mosque, about 5 km away. The mountain is around 7 km long, 2–3 km wide, and reaches about 350 m in height.", "Uhud Dağı, Medine’nin en önemli tarihi ve coğrafi simgelerinden biridir ve Müslümanlar için büyük anlam taşır. Mescid-i Nebevi’nin yaklaşık 5 km kuzeyinde yer alır. Dağ yaklaşık 7 km uzunluğunda, 2–3 km genişliğinde ve yaklaşık 350 m yüksekliğindedir.", "جبل اُحد مدینہ منورہ کے نمایاں تاریخی اور جغرافیائی مقامات میں سے ایک ہے اور مسلمانوں کے دلوں میں خاص مقام رکھتا ہے۔ یہ مسجد نبوی سے تقریباً 5 کلومیٹر شمال میں واقع ہے۔ پہاڑ تقریباً 7 کلومیٹر لمبا، 2 سے 3 کلومیٹر چوڑا اور تقریباً 350 میٹر بلند ہے۔"],
    "وجهة سياحية متكاملة تحتضن عددًا من المهرجانات والفعاليات والأنشطة، وتربط الزائر بأعظم المعالم الإسلامية والتاريخية في المدينة المنوّرة.": <String>["A complete tourist destination hosting festivals, events, and activities while connecting visitors with some of Madinah’s most important Islamic and historical landmarks.", "Festivallere, etkinliklere ve çeşitli aktivitelere ev sahipliği yapan; ziyaretçileri Medine’nin en önemli İslami ve tarihi simgeleriyle buluşturan kapsamlı bir turistik destinasyondur.", "ایک مکمل سیاحتی مقام جہاں تہوار، تقریبات اور سرگرمیاں ہوتی ہیں اور جو زائرین کو مدینہ کے اہم اسلامی اور تاریخی مقامات سے جوڑتا ہے۔"],
    "وجهة من وجهات المدينة المنورة يمكنك إضافتها إلى خطتك السياحية في رِحال. سنضيف معلوماتها التفصيلية لاحقًا.": <String>["A Madinah destination you can add to your Rihal trip plan. More detailed information will be added later.", "Rihal gezi planına ekleyebileceğin bir Medine destinasyonu. Ayrıntılı bilgiler daha sonra eklenecek.", "مدینہ کا ایک مقام جسے آپ رِحال کے سفری منصوبے میں شامل کرسکتے ہیں۔ مزید تفصیلات بعد میں شامل کی جائیں گی۔"],
    "طريق وجادة واسعة للمشاة تربط بين المسجد النبوي ومسجد قباء، تجمع الإرث التاريخي باللحظة المعاصرة وتستقطب جميع الأجيال. وهي ممشى مهيأ للفعاليات التجارية والثقافية والاجتماعية والرياضية، وتضم محلات تجارية ومطاعم وأكشاك أطعمة مدينية وجلسات جانبية، مع أنشطة مثل ركوب العربات وقيادة الدراجات الهوائية.": <String>["A broad pedestrian avenue connecting the Prophet’s Mosque with Quba Mosque, blending historical heritage with contemporary life. It is designed for commercial, cultural, social, and sports activities, with shops, restaurants, local food kiosks, seating areas, and activities such as carts and cycling.", "Mescid-i Nebevi ile Kuba Mescidi’ni birbirine bağlayan geniş bir yaya aksıdır; tarihi mirası günümüz yaşamıyla buluşturur. Ticari, kültürel, sosyal ve sportif etkinliklere uygun şekilde düzenlenmiş; mağazalar, restoranlar, yerel yiyecek büfeleri, oturma alanları, araç ve bisiklet aktiviteleri içerir.", "یہ ایک وسیع پیدل راستہ ہے جو مسجد نبوی کو مسجد قباء سے ملاتا ہے اور تاریخی ورثے کو جدید زندگی سے جوڑتا ہے۔ یہاں تجارتی، ثقافتی، سماجی اور کھیلوں کی سرگرمیوں کے لیے جگہ، دکانیں، ریستوران، مقامی کھانے کے اسٹال، بیٹھنے کی جگہیں اور سائیکلنگ جیسی سرگرمیاں موجود ہیں۔"],
    "جادة قباء أحد مشاريع برنامج أنسنة المنطقة التي تنفّذه هيئة تطوير المدينة المنورة. ويرجع بعدها التاريخي إلى سلوك النبي ﷺ هذا الطريق في زيارته لمسجد قباء، إذ كان يذهب إلى مسجد قباء يوم السبت ماشيًا وراكبًا. وطُوّرت الجادة لتكون طريقًا للمشي والتنزه بين المسجد النبوي ومسجد قباء، مع خيارات للتسوق ومرافق جمالية وترفيهية.": <String>["Quba Walkway is part of Madinah’s urban humanization program. Its historical significance is linked to the route used by the Prophet ﷺ when visiting Quba Mosque, including on Saturdays on foot or riding. The avenue was developed as a walking and leisure route between the Prophet’s Mosque and Quba Mosque, with shopping, aesthetic, and recreational facilities.", "Kuba Yürüyüş Yolu, Medine Kalkınma Otoritesi’nin insan odaklı şehirleşme programının projelerinden biridir. Tarihi önemi, Peygamberimiz ﷺ’in Kuba Mescidi’ni ziyaret ederken bu güzergâhı kullanmasına dayanır. Cadde, Mescid-i Nebevi ile Kuba Mescidi arasında yürüyüş ve dinlenme rotası olarak; alışveriş ve rekreasyon seçenekleriyle geliştirilmiştir.", "قباء واک وے مدینہ کے شہری انسانی منصوبوں میں سے ایک ہے۔ اس کی تاریخی اہمیت اس راستے سے جڑی ہے جسے نبی کریم ﷺ مسجد قباء کی زیارت کے لیے استعمال کرتے تھے۔ اسے مسجد نبوی اور مسجد قباء کے درمیان پیدل سیر کے راستے کے طور پر تیار کیا گیا ہے، جہاں خریداری اور تفریح کی سہولیات بھی موجود ہیں۔"],
    "يعد المتحف من أهم معالم المدينة، فهو أول متحف يعرض الإرث الحضاري الإسلامي بطرق إبداعية، ومجسمات تحاكي الواقع، وصور توثق التراث العمراني، مع الاهتمام بالسيرة النبوية، والمقتنيات الأثرية عبر العصور.\n\nوقد افتتح المتحف سنة 2011م، وكان الهدف من تأسيسه المحافظة على الآثار الإسلامية والمعمارية والنقوش التاريخية التي أُزيلت في محيط المسجد النبوي من أجل توسعته، ليتصل حاضر الأمة بماضيها، ولا تفقد الأجيال الجديدة شيئًا من إرث المدينة الحضاري الإسلامي.": <String>["The museum is one of Madinah’s key landmarks and was among the first to present Islamic civilizational heritage through creative displays, realistic models, and photographs documenting architectural heritage, with special attention to the Prophet’s biography and historical artifacts.\n\nOpened in 2011, the museum was established to preserve Islamic and architectural remains and historical inscriptions removed from the area around the Prophet’s Mosque during expansion, helping connect the present with the city’s Islamic civilizational past.", "Müze, Medine’nin önemli simgelerinden biridir. İslam medeniyeti mirasını yaratıcı anlatımlar, gerçeğe yakın maketler ve mimari mirası belgeleyen fotoğraflarla sunar; Siyer-i Nebi’ye ve farklı dönemlerden eserlere özel önem verir.\n\n2011’de açılan müze, Mescid-i Nebevi çevresindeki genişletme çalışmaları sırasında kaldırılan İslami ve mimari eserleri ve tarihi yazıtları korumak amacıyla kurulmuştur.", "یہ میوزیم مدینہ کے اہم مقامات میں سے ایک ہے اور اسلامی تہذیبی ورثے کو تخلیقی انداز، حقیقت سے مشابہ ماڈلز اور معماری ورثے کی تصاویر کے ذریعے پیش کرتا ہے، جبکہ سیرتِ نبوی اور تاریخی نوادرات پر خصوصی توجہ دی جاتی ہے۔\n\nمیوزیم 2011 میں کھولا گیا تاکہ مسجد نبوی کے اطراف توسیع کے دوران ہٹائے گئے اسلامی و معماری آثار اور تاریخی نقوش کو محفوظ رکھا جاسکے اور نئی نسلوں کو مدینہ کے تہذیبی ورثے سے جوڑا جاسکے۔"],
    "المتحف جميل ومجسماته تساعد على فهم تاريخ المدينة.": <String>["The museum is beautiful, and its models help explain Madinah’s history.", "Müze güzel; maketler Medine tarihini anlamayı kolaylaştırıyor.", "میوزیم خوبصورت ہے اور اس کے ماڈلز مدینہ کی تاریخ سمجھنے میں مدد دیتے ہیں۔"],
    "تجربة ثقافية ممتعة، خصوصًا قسم السيرة النبوية.": <String>["An enjoyable cultural experience, especially the Prophet’s biography section.", "Özellikle Siyer-i Nebi bölümüyle keyifli bir kültürel deneyim.", "خاص طور پر سیرتِ نبوی کا حصہ ایک خوبصورت ثقافتی تجربہ ہے۔"],
    "المعروضات مرتبة والمعلومات التاريخية ثرية.": <String>["The exhibits are well organized and the historical information is rich.", "Sergiler düzenli ve tarihi bilgiler oldukça zengin.", "نمائشیں منظم ہیں اور تاریخی معلومات بہت بھرپور ہیں۔"],
    "الممشى واسع وجميل، خصوصًا في المساء.": <String>["The walkway is spacious and beautiful, especially in the evening.", "Yürüyüş yolu geniş ve güzel, özellikle akşamları.", "واک وے کشادہ اور خوبصورت ہے، خاص طور پر شام میں۔"],
    "المقاهي والجلسات جعلت الزيارة ممتعة مع العائلة.": <String>["The cafés and seating areas made the family visit enjoyable.", "Kafeler ve oturma alanları aile ziyaretini keyifli hale getirdi.", "کیفے اور بیٹھنے کی جگہوں نے خاندان کے ساتھ دورہ خوشگوار بنا دیا۔"],
    "أجواء رائعة للمشي واستكشاف المنطقة.": <String>["Great atmosphere for walking and exploring the area.", "Yürümek ve bölgeyi keşfetmek için harika bir atmosfer.", "پیدل چلنے اور علاقے کو دریافت کرنے کے لیے بہترین ماحول۔"],
    "مسجد مميز بأجوائه الهادئة وتنظيمه الجميل.": <String>["A special mosque with a peaceful atmosphere and excellent organization.", "Huzurlu atmosferi ve güzel düzeniyle özel bir cami.", "پُرسکون ماحول اور بہترین انتظام والا خوبصورت مسجد۔"],
    "تجربة روحانية جميلة ومكان يستحق الزيارة.": <String>["A beautiful spiritual experience and a place worth visiting.", "Güzel bir manevi deneyim ve görülmeye değer bir yer.", "خوبصورت روحانی تجربہ اور دیکھنے کے قابل مقام۔"],
    "الساحات واسعة والوصول إليه ميسر.": <String>["The courtyards are spacious and access is easy.", "Avlular geniş ve ulaşım kolay.", "صحن کشادہ ہیں اور رسائی آسان ہے۔"],
    "مكان تاريخي مؤثر وإطلالة الجبل مميزة.": <String>["A moving historic place with a distinctive mountain view.", "Etkileyici tarihi bir yer ve dağ manzarası çok özel.", "اثر انگیز تاریخی مقام اور پہاڑ کا منظر خاص ہے۔"],
    "الزيارة عرّفتنا أكثر على أحداث غزوة أحد.": <String>["The visit helped us understand the events of the Battle of Uhud better.", "Ziyaret, Uhud Savaşı’nın olaylarını daha iyi anlamamızı sağladı.", "اس دورے نے غزوہ اُحد کے واقعات کو بہتر سمجھنے میں مدد دی۔"],
    "أنصح بزيارته في الأوقات المعتدلة من اليوم.": <String>["I recommend visiting during the cooler times of the day.", "Günün daha serin saatlerinde ziyaret etmenizi öneririm.", "دن کے نسبتاً ٹھنڈے اوقات میں جانے کا مشورہ دوں گا۔"],
    "استمتعت بزيارة المكان والأجواء كانت جميلة.": <String>["I enjoyed visiting; the atmosphere was lovely.", "Ziyaretten keyif aldım, atmosfer çok güzeldi.", "مجھے دورہ بہت پسند آیا اور ماحول خوبصورت تھا۔"],
    "وجهة تستحق إضافتها إلى خطة الرحلة.": <String>["A destination worth adding to the trip plan.", "Gezi planına eklemeye değer bir destinasyon.", "سفری منصوبے میں شامل کرنے کے قابل مقام۔"],
    "تجربة لطيفة وأتمنى زيارتها مرة أخرى.": <String>["A pleasant experience; I’d like to visit again.", "Güzel bir deneyimdi, tekrar ziyaret etmek isterim.", "اچھا تجربہ تھا، دوبارہ آنا چاہوں گا۔"],
    "سارة": <String>["Sarah", "Sara", "سارہ"],
    "عبدالله": <String>["Abdullah", "Abdullah", "عبداللہ"],
    "نورة": <String>["Noura", "Nura", "نورا"],
    "أمل": <String>["Amal", "Amal", "امل"],
    "فيصل": <String>["Faisal", "Faysal", "فیصل"],
    "ريم": <String>["Reem", "Reem", "ریم"],
    "محمد": <String>["Mohammed", "Muhammed", "محمد"],
    "هدى": <String>["Huda", "Hüda", "ہدیٰ"],
    "خالد": <String>["Khalid", "Halid", "خالد"],
    "يوسف": <String>["Yousef", "Yusuf", "یوسف"],
    "فاطمة": <String>["Fatimah", "Fatma", "فاطمہ"],
    "بدر": <String>["Badr", "Bedir", "بدر"],
    "ليان": <String>["Layan", "Leyan", "لیان"],
    "راشد": <String>["Rashed", "Raşid", "راشد"],
    "هند": <String>["Hind", "Hind", "ہند"],
  };

  static String tr(m.BuildContext context, String value) {
    final code = languageCode(context);
    if (code == 'ar') return value;

    final direct = _values[value];
    if (direct != null) return _pick(direct, code);

    // نصوص ديناميكية مستخدمة في الواجهات.
    final planMatch = RegExp(r'^خطتي \((\d+)\)$').firstMatch(value);
    if (planMatch != null) {
      final n = planMatch.group(1)!;
      switch (code) {
        case 'en': return 'My Plan ($n)';
        case 'tr': return 'Planım ($n)';
        case 'ur': return 'میرا منصوبہ ($n)';
      }
    }

    final minutesMatch = RegExp(r'^(\d+) دقيقة$').firstMatch(value);
    if (minutesMatch != null) {
      final n = minutesMatch.group(1)!;
      switch (code) {
        case 'en': return '$n min';
        case 'tr': return '$n dk';
        case 'ur': return '$n منٹ';
      }
    }

    const alreadySuffix = ' موجود بالفعل في خطتك';
    if (value.endsWith(alreadySuffix)) {
      final place = value.substring(0, value.length - alreadySuffix.length);
      final p = tr(context, place);
      switch (code) {
        case 'en': return '$p is already in your plan';
        case 'tr': return '$p zaten planında';
        case 'ur': return '$p پہلے ہی آپ کے منصوبے میں ہے';
      }
    }

    const addedPrefix = 'تمت إضافة ';
    const addedSuffix = ' إلى خطتك';
    if (value.startsWith(addedPrefix) && value.endsWith(addedSuffix)) {
      final place = value.substring(addedPrefix.length, value.length - addedSuffix.length);
      final p = tr(context, place);
      switch (code) {
        case 'en': return '$p was added to your plan';
        case 'tr': return '$p planına eklendi';
        case 'ur': return '$p آپ کے منصوبے میں شامل ہوگیا';
      }
    }

    const soonSuffix = ' سيتم ربطها لاحقًا';
    if (value.endsWith(soonSuffix)) {
      final title = tr(context, value.substring(0, value.length - soonSuffix.length));
      switch (code) {
        case 'en': return '$title will be connected later';
        case 'tr': return '$title daha sonra bağlanacak';
        case 'ur': return '$title بعد میں منسلک کیا جائے گا';
      }
    }

    return value;
  }

  static String _pick(List<String> values, String code) {
    switch (code) {
      case 'en': return values[0];
      case 'tr': return values[1];
      case 'ur': return values[2];
      default: return values[0];
    }
  }
}

/// Drop-in replacement for Flutter's Text widget.
/// Existing Text(...) calls stay unchanged while their displayed text is localized.
class Text extends m.StatelessWidget {
  const Text(
    this.data, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  final String data;
  final m.TextStyle? style;
  final m.TextAlign? textAlign;
  final int? maxLines;
  final m.TextOverflow? overflow;

  @override
  m.Widget build(m.BuildContext context) {
    return m.Text(
      RihalTranslations.tr(context, data),
      style: style,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
