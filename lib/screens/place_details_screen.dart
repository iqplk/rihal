import 'package:flutter/material.dart' hide Text;
import '../localization/rihal_localized_text.dart';
import '../rihal_style.dart';
import 'explore_screen.dart';

class PlaceDetailsScreen extends StatefulWidget {
  final RihalPlace place;
  const PlaceDetailsScreen({super.key, required this.place});

  @override
  State<PlaceDetailsScreen> createState() => _PlaceDetailsScreenState();
}

class _PlaceDetailsScreenState extends State<PlaceDetailsScreen> {
  int tab = 0;

  bool get isMuseum => widget.place.name == 'متحف دار المدينة';
  bool get isQuba => widget.place.name == 'مسجد قباء';
  bool get isUhud => widget.place.name == 'جبل أحد';
  bool get isQubaWalk => widget.place.name == 'جادة قباء';
  bool get hasKnownHours => isMuseum || isQuba || isQubaWalk;
  String get locationLabel {
    if (isMuseum) return 'شرق المدينة المنورة';
    if (isUhud) return 'شمال المدينة المنورة';
    if (isQuba || isQubaWalk) return 'المدينة المنورة';
    return 'المدينة المنورة';
  }
  String get visitDuration {
    if (isUhud) return '1 – 2 ساعة (مقترحة)';
    if (isQubaWalk) return '1 – 3 ساعات (مقترحة)';
    return '1 – 2 ساعة (مقترحة)';
  }
  double get rating {
    if (isMuseum) return 4.8;
    if (isQuba) return 4.9;
    if (isUhud) return 4.8;
    if (isQubaWalk) return 4.7;
    return 4.8;
  }


  bool? get museumOpenNow => isMuseum ? true : null;

  String get description {
    if (isMuseum) {
      return 'متحف دار المدينة هو ذاكرة الحضارة الإسلامية في طيبة الطيبة، '
          'يجسد فصول السيرة النبوية، ويحفظ معالم المدينة التراثية وآثارها '
          'العمرانية وأحداثها التاريخية، ويستمتع زائروه برحلة ثقافية وجدانية فريدة.';
    }
    switch (widget.place.name) {
      case 'المسجد النبوي':
        return 'المسجد النبوي من أبرز المعالم الدينية في المدينة المنورة، ويقصده الزوار من مختلف أنحاء العالم.';
      case 'مسجد قباء':
        return 'أسسه الرسول ﷺ واختطه بيده عند وصوله إلى المدينة المنورة مهاجرًا من مكة المكرمة، وشارك في وضع أحجاره الأولى، ثم أكمله الصحابة رضي الله عنهم. وكان النبي ﷺ يزور مسجد قباء ويصلي فيه، وغالبًا ما يقصده يوم السبت. وقد ورد في فضله: «من تطهّر في بيته وأتى مسجد قباء فصلى فيه صلاة فله أجر عمرة».\n\n'
            'يُعد من أكبر مساجد المدينة المنورة بعد المسجد النبوي، وحظي بالعناية والتوسعة مع الحفاظ على معالمه التراثية. وتبلغ مساحة المصلى 5035 مترًا مربعًا، ومساحة مبنى المسجد ومرافقه 13500 متر مربع. وأُعلن مشروع توسعة الملك سلمان بن عبدالعزيز لمسجد قباء لتصل مساحته المستهدفة إلى 50 ألف متر مربع، وبطاقة استيعابية مستهدفة تصل إلى 66 ألف مصلٍ.';
      case 'جبل أحد':
        return 'يعتبر جبل أحد من أبرز المعالم التاريخية والجغرافية في المدينة المنورة، وله مكانة عظيمة في قلوب المسلمين. يقع الجبل في الجهة الشمالية من المسجد النبوي الشريف على بعد حوالي 5 كيلومترات. يبلغ طول الجبل 7 كيلومترات وعرضه بين 2 إلى 3 كيلومترات، ويصل ارتفاعه إلى 350 مترًا.';
      case 'جادة قباء':
        return 'وجهة سياحية متكاملة تحتضن عددًا من المهرجانات والفعاليات والأنشطة، وتربط الزائر بأعظم المعالم الإسلامية والتاريخية في المدينة المنوّرة.';
      default:
        return 'وجهة من وجهات المدينة المنورة يمكنك إضافتها إلى خطتك السياحية في رِحال. سنضيف معلوماتها التفصيلية لاحقًا.';
    }
  }

  String get qubaWalkDescription =>
      'طريق وجادة واسعة للمشاة تربط بين المسجد النبوي ومسجد قباء، تجمع الإرث التاريخي باللحظة المعاصرة وتستقطب جميع الأجيال. وهي ممشى مهيأ للفعاليات التجارية والثقافية والاجتماعية والرياضية، وتضم محلات تجارية ومطاعم وأكشاك أطعمة مدينية وجلسات جانبية، مع أنشطة مثل ركوب العربات وقيادة الدراجات الهوائية.';

