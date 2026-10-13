import 'package:flutter/material.dart' hide Text;
import '../localization/rihal_localized_text.dart';

import '../rihal_style.dart';
import 'trip_plan_screen.dart';
import 'rihal_trip_store.dart';
import 'instant_explore_screen.dart';
import 'profile_screen.dart';

/// شاشة رحلاتي
class MyTripsScreen extends StatefulWidget {
  const MyTripsScreen({super.key});

  @override
  State<MyTripsScreen> createState() => _MyTripsScreenState();
}

class _MyTripsScreenState extends State<MyTripsScreen> {
  bool upcoming = true;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: RihalTranslations.direction(context),
      child: Scaffold(
        backgroundColor: RihalStyle.background,

        // ============================================================
        // APP BAR
        // ============================================================
        appBar: AppBar(
          backgroundColor: RihalStyle.background,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,

          // زر الرجوع
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_forward_ios_rounded,
              color: RihalStyle.darkGreen,
              size: 21,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),

          title: const Text(
            'رحلاتي',
            style: TextStyle(
              color: RihalStyle.deepGreen,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        // ============================================================
        // BODY
        // ============================================================
        body: Column(
          children: [
            // --------------------------------------------------------
            // Tabs
            // --------------------------------------------------------
            Padding(
              padding: const EdgeInsets.fromLTRB(
                RihalStyle.pageHorizontalPadding,
                12,
                RihalStyle.pageHorizontalPadding,
                12,
              ),
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: RihalStyle.cardDecoration(
                  radius: 18,
                ),
                child: Row(
                  children: [
                    _tab(
                      label: 'القادمة',
                      value: true,
                    ),
                    _tab(
                      label: 'السابقة',
                      value: false,
                    ),
                  ],
                ),
              ),
            ),

            // --------------------------------------------------------
            // Trips content
            // --------------------------------------------------------
            Expanded(
              child: upcoming
                  ? _upcomingTrips()
                  : _previousTrips(),
            ),
          ],
        ),

        // ============================================================
        // BOTTOM NAVIGATION
        // ============================================================
        bottomNavigationBar: RihalBottomNavigation(
          selectedIndex: 0,

          onMyTrips: () {
            // الصفحة الحالية
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
                builder: (_) =>
                    const InstantExploreScreen(),
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
      ),
    );
  }

  // ================================================================
  // UPCOMING TRIPS
  // ================================================================

  Widget _upcomingTrips() {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        RihalStyle.pageHorizontalPadding,
        8,
        RihalStyle.pageHorizontalPadding,
        RihalStyle.pageBottomPadding,
      ),
      children: [
        ValueListenableBuilder<bool>(
          valueListenable: RihalTripStore.isSaved,
          builder: (
            context,
            isSaved,
            child,
          ) {
            if (isSaved) {
              return _tripCard();
            }

            return const Padding(
              padding: EdgeInsets.only(top: 95),
              child: Center(
                child: Text(
                  'لا توجد رحلات محفوظة بعد',
                  style: TextStyle(
                    fontSize: 18,
                    color: RihalStyle.brown,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  // ================================================================
  // PREVIOUS TRIPS
  // ================================================================

  Widget _previousTrips() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.luggage_outlined,
            size: 65,
            color: RihalStyle.brown.withValues(
              alpha: 0.65,
            ),
          ),

          const SizedBox(height: 14),

          const Text(
            'لا توجد رحلات سابقة',
            style: TextStyle(
              fontSize: 18,
              color: RihalStyle.brown,
            ),
          ),
        ],
      ),
    );
  }

  // ================================================================
  // TABS
  // ================================================================

  Widget _tab({
    required String label,
    required bool value,
  }) {
    final bool selected = upcoming == value;

    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(15),

        onTap: () {
          setState(() {
            upcoming = value;
          });
        },

        child: AnimatedContainer(
          duration: const Duration(
            milliseconds: 180,
          ),

          padding: const EdgeInsets.symmetric(
            vertical: 14,
          ),

          decoration: BoxDecoration(
            color: selected
                ? RihalStyle.darkGreen
                : Colors.transparent,

            borderRadius: BorderRadius.circular(15),
          ),

          child: Text(
            label,
            textAlign: TextAlign.center,

            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,

              color: selected
                  ? Colors.white
                  : RihalStyle.brown,
            ),
          ),
        ),
      ),
    );
  }

  // ================================================================
  // TRIP CARD
  // ================================================================

  Widget _tripCard() {
    return Material(
      color: Colors.transparent,

      child: InkWell(
        borderRadius: BorderRadius.circular(
          RihalStyle.cardRadius,
        ),

        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  const TripPlanScreen(
                readOnly: true,
              ),
            ),
          );
        },

        child: Container(
          width: double.infinity,

          padding: const EdgeInsets.all(13),

          decoration:
              RihalStyle.cardDecoration(),

          child: Row(
            children: [
              // ------------------------------------------------------
              // Trip information
              // ------------------------------------------------------
              Expanded(
                flex: 5,

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [
                    const Text(
                      'رحلتي إلى المدينة المنورة',

                      maxLines: 2,

                      style: TextStyle(
                        color: RihalStyle.deepGreen,
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 11),

                    const Row(
                      children: [
                        Icon(
                          Icons
                              .calendar_month_outlined,
                          color: RihalStyle.brown,
                          size: 17,
                        ),

                        SizedBox(width: 6),

                        Expanded(
                          child: Text(
                            '8 أكتوبر – 9 أكتوبر 2026',

                            style: TextStyle(
                              color:
                                  RihalStyle.brown,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    const Row(
                      children: [
                        Icon(
                          Icons.place_outlined,
                          color: RihalStyle.brown,
                          size: 17,
                        ),

                        SizedBox(width: 6),

                        Text(
                          '4 أماكن  •  يومان',

                          style: TextStyle(
                            color:
                                RihalStyle.brown,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    const Row(
                      children: [
                        Icon(
                          Icons
                              .arrow_back_rounded,
                          color:
                              RihalStyle.darkGreen,
                          size: 18,
                        ),

                        SizedBox(width: 4),

                        Text(
                          'عرض الخطة',

                          style: TextStyle(
                            color:
                                RihalStyle.darkGreen,
                            fontWeight:
                                FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              // ------------------------------------------------------
              // Trip image
              // ------------------------------------------------------
              Expanded(
                flex: 4,

                child: ClipRRect(
                  borderRadius:
                      BorderRadius.circular(16),

                  child: Image.asset(
                    'assets/images/quba_mosque.jpg',

                    height: 160,
                    fit: BoxFit.cover,

                    errorBuilder: (
                      context,
                      error,
                      stackTrace,
                    ) {
                      return Container(
                        height: 160,

                        color: RihalStyle
                            .cardBackgroundLight,

                        alignment: Alignment.center,

                        child: const Icon(
                          Icons.mosque_rounded,
                          size: 52,
                          color:
                              RihalStyle.darkGreen,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}