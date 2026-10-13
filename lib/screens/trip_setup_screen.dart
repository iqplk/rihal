import 'package:flutter/material.dart' hide Text;
import '../localization/rihal_localized_text.dart';
import 'package:latlong2/latlong.dart';

import 'map_screen.dart';
import 'explore_screen.dart';
import 'instant_explore_screen.dart';
import 'my_trips_screen.dart';
import '../rihal_style.dart';
import '../localization/locale_controller.dart';

class TripSetupScreen extends StatefulWidget {
  const TripSetupScreen({super.key});

  @override
  State<TripSetupScreen> createState() => _TripSetupScreenState();
}

class _TripSetupScreenState extends State<TripSetupScreen> {
  // ==========================================
  // LANGUAGE
  // ==========================================

  String get selectedLanguage =>
      LocaleScope.of(context).locale.languageCode;

  final List<_RihalLanguage> languages = const [
    _RihalLanguage(
      'ar',
      'العربية',
      '🇸🇦',
    ),
    _RihalLanguage(
      'en',
      'English',
      '🇺🇸',
    ),
    _RihalLanguage(
      'tr',
      'Türkçe',
      '🇹🇷',
    ),
    _RihalLanguage(
      'ur',
      'Urdu',
      '🇵🇰',
    ),
  ];

  bool get isRtl =>
      selectedLanguage == 'ar' ||
      selectedLanguage == 'ur';

  String tr(
    String ar,
    String en,
    String turkish,
    String ur,
  ) {
    switch (selectedLanguage) {
      case 'en':
        return en;

      case 'tr':
        return turkish;

      case 'ur':
        return ur;

      default:
        return ar;
    }
  }

  // ==========================================
  // TRIP DATA
  // ==========================================

  DateTime? startDate;
  DateTime? endDate;

  LatLng? selectedHomeLocation;
  String selectedHomeName = '';

  // ==========================================
  // PLAN TIME
  // ==========================================
  //
  // morning = صباحي
  // evening = مسائي
  // both = كلاهما
  //
  // لاحقًا نرسل هذه القيمة للـ Planner / AI.
  // ==========================================

  String? selectedPlanTime;

  // ==========================================
  // INTERESTS
  // ==========================================

  final Set<String> selectedInterests = {};

  final List<_TravelInterest> interests = const [
    _TravelInterest(
      'nature',
      Icons.terrain_rounded,
      'طبيعة',
      'Nature',
      'Doğa',
      'قدرتی مقامات',
    ),

    _TravelInterest(
      'religious',
      Icons.mosque_outlined,
      'أماكن دينية',
      'Religious sites',
      'Dini yerler',
      'مذہبی مقامات',
    ),

    _TravelInterest(
      'adventure',
      Icons.hiking_rounded,
      'مغامرة',
      'Adventure',
      'Macera',
      'مہم جوئی',
    ),

    _TravelInterest(
      'events',
      Icons.local_activity_outlined,
      'فعاليات',
      'Events',
      'Etkinlikler',
      'تقریبات',
    ),

    _TravelInterest(
      'shopping',
      Icons.shopping_bag_outlined,
      'تسوق',
      'Shopping',
      'Alışveriş',
      'خریداری',
    ),

    _TravelInterest(
      'culture',
      Icons.museum_outlined,
      'تراث وثقافة',
      'Heritage & culture',
      'Miras ve kültür',
      'ورثہ اور ثقافت',
    ),

    _TravelInterest(
      'history',
      Icons.account_balance_outlined,
      'مواقع تاريخية',
      'Historical sites',
      'Tarihi yerler',
      'تاریخی مقامات',
    ),
  ];

  bool get allInterestsSelected =>
      selectedInterests.length ==
      interests.length;

  bool get isTripReady =>
      startDate != null &&
      endDate != null &&
      selectedPlanTime != null &&
      selectedHomeLocation != null;

  int get numberOfDays {
    if (startDate == null ||
        endDate == null) {
      return 0;
    }

    return endDate!
            .difference(startDate!)
            .inDays +
        1;
  }