  String get qubaWalkHistory =>
      'جادة قباء أحد مشاريع برنامج أنسنة المنطقة التي تنفّذه هيئة تطوير المدينة المنورة. ويرجع بعدها التاريخي إلى سلوك النبي ﷺ هذا الطريق في زيارته لمسجد قباء، إذ كان يذهب إلى مسجد قباء يوم السبت ماشيًا وراكبًا. وطُوّرت الجادة لتكون طريقًا للمشي والتنزه بين المسجد النبوي ومسجد قباء، مع خيارات للتسوق ومرافق جمالية وترفيهية.';

  String get museumHistory =>
      'يعد المتحف من أهم معالم المدينة، فهو أول متحف يعرض الإرث الحضاري الإسلامي '
      'بطرق إبداعية، ومجسمات تحاكي الواقع، وصور توثق التراث العمراني، '
      'مع الاهتمام بالسيرة النبوية، والمقتنيات الأثرية عبر العصور.\n\n'
      'وقد افتتح المتحف سنة 2011م، وكان الهدف من تأسيسه المحافظة على الآثار '
      'الإسلامية والمعمارية والنقوش التاريخية التي أُزيلت في محيط المسجد النبوي '
      'من أجل توسعته، ليتصل حاضر الأمة بماضيها، ولا تفقد الأجيال الجديدة '
      'شيئًا من إرث المدينة الحضاري الإسلامي.';

  String get categoryLabel {
    switch (widget.place.category) {
      case 'متاحف': return 'متحف وتجربة ثقافية';
      case 'دينية': return 'معلم ديني وتاريخي';
      case 'معالم': return 'معلم سياحي';
      case 'ترفيه': return 'وجهة ترفيهية';
      default: return widget.place.category;
    }
  }

  Widget _image() {
    final path = isMuseum
        ? 'assets/images/dar_al_madinah_museum.jpg'
        : isQubaWalk
            ? 'assets/images/j.jpg'
            : isUhud
                ? 'assets/images/a7d.jpeg'
                : isQuba
                    ? 'assets/images/quba_mosque.jpg'
                    : widget.place.imagePath;
    if (path == null) {
      return Container(
        color: RihalStyle.cardBackgroundLight,
        alignment: Alignment.center,
        child: Icon(widget.place.icon, size: 100, color: RihalStyle.darkGreen),
      );
    }
    return Image.asset(
      path,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Container(
        color: RihalStyle.cardBackgroundLight,
        alignment: Alignment.center,
        child: Icon(widget.place.icon, size: 90, color: RihalStyle.darkGreen),
      ),
    );
  }

