import 'package:flutter/material.dart' hide Text;
import '../localization/rihal_localized_text.dart';

import '../rihal_style.dart';
import 'rihal_trip_store.dart';
import 'my_trips_screen.dart';
import 'instant_explore_screen.dart';
import 'map_screen.dart';
import 'profile_screen.dart';

// ============================================================================
// TRIP PLAN SCREEN
// ============================================================================
// هذه الشاشة تعتمد على rihal_style.dart فقط في الألوان والمقاسات والمكونات.
// لا نكرر ألوان أو شريط سفلي أو بطاقات داخل الشاشة.
// ============================================================================

class TripPlanScreen extends StatefulWidget {
  const TripPlanScreen({
    super.key,
    this.readOnly = false,
  });

  final bool readOnly;

  @override
  State<TripPlanScreen> createState() => _TripPlanScreenState();
}

class _TripPlanScreenState extends State<TripPlanScreen> {
  SelectedPlace? selectedAccommodation;

  int selectedDay = 0;
  bool planReady = false;
  bool saved = false;

  final List<List<_Stop>> days = const [
    [
      _Stop(
        'جبل أحد',
        '08:00 – 09:30 ص',
        'زيارة معلم تاريخي',
        'assets/images/uhud.jpg',
        Icons.landscape_rounded,
      ),
      _Stop(
        'متحف دار المدينة',
        '11:00 ص – 12:30 م',
        'تاريخ المدينة وتراثها',
        'assets/images/dar_al_madinah_museum.jpg',
        Icons.museum_rounded,
      ),
    ],
    [
      _Stop(
        'مسجد قباء',
        '09:00 – 10:00 ص',
        'زيارة المسجد والصلاة',
        'assets/images/quba_mosque.jpg',
        Icons.mosque_rounded,
      ),
      _Stop(
        'جادة قباء',
        '10:15 – 11:45 ص',
        'نزهة في الممشى',
        'assets/images/quba_walk.jpg',
        Icons.directions_walk_rounded,
      ),
    ],
  ];

  @override
  void initState() {
    super.initState();

    if (widget.readOnly) {
      planReady = true;
      saved = true;
    }
  }

  // ==========================================================================
  // LOCATION
  // ==========================================================================

  Future<void> _chooseLocation() async {
    final result = await Navigator.push<SelectedPlace>(
      context,
      MaterialPageRoute(
        builder: (_) => const MapScreen(),
      ),
    );

    if (!mounted || result == null) return;

    setState(() {
      selectedAccommodation = result;
    });
  }