  String _interestTitle(
    _TravelInterest item,
  ) {
    return tr(
      item.ar,
      item.en,
      item.turkish,
      item.ur,
    );
  }

  // ==========================================
  // PLAN TIME
  // ==========================================

  void _selectPlanTime(
    String value,
  ) {
    setState(() {
      selectedPlanTime = value;
    });
  }

  // ==========================================
  // INTERESTS
  // ==========================================

  void _toggleAllInterests() {
    setState(() {
      if (allInterestsSelected) {
        selectedInterests.clear();
      } else {
        selectedInterests
          ..clear()
          ..addAll(
            interests.map(
              (item) => item.id,
            ),
          );
      }
    });
  }

  void _toggleInterest(
    String id,
  ) {
    setState(() {
      if (selectedInterests.contains(id)) {
        selectedInterests.remove(id);
      } else {
        selectedInterests.add(id);
      }
    });
  }

  // ==========================================
  // DATE PICKER
  // ==========================================

  Future<DateTime?> _pickDate({
    required DateTime initialDate,
    required DateTime firstDate,
    required DateTime lastDate,
    required String title,
  }) {
    return showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      helpText: title,
      cancelText: tr(
        'إلغاء',
        'Cancel',
        'İptal',
        'منسوخ کریں',
      ),
      confirmText: tr(
        'تأكيد',
        'Confirm',
        'Onayla',
        'تصدیق',
      ),
      builder: (
        context,
        child,
      ) {
        return Theme(
          data: Theme.of(context)
              .copyWith(
            colorScheme:
                const ColorScheme.light(
              primary:
                  RihalStyle.darkGreen,
              onPrimary:
                  Colors.white,
              surface:
                  Color(0xFFFFFCF8),
              onSurface:
                  RihalStyle.deepGreen,
            ),
          ),
          child: Directionality(
            textDirection: isRtl
                ? TextDirection.rtl
                : TextDirection.ltr,
            child: child!,
          ),
        );
      },
    );
  }

  Future<void>
      _selectStartDate() async {
    final now = DateTime.now();

    final today = DateTime(
      now.year,
      now.month,
      now.day,
    );

    final picked =
        await _pickDate(
      initialDate:
          startDate != null &&
                  !startDate!
                      .isBefore(today)
              ? startDate!
              : today,
      firstDate: today,
      lastDate: DateTime(
        today.year + 3,
        12,
        31,
      ),
      title: tr(
        'تاريخ الوصول',
        'Arrival date',
        'Varış tarihi',
        'آمد کی تاریخ',
      ),
    );

    if (!mounted ||
        picked == null) {
      return;
    }

    setState(() {
      startDate = picked;

      if (endDate != null &&
          endDate!
              .isBefore(picked)) {
        endDate = null;
      }
    });
  }

  Future<void>
      _selectEndDate() async {
    if (startDate == null) {
      _showMessage(
        tr(
          'حددي تاريخ الوصول أولًا',
          'Select your arrival date first',
          'Önce varış tarihini seçin',
          'پہلے آمد کی تاریخ منتخب کریں',
        ),
      );

      return;
    }

    final picked =
        await _pickDate(
      initialDate:
          endDate != null &&
                  !endDate!.isBefore(
                    startDate!,
                  )
              ? endDate!
              : startDate!,
      firstDate: startDate!,
      lastDate: DateTime(
        startDate!.year + 3,
        12,
        31,
      ),
      title: tr(
        'تاريخ المغادرة',
        'Departure date',
        'Ayrılış tarihi',
        'روانگی کی تاریخ',
      ),
    );

    if (!mounted ||
        picked == null) {
      return;
    }

    setState(() {
      endDate = picked;
    });
  }

  String _formatDate(
    DateTime? date,
  ) {
    if (date == null) {
      return tr(
        'اختر التاريخ',
        'Select date',
        'Tarih seçin',
        'تاریخ منتخب کریں',
      );
    }

    const months = [
      '',
      'يناير',
      'فبراير',
      'مارس',
      'أبريل',
      'مايو',
      'يونيو',
      'يوليو',
      'أغسطس',
      'سبتمبر',
      'أكتوبر',
      'نوفمبر',
      'ديسمبر',
    ];

    if (selectedLanguage ==
        'ar') {
      return '${date.day} ${months[date.month]} ${date.year}';
    }

    return '${date.day}/${date.month}/${date.year}';
  }

  // ==========================================
  // MAP
  // ==========================================

  Future<void> _openMap() async {
    final SelectedPlace? place =
        await Navigator.push<
            SelectedPlace>(
      context,
      MaterialPageRoute(
        builder: (_) =>
            const MapScreen(),
      ),
    );

    if (!mounted ||
        place == null) {
      return;
    }

    setState(() {
      selectedHomeLocation =
          place.location;

      selectedHomeName =
          place.name;
    });
  }

  // ==========================================
  // EXPLORE
  // ==========================================

  void _explorePlaces() {
    if (startDate == null ||
        endDate == null) {
      _showMessage(
        tr(
          'حددي تاريخ الوصول والمغادرة أولًا',
          'Select arrival and departure dates first',
          'Önce seyahat tarihlerini seçin',
          'پہلے سفر کی تاریخیں منتخب کریں',
        ),
      );

      return;
    }

    if (selectedPlanTime == null) {
      _showMessage(
        tr(
          'حددي الوقت المفضل للخطة أولًا',
          'Select your preferred trip time first',
          'Önce tercih ettiğiniz gezi zamanını seçin',
          'پہلے سفر کا پسندیدہ وقت منتخب کریں',
        ),
      );

      return;
    }

    if (selectedHomeLocation == null) {
      _showMessage(
        tr(
          'حددي موقع الإقامة أولًا',
          'Select your accommodation location first',
          'Önce konaklama yerinizi seçin',
          'پہلے رہائش کا مقام منتخب کریں',
        ),
      );

      return;
    }

    // ========================================
    // لاحقًا نرسل للـ Planner:
    //
    // startDate
    // endDate
    // selectedPlanTime
    // selectedHomeLocation
    // selectedInterests
    //
    // ========================================

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            const ExploreScreen(),
      ),
    );
  }

  // ==========================================
  // MESSAGE
  // ==========================================

  void _showMessage(
    String message,
  ) {
    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign:
              TextAlign.center,
        ),
        backgroundColor:
            RihalStyle.darkGreen,
        behavior:
            SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(
            14,
          ),
        ),
      ),
    );
  }

  // ==========================================
  // BUILD
  // ==========================================

  @override
  Widget build(
    BuildContext context,
  ) {
    return Directionality(
      textDirection: isRtl
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: Scaffold(
        backgroundColor:
            RihalStyle.background,

        body: SafeArea(
          bottom: false,
          child:
              SingleChildScrollView(
            physics:
                const BouncingScrollPhysics(),
            padding:
                RihalStyle.pagePadding,
            child: Column(
              children: [
                // ==================================
                // LANGUAGE
                // ==================================

                RihalLanguageSelector(
                  currentCode:
                      selectedLanguage,
                  languages: languages
                      .map(
                        (e) =>
                            RihalLanguageOption(
                          e.code,
                          e.name,
                          e.flag,
                        ),
                      )
                      .toList(),
                  onChanged: (code) =>
                      LocaleScope.of(
                    context,
                  ).setLocale(
                    Locale(code),
                  ),
                ),

                const SizedBox(
                  height: 2,
                ),

                // ==================================
                // HERO
                // ==================================

                RihalHeroHeader(
                  title: tr(
                    'رحلتك على طريقتك',
                    'Your trip, your way',
                    'Seyahatiniz, sizin tarzınız',
                    'آپ کا سفر، آپ کے انداز میں',
                  ),
                  subtitle: tr(
                    'اكتشف وجهات جديدة وتجارب أصيلة',
                    'Discover new destinations and authentic experiences',
                    'Yeni rotalar ve özgün deneyimler keşfedin',
                    'نئی منزلیں اور منفرد تجربات دریافت کریں',
                  ),
                ),

                const SizedBox(
                  height: 6,
                ),

                // ==================================
                // TRIP DATES
                // ==================================

                RihalCard(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                    children: [
                      RihalSectionHeading(
                        icon: Icons
                            .calendar_month_rounded,
                        title: tr(
                          'متى رحلتك؟',
                          'When is your trip?',
                          'Seyahatiniz ne zaman?',
                          'آپ کا سفر کب ہے؟',
                        ),
                        subtitle: tr(
                          'اختر تاريخ الوصول والمغادرة',
                          'Choose arrival and departure dates',
                          'Varış ve ayrılış tarihlerini seçin',
                          'آمد اور روانگی کی تاریخیں منتخب کریں',
                        ),
                      ),

                      const SizedBox(
                        height: 12,
                      ),

                      Row(
                        children: [
                          Expanded(
                            child:
                                RihalDateField(
                              title: tr(
                                'الوصول',
                                'Arrival',
                                'Varış',
                                'آمد',
                              ),
                              date:
                                  _formatDate(
                                startDate,
                              ),
                              onTap:
                                  _selectStartDate,
                            ),
                          ),

                          const SizedBox(
                            width: 9,
                          ),

                          Expanded(
                            child:
                                RihalDateField(
                              title: tr(
                                'المغادرة',
                                'Departure',
                                'Ayrılış',
                                'روانگی',
                              ),
                              date:
                                  _formatDate(
                                endDate,
                              ),
                              onTap:
                                  _selectEndDate,
                            ),
                          ),
                        ],
                      ),

                      if (numberOfDays >
                          0) ...[
                        const SizedBox(
                          height: 10,
                        ),

                        RihalDaysBadge(
                          text: tr(
                            numberOfDays ==
                                    1
                                ? 'يوم واحد من التجارب المميزة'
                                : '$numberOfDays أيام من التجارب المميزة',
                            '$numberOfDays days of memorable experiences',
                            '$numberOfDays günlük özel deneyimler',
                            '$numberOfDays دن کے یادگار تجربات',
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(
                  height: 11,
                ),

                // ==================================
                // PREFERRED PLAN TIME
                // ==================================

                RihalCard(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                    children: [
                      RihalSectionHeading(
                        icon: Icons
                            .schedule_rounded,
                        title: tr(
                          'متى تفضّل تكون خطتك؟',
                          'When do you prefer your itinerary?',
                          'Gezi planınızı ne zaman tercih edersiniz?',
                          'آپ اپنے سفر کا منصوبہ کب پسند کرتے ہیں؟',
                        ),
                        subtitle: tr(
                          'اختر الوقت الأنسب لخروجك واستكشاف المدينة',
                          'Choose your preferred time to explore',
                          'Şehri keşfetmek için tercih ettiğiniz zamanı seçin',
                          'شہر گھومنے کے لیے اپنا پسندیدہ وقت منتخب کریں',
                        ),
                      ),

                      const SizedBox(
                        height: 12,
                      ),

                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          RihalInterestChip(
                            title: tr(
                              'صباحي',
                              'Morning',
                              'Sabah',
                              'صبح',
                            ),
                            icon: Icons
                                .wb_sunny_outlined,
                            selected:
                                selectedPlanTime ==
                                    'morning',
                            onTap: () =>
                                _selectPlanTime(
                              'morning',
                            ),
                          ),

                          RihalInterestChip(
                            title: tr(
                              'مسائي',
                              'Evening',
                              'Akşam',
                              'شام',
                            ),
                            icon: Icons
                                .nightlight_outlined,
                            selected:
                                selectedPlanTime ==
                                    'evening',
                            onTap: () =>
                                _selectPlanTime(
                              'evening',
                            ),
                          ),

                          RihalInterestChip(
                            title: tr(
                              'كلاهما',
                              'Both',
                              'Her ikisi',
                              'دونوں',
                            ),
                            icon: Icons
                                .schedule_outlined,
                            selected:
                                selectedPlanTime ==
                                    'both',
                            onTap: () =>
                                _selectPlanTime(
                              'both',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(
                  height: 11,
                ),

                // ==================================
                // ACCOMMODATION
                // ==================================

                RihalCard(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                    children: [
                      RihalSectionHeading(
                        icon: Icons
                            .location_on_rounded,
                        title: tr(
                          'مكان إقامتك',
                          'Your accommodation',
                          'Konaklama yeriniz',
                          'آپ کی رہائش',
                        ),
                        subtitle: tr(
                          'اختر موقع الفندق أو سكنك على الخريطة',
                          'Choose your accommodation on the map',
                          'Konaklama yerinizi haritadan seçin',
                          'نقشے پر اپنی رہائش منتخب کریں',
                        ),
                      ),

                      const SizedBox(
                        height: 12,
                      ),

                      RihalAccommodationField(
                        title:
                            selectedHomeLocation ==
                                    null
                                ? tr(
                                    'حدد موقع إقامتك',
                                    'Select accommodation',
                                    'Konaklama yeri seçin',
                                    'رہائش کا مقام منتخب کریں',
                                  )
                                : selectedHomeName,
                        subtitle: tr(
                          'اضغط لفتح الخريطة',
                          'Tap to open map',
                          'Haritayı açmak için dokunun',
                          'نقشہ کھولنے کے لیے دبائیں',
                        ),
                        onTap: _openMap,
                      ),
                    ],
                  ),
                ),

                const SizedBox(
                  height: 11,
                ),

                // ==================================
                // INTERESTS
                // ==================================

                RihalCard(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                    children: [
                      RihalSectionHeading(
                        icon: Icons
                            .favorite_border_rounded,
                        title: tr(
                          'اهتماماتك',
                          'Your interests',
                          'İlgi alanlarınız',
                          'آپ کی دلچسپیاں',
                        ),
                        subtitle: tr(
                          'اختر ما يهمك لنقترح لك تجارب مناسبة',
                          'Choose what interests you',
                          'İlgi alanlarınızı seçin',
                          'اپنی دلچسپیاں منتخب کریں',
                        ),
                      ),

                      const SizedBox(
                        height: 12,
                      ),

                      Wrap(
                        spacing: 7,
                        runSpacing: 7,
                        children: [
                          RihalInterestChip(
                            title: tr(
                              'الكل',
                              'All',
                              'Tümü',
                              'سب',
                            ),
                            icon:
                                Icons.apps_rounded,
                            selected:
                                allInterestsSelected,
                            onTap:
                                _toggleAllInterests,
                          ),

                          ...interests.map(
                            (item) =>
                                RihalInterestChip(
                              title:
                                  _interestTitle(
                                item,
                              ),
                              icon:
                                  item.icon,
                              selected:
                                  selectedInterests
                                      .contains(
                                item.id,
                              ),
                              onTap: () =>
                                  _toggleInterest(
                                item.id,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // ==========================================
        // BOTTOM AREA
        // ==========================================

        bottomNavigationBar:
            RihalBottomArea(
          buttonLabel: tr(
            'استكشف وجهاتك',
            'Explore destinations',
            'Rotaları keşfet',
            'مقامات دریافت کریں',
          ),

          isReady: isTripReady,

          onButtonPressed:
              _explorePlaces,

          myTripsLabel: tr(
            'رحلاتي',
            'My trips',
            'Gezilerim',
            'میرے سفر',
          ),

          homeLabel: tr(
            'الرئيسية',
            'Home',
            'Ana sayfa',
            'ہوم',
          ),

          exploreLabel: tr(
            'استكشاف لحظي',
            'Explore now',
            'Anlık keşif',
            'فوری دریافت',
          ),

          onMyTrips: () =>
              Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  const MyTripsScreen(),
            ),
          ),

          onHome: () {},

          onExplore: () =>
              Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  const InstantExploreScreen(),
            ),
          ),
        ),
      ),
    );
  }
}

// ==========================================
// MODELS
// ==========================================

class _RihalLanguage {
  final String code;
  final String name;
  final String flag;

  const _RihalLanguage(
    this.code,
    this.name,
    this.flag,
  );
}

class _TravelInterest {
  final String id;
  final IconData icon;
  final String ar;
  final String en;
  final String turkish;
  final String ur;

  const _TravelInterest(
    this.id,
    this.icon,
    this.ar,
    this.en,
    this.turkish,
    this.ur,
  );
}