  Widget _card({
    required Widget child,
    EdgeInsets padding = const EdgeInsets.all(16),
  }) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: RihalStyle.cardDecoration(radius: 20),
      child: child,
    );
  }

  Widget _heading(String value) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Text(value, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: RihalStyle.deepGreen)),
  );

  Widget _paragraph(String value) => Text(
    value,
    style: const TextStyle(fontSize: 14, height: 1.9, color: Color(0xFF62574E)),
  );

  Widget _hoursCard() {
    if (isMuseum) {
      return _card(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Row(children: [
          Icon(Icons.access_time_filled_rounded, color: RihalStyle.darkGreen, size: 26),
          SizedBox(width: 10),
          Text('مفتوح الآن', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: RihalStyle.darkGreen)),
        ]),
        const SizedBox(height: 12),
        const Row(children: [
          Icon(Icons.calendar_month_outlined, size: 20, color: RihalStyle.brown),
          SizedBox(width: 9),
          Expanded(child: Text('السبت – الخميس', style: TextStyle(color: RihalStyle.deepGreen, fontWeight: FontWeight.w600))),
          Text('11:00 ص – 6:00 م', style: TextStyle(color: RihalStyle.deepGreen)),
        ]),
        const SizedBox(height: 9),
        const Row(children: [
          Icon(Icons.event_busy_outlined, size: 20, color: RihalStyle.brown),
          SizedBox(width: 9),
          Expanded(child: Text('الجمعة', style: TextStyle(color: RihalStyle.deepGreen, fontWeight: FontWeight.w600))),
          Text('مغلق', style: TextStyle(color: RihalStyle.brown)),
        ]),
        const SizedBox(height: 9),
        const Text('المواعيد قابلة للتغيير في الإجازات والمناسبات.',
          style: TextStyle(fontSize: 11, color: Color(0xFF8A7D72))),
      ]));
    }
    if (isQuba || isQubaWalk) {
      return _card(child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(Icons.access_time_filled_rounded, color: RihalStyle.darkGreen, size: 26),
          SizedBox(width: 10),
          Text('مفتوح على مدار الساعة', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: RihalStyle.darkGreen)),
        ]),
        SizedBox(height: 10),
        Row(children: [
          Icon(Icons.calendar_month_outlined, color: RihalStyle.brown, size: 20),
          SizedBox(width: 9),
          Text('جميع أيام الأسبوع', style: TextStyle(color: RihalStyle.deepGreen)),
        ]),
      ]));
    }
    if (isUhud) {
      return _card(child: const Row(children: [
        Icon(Icons.landscape_outlined, color: RihalStyle.darkGreen),
        SizedBox(width: 12),
        Expanded(child: Text('مفتوح للزيارة — لا توجد ساعات محددة مذكورة', style: TextStyle(color: RihalStyle.deepGreen))),
      ]));
    }
    return _card(child: const Row(children: [
      Icon(Icons.access_time_rounded, color: RihalStyle.brown),
      SizedBox(width: 12),
      Expanded(child: Text('مواعيد العمل غير متوفرة حاليًا', style: TextStyle(color: RihalStyle.deepGreen))),
    ]));
  }

  Widget _infoTab() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _heading('عن المكان'),
      _paragraph(description),
      if (isQubaWalk) ...[
        const SizedBox(height: 22),
        _heading('ممشى متكامل'),
        _paragraph(qubaWalkDescription),
        const SizedBox(height: 22),
        _heading('البُعد التاريخي لجادة قباء'),
        _paragraph(qubaWalkHistory),
      ],
      if (isMuseum) ...[
        const SizedBox(height: 22),
        _heading('تاريخ المدينة وآثارها'),
        _paragraph(museumHistory),
        const SizedBox(height: 22),
        _heading('الموقع'),
        _card(child: const Row(children: [
          Icon(Icons.place_outlined, color: RihalStyle.brown),
          SizedBox(width: 10),
          Expanded(child: Text('مدينة المعرفة الاقتصادية، أمام محطة قطار الحرمين، شرق المدينة المنورة.',
              style: TextStyle(color: RihalStyle.deepGreen, height: 1.6))),
        ])),
      ],
    ],
  );

  Widget _photosTab() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _heading('صور المكان'),
      ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: SizedBox(height: 230, width: double.infinity, child: _image()),
      ),
      const SizedBox(height: 8),
      const SizedBox.shrink(),
    ],
  );

  Widget _reviewsTab() {
    final List<(String, String, int)> reviews;
    if (isMuseum) {
      reviews = [
        ('سارة', 'المتحف جميل ومجسماته تساعد على فهم تاريخ المدينة.', 5),
        ('عبدالله', 'تجربة ثقافية ممتعة، خصوصًا قسم السيرة النبوية.', 5),
        ('نورة', 'المعروضات مرتبة والمعلومات التاريخية ثرية.', 4),
      ];
    } else if (isQubaWalk) {
      reviews = [
        ('أمل', 'الممشى واسع وجميل، خصوصًا في المساء.', 5),
        ('فيصل', 'المقاهي والجلسات جعلت الزيارة ممتعة مع العائلة.', 4),
        ('ريم', 'أجواء رائعة للمشي واستكشاف المنطقة.', 5),
      ];
    } else if (isQuba) {
      reviews = [
        ('محمد', 'مسجد مميز بأجوائه الهادئة وتنظيمه الجميل.', 5),
        ('هدى', 'تجربة روحانية جميلة ومكان يستحق الزيارة.', 5),
        ('خالد', 'الساحات واسعة والوصول إليه ميسر.', 5),
      ];
    } else if (isUhud) {
      reviews = [
        ('يوسف', 'مكان تاريخي مؤثر وإطلالة الجبل مميزة.', 5),
        ('فاطمة', 'الزيارة عرّفتنا أكثر على أحداث غزوة أحد.', 5),
        ('بدر', 'أنصح بزيارته في الأوقات المعتدلة من اليوم.', 4),
      ];
    } else {
      reviews = [
        ('ليان', 'استمتعت بزيارة المكان والأجواء كانت جميلة.', 5),
        ('راشد', 'وجهة تستحق إضافتها إلى خطة الرحلة.', 4),
        ('هند', 'تجربة لطيفة وأتمنى زيارتها مرة أخرى.', 5),
      ];
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _heading('آراء الزوار'),
      const SizedBox(height: 14),
      for (final review in reviews) ...[
        _reviewCard(review.$1, review.$2, review.$3),
        const SizedBox(height: 12),
      ],
    ]);
  }

  Widget _reviewCard(String name, String comment, int stars) => _card(
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      CircleAvatar(backgroundColor: RihalStyle.cardBackgroundLight,
        child: const Icon(Icons.person_outline_rounded, color: RihalStyle.darkGreen)),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: Text(name, style: const TextStyle(fontWeight: FontWeight.bold, color: RihalStyle.deepGreen))),
          ...List.generate(5, (i) => Icon(
            i < stars ? Icons.star_rounded : Icons.star_border_rounded,
            size: 17, color: const Color(0xFFF2A11C))),
        ]),
        const SizedBox(height: 7),
        Text(comment, style: const TextStyle(color: Color(0xFF62574E), height: 1.6)),
      ])),
    ]),
  );

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: RihalTranslations.direction(context),
      child: Scaffold(
        backgroundColor: RihalStyle.background,
        body: Stack(children: [
          CustomScrollView(slivers: [
            SliverToBoxAdapter(child: SizedBox(
              height: 340,
              child: Stack(fit: StackFit.expand, children: [
                _image(),
                Positioned(
                  top: 0, right: 0, left: 0,
                  child: SafeArea(child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Material(
                        color: RihalStyle.cardBackground,
                        shape: const CircleBorder(),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_forward_ios_rounded, color: RihalStyle.darkGreen),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ),
                  )),
                ),
                Positioned(
                  bottom: 30, left: 18,
                  child: DecoratedBox(
                    decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(18)),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                      child: Text('1 / 1', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ),
              ]),
            )),
            SliverToBoxAdapter(child: Transform.translate(
              offset: const Offset(0, -22),
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 130),
                decoration: const BoxDecoration(
                  color: RihalStyle.background,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(widget.place.name, style: const TextStyle(color: RihalStyle.deepGreen, fontSize: 27, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 5),
                      Text(categoryLabel, style: const TextStyle(color: Color(0xFF7D7167), fontSize: 14)),
                    ])),
                    Container(
                      padding: const EdgeInsets.all(13),
                      decoration: BoxDecoration(color: RihalStyle.cardBackground, borderRadius: BorderRadius.circular(17), border: Border.all(color: RihalStyle.cardBorder)),
                      child: Icon(widget.place.icon, color: RihalStyle.brown, size: 30),
                    ),
                  ]),
                  const SizedBox(height: 15),
                  Row(children: [
                    Text(rating.toStringAsFixed(1), style: const TextStyle(color: RihalStyle.deepGreen, fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 7),
                    ...List.generate(5, (i) => Icon(
                      i < 4 ? Icons.star_rounded : Icons.star_half_rounded,
                      color: const Color(0xFFF2A11C), size: 22)),
                  ]),
                  const SizedBox(height: 18),
                  _hoursCard(),
                  const SizedBox(height: 14),
                  Row(children: [
                    Expanded(child: _card(padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8), child: Column(children: [
                      const Icon(Icons.schedule_rounded, color: RihalStyle.brown),
                      SizedBox(height: 7),
                      Text('مدة الزيارة', style: TextStyle(color: RihalStyle.deepGreen, fontWeight: FontWeight.bold, fontSize: 12)),
                      Text(visitDuration, textAlign: TextAlign.center, style: const TextStyle(fontSize: 10, color: Color(0xFF8A7D72))),
                    ]))),
                    const SizedBox(width: 10),
                    Expanded(child: _card(padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8), child: Column(children: [
                      const Icon(Icons.place_outlined, color: RihalStyle.brown),
                      const SizedBox(height: 7),
                      const Text('الموقع', style: TextStyle(color: RihalStyle.deepGreen, fontWeight: FontWeight.bold, fontSize: 12)),
                      Text(locationLabel,
                          textAlign: TextAlign.center, style: const TextStyle(fontSize: 10, color: Color(0xFF8A7D72))),
                    ]))),
                  ]),
                  const SizedBox(height: 22),
                  _card(padding: const EdgeInsets.all(5), child: Row(children: [
                    for (var i = 0; i < 3; i++) Expanded(child: InkWell(
                      onTap: () => setState(() => tab = i),
                      borderRadius: BorderRadius.circular(15),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: tab == i ? RihalStyle.darkGreen : Colors.transparent,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(['معلومات', 'صور', 'آراء الزوار'][i],
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
                              color: tab == i ? Colors.white : RihalStyle.deepGreen)),
                      ),
                    )),
                  ])),
                  const SizedBox(height: 22),
                  if (tab == 0) _infoTab(),
                  if (tab == 1) _photosTab(),
                  if (tab == 2) _reviewsTab(),
                ]),
              ),
            )),
          ]),
          Positioned(
            left: 18, right: 18, bottom: 18,
            child: SafeArea(top: false, child: SizedBox(
              height: RihalStyle.primaryButtonHeight,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pop(context, widget.place),
                icon: const Icon(Icons.add_rounded, size: 28),
                label: const Text('إضافة إلى خطتي', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                style: RihalStyle.primaryButtonStyle(),
              ),
            )),
          ),
        ]),
      ),
    );
  }
}
