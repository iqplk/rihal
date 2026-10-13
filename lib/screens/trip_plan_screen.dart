import 'package:flutter/material.dart' hide Text;
import '../localization/rihal_localized_text.dart';

import '../rihal_style.dart';

import 'my_trips_screen.dart';
import 'instant_explore_screen.dart';
import 'profile_screen.dart';

// ============================================================================
// TRIP PLAN SCREEN
// ============================================================================
//
// هذه الشاشة جاهزة لاستقبال الخطة من الـ AI لاحقًا.
//
// لا توجد أي خطة ثابتة أو أماكن محفوظة داخل الشاشة.
// عند ربط الـ AI سنضع النتيجة داخل aiPlanDays.
//
// موقع الإقامة والوقت يتم تحديدهم مسبقًا في Trip Setup.
//
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
  int selectedDay = 0;

  bool isGenerating = false;

  // ==========================================================================
  // AI RESULT
  // ==========================================================================
  //
  // لاحقًا الـ Backend / AI سيرسل لنا الخطة ونضعها هنا.
  //
  // مثال:
  //
  // aiPlanDays = [
  //   AiTripDay(
  //     title: 'اليوم الأول',
  //     stops: [
  //       AiTripStop(
  //         name: 'مسجد قباء',
  //         time: '09:00 - 10:00',
  //         subtitle: 'زيارة المسجد',
  //         image: 'assets/images/quba_mosque.jpg',
  //         icon: Icons.mosque_rounded,
  //       ),
  //     ],
  //   ),
  // ];
  //
  // ==========================================================================

  List<AiTripDay> aiPlanDays = [];

  bool get planReady => aiPlanDays.isNotEmpty;

  // ==========================================================================
  // AI GENERATION
  // ==========================================================================

  Future<void> _generateTripWithAi() async {
    if (isGenerating) return;

    setState(() {
      isGenerating = true;
    });

    // ========================================================================
    // TODO:
    // هنا سنربط FastAPI / AI Planner.
    //
    // البيانات سترسل من Trip Setup + الأماكن المختارة من Explore.
    //
    // مثال:
    //
    // - الأماكن المختارة
    // - موقع الإقامة
    // - وقت البداية
    // - وقت النهاية
    // - وسيلة التنقل
    //
    // والـ Planner يرجع:
    //
    // - الأيام
    // - الأماكن المرتبة
    // - وقت كل زيارة
    // - مدة التنقل
    // - الأماكن التي لم تدخل في الخطة
    //
    // ========================================================================

    await Future.delayed(
      const Duration(milliseconds: 500),
    );

    if (!mounted) return;

    setState(() {
      isGenerating = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          RihalTranslations.tr(
            context,
            'سيتم ربط مخطط الذكاء الاصطناعي هنا',
          ),
          textAlign: TextAlign.center,
        ),
        backgroundColor: RihalStyle.darkGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }

  // ==========================================================================
  // BUILD
  // ==========================================================================

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection:
          RihalTranslations.direction(context),
      child: Scaffold(
        backgroundColor:
            RihalStyle.background,

        appBar: AppBar(
          elevation: 0,
          backgroundColor:
              RihalStyle.background,
          surfaceTintColor:
              Colors.transparent,
          centerTitle: true,

          title: Text(
            RihalTranslations.tr(
              context,
              'خطتي',
            ),
            style: const TextStyle(
              color:
                  RihalStyle.deepGreen,
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          leading: IconButton(
            icon: const Icon(
              Icons
                  .arrow_forward_ios_rounded,
              color:
                  RihalStyle.darkGreen,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),

        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  physics:
                      const BouncingScrollPhysics(),
                  padding:
                      RihalStyle.pagePadding,
                  children: [
                    _header(),

                    const SizedBox(
                      height:
                          RihalStyle.spaceLg,
                    ),

                    if (!planReady)
                      _intro()
                    else ...[
                      _daySelector(),

                      const SizedBox(
                        height:
                            RihalStyle.spaceLg,
                      ),

                      ...List.generate(
                        aiPlanDays[
                                selectedDay]
                            .stops
                            .length,
                        (index) {
                          final stop =
                              aiPlanDays[
                                      selectedDay]
                                  .stops[index];

                          return _stopCard(
                            stop,
                            index,
                          );
                        },
                      ),

                      const SizedBox(
                        height: 14,
                      ),

                      _note(),
                    ],
                  ],
                ),
              ),

              if (!widget.readOnly)
                _bottomButton(),

              RihalBottomNavigation(
                selectedIndex: 1,

                onMyTrips: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const MyTripsScreen(),
                    ),
                  );
                },

                onHome: () {
                  Navigator.of(context)
                      .popUntil(
                    (route) =>
                        route.isFirst,
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
                      builder: (_) =>
                          const ProfileScreen(),
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
  // HEADER
  // ==========================================================================

  Widget _header() {
    return RihalCard(
      padding:
          const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            RihalTranslations.tr(
              context,
              'رحلتي إلى المدينة المنورة',
            ),
            style: const TextStyle(
              fontSize: 23,
              fontWeight:
                  FontWeight.bold,
              color:
                  RihalStyle.darkGreen,
            ),
          ),

          const SizedBox(
            height: 10,
          ),

          Row(
            children: [
              const Icon(
                Icons.auto_awesome_rounded,
                color:
                    RihalStyle.brown,
                size: 20,
              ),

              const SizedBox(
                width: 7,
              ),

              Expanded(
                child: Text(
                  planReady
                      ? RihalTranslations
                          .tr(
                          context,
                          'تم إنشاء خطتك',
                        )
                      : RihalTranslations
                          .tr(
                          context,
                          'سيتم ترتيب الأماكن تلقائيًا',
                        ),
                  style:
                      const TextStyle(
                    fontSize: 15,
                    color:
                        RihalStyle.brown,
                  ),
                ),
              ),

              if (planReady) ...[
                const SizedBox(
                  width: 12,
                ),

                const Icon(
                  Icons
                      .place_outlined,
                  color:
                      RihalStyle.brown,
                  size: 20,
                ),

                const SizedBox(
                  width: 5,
                ),

                Text(
                  '${_totalPlaces()}',
                  style:
                      const TextStyle(
                    fontSize: 15,
                    color:
                        RihalStyle.brown,
                    fontWeight:
                        FontWeight.w600,
                  ),
                ),
              ],
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
      padding:
          const EdgeInsets.symmetric(
        horizontal: 22,
        vertical: 30,
      ),
      child: Column(
        children: [
          const Icon(
            Icons.auto_awesome_rounded,
            color:
                RihalStyle.darkGreen,
            size: 52,
          ),

          const SizedBox(
            height: 18,
          ),

          Text(
            RihalTranslations.tr(
              context,
              'أماكنك جاهزة للترتيب',
            ),
            textAlign:
                TextAlign.center,
            style: const TextStyle(
              fontSize: 23,
              fontWeight:
                  FontWeight.bold,
              color:
                  RihalStyle.darkGreen,
            ),
          ),

          const SizedBox(
            height: 10,
          ),

          Text(
            RihalTranslations.tr(
              context,
              'سيقوم رِحال بإنشاء خطتك تلقائيًا حسب الأماكن التي اخترتها والوقت المتاح.',
            ),
            textAlign:
                TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              height: 1.8,
              color:
                  RihalStyle.brown,
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
    return SizedBox(
      height: 54,
      child:
          ListView.separated(
        scrollDirection:
            Axis.horizontal,
        itemCount:
            aiPlanDays.length,

        separatorBuilder:
            (_, __) =>
                const SizedBox(
          width: 8,
        ),

        itemBuilder:
            (context, index) {
          final active =
              selectedDay == index;

          return InkWell(
            borderRadius:
                BorderRadius.circular(
              RihalStyle.buttonRadius,
            ),
            onTap: () {
              setState(() {
                selectedDay = index;
              });
            },
            child:
                AnimatedContainer(
              duration:
                  const Duration(
                milliseconds: 180,
              ),
              padding:
                  const EdgeInsets
                      .symmetric(
                horizontal: 24,
                vertical: 14,
              ),
              decoration:
                  BoxDecoration(
                color: active
                    ? RihalStyle
                        .darkGreen
                    : RihalStyle
                        .cardBackground,
                borderRadius:
                    BorderRadius
                        .circular(
                  RihalStyle
                      .buttonRadius,
                ),
                border:
                    Border.all(
                  color: active
                      ? RihalStyle
                          .darkGreen
                      : RihalStyle
                          .cardBorder,
                ),
              ),
              alignment:
                  Alignment.center,
              child: Text(
                aiPlanDays[index]
                    .title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight:
                      FontWeight.bold,
                  color: active
                      ? Colors.white
                      : RihalStyle
                          .brown,
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
    AiTripStop stop,
    int index,
  ) {
    return Padding(
      padding:
          const EdgeInsets.only(
        bottom: 13,
      ),
      child: RihalCard(
        padding:
            const EdgeInsets.all(
          13,
        ),
        child: Row(
          children: [
            Container(
              height: 37,
              width: 37,
              alignment:
                  Alignment.center,
              decoration:
                  const BoxDecoration(
                color:
                    RihalStyle
                        .darkGreen,
                shape:
                    BoxShape.circle,
              ),
              child: Text(
                '${index + 1}',
                style:
                    const TextStyle(
                  color:
                      Colors.white,
                  fontWeight:
                      FontWeight.bold,
                  fontSize: 17,
                ),
              ),
            ),

            const SizedBox(
              width: 12,
            ),

            ClipRRect(
              borderRadius:
                  BorderRadius
                      .circular(14),
              child:
                  stop.image != null
                      ? Image.asset(
                          stop.image!,
                          width: 87,
                          height: 91,
                          fit: BoxFit
                              .cover,
                          errorBuilder:
                              (
                            _,
                            __,
                            ___,
                          ) {
                            return _stopImageFallback(
                              stop.icon,
                            );
                          },
                        )
                      : _stopImageFallback(
                          stop.icon,
                        ),
            ),

            const SizedBox(
              width: 12,
            ),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                children: [
                  if (stop.time
                      .isNotEmpty) ...[
                    Text(
                      stop.time,
                      style:
                          const TextStyle(
                        fontSize: 13,
                        color:
                            RihalStyle
                                .brown,
                        fontWeight:
                            FontWeight
                                .w600,
                      ),
                    ),

                    const SizedBox(
                      height: 5,
                    ),
                  ],

                  Text(
                    stop.name,
                    style:
                        const TextStyle(
                      fontSize: 17,
                      color:
                          RihalStyle
                              .deepGreen,
                      fontWeight:
                          FontWeight
                              .bold,
                    ),
                  ),

                  if (stop.subtitle
                      .isNotEmpty) ...[
                    const SizedBox(
                      height: 5,
                    ),

                    Text(
                      stop.subtitle,
                      style:
                          const TextStyle(
                        fontSize: 12,
                        color:
                            RihalStyle
                                .secondaryText,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _stopImageFallback(
    IconData icon,
  ) {
    return Container(
      width: 87,
      height: 91,
      color:
          RihalStyle
              .cardBackgroundLight,
      child: Icon(
        icon,
        size: 38,
        color:
            RihalStyle.brown,
      ),
    );
  }

  // ==========================================================================
  // NOTE
  // ==========================================================================

  Widget _note() {
    return Padding(
      padding:
          const EdgeInsets.all(
        8,
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment
                .start,
        children: [
          const Icon(
            Icons
                .info_outline_rounded,
            size: 19,
            color:
                RihalStyle.brown,
          ),

          const SizedBox(
            width: 8,
          ),

          Expanded(
            child: Text(
              RihalTranslations.tr(
                context,
                'تم ترتيب الخطة بناءً على الوقت والمسافة والأماكن المختارة.',
              ),
              style:
                  const TextStyle(
                color:
                    RihalStyle.brown,
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
      color:
          RihalStyle.background,
      padding:
          const EdgeInsets
              .fromLTRB(
        17,
        8,
        17,
        12,
      ),
      child: SizedBox(
        width:
            double.infinity,
        height:
            RihalStyle
                .primaryButtonHeight,
        child:
            ElevatedButton.icon(
          style:
              RihalStyle
                  .primaryButtonStyle(),

          icon: isGenerating
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child:
                      CircularProgressIndicator(
                    strokeWidth:
                        2.2,
                    color:
                        Colors.white,
                  ),
                )
              : const Icon(
                  Icons
                      .auto_awesome_rounded,
                  size: 24,
                ),

          label: Text(
            isGenerating
                ? RihalTranslations
                    .tr(
                    context,
                    'جاري إنشاء الخطة...',
                  )
                : RihalTranslations
                    .tr(
                    context,
                    planReady
                        ? 'إعادة ترتيب رحلتي'
                        : 'رتّب رحلتي',
                  ),
            style:
                const TextStyle(
              fontSize:
                  RihalStyle
                      .primaryButtonTextSize,
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          onPressed:
              isGenerating
                  ? null
                  : _generateTripWithAi,
        ),
      ),
    );
  }

  // ==========================================================================
  // HELPERS
  // ==========================================================================

  int _totalPlaces() {
    int count = 0;

    for (final day
        in aiPlanDays) {
      count +=
          day.stops.length;
    }

    return count;
  }
}

// ============================================================================
// AI TRIP DAY MODEL
// ============================================================================

class AiTripDay {
  final String title;
  final List<AiTripStop> stops;

  const AiTripDay({
    required this.title,
    required this.stops,
  });
}

// ============================================================================
// AI TRIP STOP MODEL
// ============================================================================

class AiTripStop {
  final String name;
  final String time;
  final String subtitle;
  final String? image;
  final IconData icon;

  const AiTripStop({
    required this.name,
    this.time = '',
    this.subtitle = '',
    this.image,
    this.icon =
        Icons.place_outlined,
  });
}