  // ==========================================================================
  // BUILD
  // ==========================================================================

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: RihalTranslations.direction(context),
      child: Scaffold(
        backgroundColor: RihalStyle.background,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: RihalStyle.background,
          surfaceTintColor: Colors.transparent,
          centerTitle: true,
          title: const Text(
            'خطتي',
            style: TextStyle(
              color: RihalStyle.deepGreen,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_forward_ios_rounded,
              color: RihalStyle.darkGreen,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: RihalStyle.pagePadding,
                  children: [
                    _header(),

                    const SizedBox(height: RihalStyle.spaceLg),

                    if (!planReady)
                      _intro()
                    else ...[
                      _daySelector(),

                      const SizedBox(height: RihalStyle.spaceLg),

                      ...List.generate(
                        days[selectedDay].length,
                        (index) => Column(
                          children: [
                            _stopCard(
                              days[selectedDay][index],
                              index,
                            ),
                            if (selectedDay == 0 && index == 0)
                              _freeTimeCard(),
                          ],
                        ),
                      ),

                      const SizedBox(height: 14),

                      _note(),
                    ],
                  ],
                ),
              ),

              if (!widget.readOnly) _bottomButton(),

              RihalBottomNavigation(
                selectedIndex: 1,
                onMyTrips: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const MyTripsScreen(),
                    ),
                  );
                },
                onHome: () {
                  Navigator.of(context).popUntil(
                    (route) => route.isFirst,
                  );
                },
                onExplore: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const InstantExploreScreen(),
                    ),
                  );
                },
                onProfile: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ProfileScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================================================
  // HEADER CARD
  // ==========================================================================

  Widget _header() {
    return RihalCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'رحلتي إلى المدينة المنورة',
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
              color: RihalStyle.darkGreen,
            ),
          ),

          const SizedBox(height: 10),

          const Row(
            children: [
              Icon(
                Icons.calendar_month_outlined,
                color: RihalStyle.brown,
                size: 20,
              ),
              SizedBox(width: 7),
              Text(
                'يومان',
                style: TextStyle(
                  fontSize: 16,
                  color: RihalStyle.brown,
                ),
              ),
              SizedBox(width: 20),
              Icon(
                Icons.place_outlined,
                color: RihalStyle.brown,
                size: 20,
              ),
              SizedBox(width: 7),
              Text(
                '4 أماكن',
                style: TextStyle(
                  fontSize: 16,
                  color: RihalStyle.brown,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // INTRO CARD
  // ==========================================================================

  Widget _intro() {
    return RihalCard(
      padding: const EdgeInsets.symmetric(
        horizontal: 22,
        vertical: 30,
      ),
      child: const Column(
        children: [
          Icon(
            Icons.auto_awesome_rounded,
            color: RihalStyle.darkGreen,
            size: 52,
          ),

          SizedBox(height: 18),

          Text(
            'أماكنك جاهزة للترتيب',
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
              color: RihalStyle.darkGreen,
            ),
          ),

          SizedBox(height: 10),

          Text(
            'سنوزّع الأماكن الأربعة على يومين، مع مراعاة قرب الوجهات ومواعيد زيارتها.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              height: 1.8,
              color: RihalStyle.brown,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // DAY SELECTOR
  // ==========================================================================

  Widget _daySelector() {
    return Row(
      children: List.generate(
        2,
        (index) {
          final active = selectedDay == index;

          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                left: index == 0 ? 8 : 0,
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(
                  RihalStyle.buttonRadius,
                ),
                onTap: () {
                  setState(() {
                    selectedDay = index;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                  ),
                  decoration: BoxDecoration(
                    color: active
                        ? RihalStyle.darkGreen
                        : RihalStyle.cardBackground,
                    borderRadius: BorderRadius.circular(
                      RihalStyle.buttonRadius,
                    ),
                    border: Border.all(
                      color: active
                          ? RihalStyle.darkGreen
                          : RihalStyle.cardBorder,
                    ),
                    boxShadow: active
                        ? null
                        : [
                            BoxShadow(
                              color: RihalStyle.brown.withValues(
                                alpha: 0.07,
                              ),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    index == 0
                        ? 'اليوم الأول'
                        : 'اليوم الثاني',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: active
                          ? Colors.white
                          : RihalStyle.brown,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ==========================================================================
  // STOP CARD
  // ==========================================================================

  Widget _stopCard(
    _Stop stop,
    int index,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 13),
      child: RihalCard(
        padding: const EdgeInsets.all(13),
        child: Row(
          children: [
            Container(
              height: 37,
              width: 37,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: RihalStyle.darkGreen,
                shape: BoxShape.circle,
              ),
              child: Text(
                '${index + 1}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
            ),

            const SizedBox(width: 12),

            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.asset(
                stop.image,
                width: 87,
                height: 91,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) {
                  return Container(
                    width: 87,
                    height: 91,
                    color: RihalStyle.cardBackgroundLight,
                    child: Icon(
                      stop.icon,
                      size: 38,
                      color: RihalStyle.brown,
                    ),
                  );
                },
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    stop.time,
                    style: const TextStyle(
                      fontSize: 13,
                      color: RihalStyle.brown,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    stop.name,
                    style: const TextStyle(
                      fontSize: 17,
                      color: RihalStyle.deepGreen,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    stop.subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: RihalStyle.secondaryText,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================================
  // FREE TIME CARD
  // ==========================================================================

  Widget _freeTimeCard() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const InstantExploreScreen(),
              ),
            );
          },
          borderRadius: BorderRadius.circular(18),
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: RihalStyle.cardBackground,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: RihalStyle.cardBorder,
              ),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.bolt_rounded,
                  color: RihalStyle.darkGreen,
                  size: 30,
                ),

                SizedBox(width: 10),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'وقت فراغ: 9:30 – 11:00 ص',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: RihalStyle.darkGreen,
                          fontSize: 15,
                        ),
                      ),

                      SizedBox(height: 4),

                      Text(
                        'استكشف مكانًا قبل متحف دار المدينة',
                        style: TextStyle(
                          color: RihalStyle.brown,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: RihalStyle.darkGreen,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================================================
  // NOTE
  // ==========================================================================

  Widget _note() {
    return const Padding(
      padding: EdgeInsets.all(8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: 19,
            color: RihalStyle.brown,
          ),

          SizedBox(width: 8),

          Expanded(
            child: Text(
              'الأوقات مقترحة للعرض، ويُراعى التحقق من مواعيد الأماكن قبل الزيارة.',
              style: TextStyle(
                color: RihalStyle.brown,
                fontSize: 13,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // PRIMARY BUTTON
  // ==========================================================================

  Widget _bottomButton() {
    return Container(
      color: RihalStyle.background,
      padding: const EdgeInsets.fromLTRB(
        17,
        8,
        17,
        12,
      ),
      child: SizedBox(
        width: double.infinity,
        height: RihalStyle.primaryButtonHeight,
        child: ElevatedButton.icon(
          style: RihalStyle.primaryButtonStyle(),
          icon: Icon(
            planReady
                ? Icons.bookmark_added_outlined
                : Icons.auto_awesome_rounded,
            size: 24,
          ),
          label: Text(
            planReady
                ? (saved
                    ? 'تم حفظ رحلتي'
                    : 'حفظ رحلتي')
                : 'رتّب رحلتي',
            style: const TextStyle(
              fontSize: RihalStyle.primaryButtonTextSize,
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () {
            if (!planReady) {
              setState(() {
                planReady = true;
                selectedDay = 0;
              });
              return;
            }

            RihalTripStore.save();

            setState(() {
              saved = true;
            });

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const MyTripsScreen(),
              ),
            );
          },
        ),
      ),
    );
  }
}

// ============================================================================
// STOP MODEL
// ============================================================================

class _Stop {
  final String name;
  final String time;
  final String subtitle;
  final String image;
  final IconData icon;

  const _Stop(
    this.name,
    this.time,
    this.subtitle,
    this.image,
    this.icon,
  );
}
