import 'package:flutter/material.dart' hide Text;
import '../localization/rihal_localized_text.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../rihal_style.dart';
import 'profile_screen.dart';

/// نموذج عرض للاستكشاف اللحظي: الاقتراحات والمواقع والأوقات ليست بيانات مباشرة.
class InstantExploreScreen extends StatefulWidget {
  const InstantExploreScreen({super.key});

  @override
  State<InstantExploreScreen> createState() => _InstantExploreScreenState();
}

class _InstantExploreScreenState extends State<InstantExploreScreen> {
  int minutes = 90;
  String category = 'الكل';
  bool showResults = false;
  String transportMode = 'مشي';
  String walkingRoutePreference = 'أسرع';

  final MapController mapController = MapController();
  final ScrollController _scrollController = ScrollController();

  // إحداثيات تقريبية للديمو، وليست نتائج توجيه أو ملاحة.
  static const museum = LatLng(24.4515, 39.6534);
  static const mall = LatLng(24.4780, 39.6650);

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _showNearbyResults() {
    setState(() {
      showResults = true;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scrollController.hasClients) return;

      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 550),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: RihalTranslations.direction(context),
      child: Scaffold(
        backgroundColor: RihalStyle.background,
        appBar: AppBar(
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          backgroundColor: RihalStyle.background,
          centerTitle: true,
          title: const Text(
            'الاستكشاف اللحظي',
            style: TextStyle(
              color: RihalStyle.darkGreen,
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
        body: Column(
          children: [
            Expanded(
              child: ListView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                padding: RihalStyle.pagePadding,
                children: [
                  const Icon(
                    Icons.explore_rounded,
                    color: RihalStyle.darkGreen,
                    size: 54,
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'لديك وقت فراغ؟',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: RihalStyle.darkGreen,
                    ),
                  ),

                  const SizedBox(height: 6),

                  const Text(
                    'اكتشف مكانًا مناسبًا قبل موعدك التالي',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: RihalStyle.brown,
                    ),
                  ),

                  const SizedBox(height: RihalStyle.spaceLg),

                  RihalCard(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(
                              Icons.location_on_rounded,
                              color: RihalStyle.darkGreen,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'موقعك الحالي',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: RihalStyle.deepGreen,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 6),

                        const Text(
                          'جبل أحد',
                          style: TextStyle(
                            color: RihalStyle.brown,
                          ),
                        ),

                        const Divider(
                          height: 25,
                          color: RihalStyle.cardBorder,
                        ),

                        const Row(
                          children: [
                            Icon(
                              Icons.flag_rounded,
                              color: RihalStyle.darkGreen,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'وجهتك التالية',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: RihalStyle.deepGreen,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 6),

                        const Text(
                          'متحف دار المدينة — 11:00 صباحًا',
                          style: TextStyle(
                            color: RihalStyle.brown,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 13),

                  RihalCard(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      children: [
                        const Row(
                          children: [
                            Icon(
                              Icons.access_time_rounded,
                              color: RihalStyle.darkGreen,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'الوقت المتاح',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                                color: RihalStyle.deepGreen,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 13),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _timeButton(
                              icon: Icons.remove,
                              enabled: minutes > 30,
                              onPressed: () {
                                setState(() {
                                  minutes -= 15;
                                  showResults = false;
                                });
                              },
                            ),

                            Text(
                              '$minutes دقيقة',
                              style: const TextStyle(
                                fontSize: 23,
                                fontWeight: FontWeight.bold,
                                color: RihalStyle.darkGreen,
                              ),
                            ),

                            _timeButton(
                              icon: Icons.add,
                              enabled: minutes < 180,
                              onPressed: () {
                                setState(() {
                                  minutes += 15;
                                  showResults = false;
                                });
                              },
                            ),
                          ],
                        ),

                        const SizedBox(height: 7),

                        const Text(
                          'من 9:30 إلى 11:00 صباحًا في مثال رحلتك',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            color: RihalStyle.brown,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 15),

                  const Text(
                    'الاهتمامات (اختياري)',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: RihalStyle.darkGreen,
                    ),
                  ),

                  const SizedBox(height: 9),

                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      'الكل',
                      'أسواق',
                      'مقاهي',
                    ].map((item) {
                      final selected = category == item;

                      return ChoiceChip(
                        label: Text(item),
                        selected: selected,
                        showCheckmark: false,
                        backgroundColor: RihalStyle.cardBackground,
                        selectedColor: RihalStyle.darkGreen,
                        side: BorderSide(
                          color: selected
                              ? RihalStyle.darkGreen
                              : RihalStyle.cardBorder,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        labelStyle: TextStyle(
                          color: selected
                              ? Colors.white
                              : RihalStyle.brown,
                          fontWeight: selected
                              ? FontWeight.bold
                              : FontWeight.w500,
                        ),
                        onSelected: (_) {
                          setState(() {
                            category = item;
                            showResults = false;
                          });
                        },
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 18),

                  const Text(
                    'طريقة التنقل',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: RihalStyle.darkGreen,
                    ),
                  ),

                  const SizedBox(height: 9),

                  Row(
                    children: [
                      Expanded(
                        child: _transportOption(
                          icon: Icons.directions_walk_rounded,
                          label: 'مشي',
                          selected: transportMode == 'مشي',
                          onTap: () {
                            setState(() {
                              transportMode = 'مشي';
                              showResults = false;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _transportOption(
                          icon: Icons.directions_car_filled_rounded,
                          label: 'سيارة',
                          selected: transportMode == 'سيارة',
                          onTap: () {
                            setState(() {
                              transportMode = 'سيارة';
                              walkingRoutePreference = 'أسرع';
                              showResults = false;
                            });
                          },
                        ),
                      ),
                    ],
                  ),

                  if (transportMode == 'مشي') ...[
                    const SizedBox(height: 13),

                    RihalCard(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(
                                Icons.route_rounded,
                                color: RihalStyle.darkGreen,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'تفضيل مسار المشي',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: RihalStyle.deepGreen,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            'اختياري — اختاري المسار الأنسب لك',
                            style: TextStyle(
                              fontSize: 11.5,
                              color: RihalStyle.secondaryText,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: _walkingRouteOption(
                                  icon: Icons.bolt_rounded,
                                  title: 'المسار الأسرع',
                                  subtitle: 'تعرض للشمس 68%',
                                  selected: walkingRoutePreference == 'أسرع',
                                  onTap: () {
                                    setState(() {
                                      walkingRoutePreference = 'أسرع';
                                      showResults = false;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _walkingRouteOption(
                                  icon: Icons.park_rounded,
                                  title: 'أقل تعرضًا للشمس',
                                  subtitle: 'تعرض للشمس 25%',
                                  selected: walkingRoutePreference == 'ظل',
                                  onTap: () {
                                    setState(() {
                                      walkingRoutePreference = 'ظل';
                                      showResults = false;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          if (walkingRoutePreference == 'ظل') ...[
                            const SizedBox(height: 10),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: RihalStyle.softGreen,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.info_outline_rounded,
                                    size: 18,
                                    color: RihalStyle.darkGreen,
                                  ),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'هذا المسار يقلل التعرض للشمس من 68% إلى 25% تقريبًا، وقد يكون أطول قليلًا.',
                                      style: TextStyle(
                                        fontSize: 11.5,
                                        height: 1.45,
                                        color: RihalStyle.deepGreen,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 18),

                  SizedBox(
                    height: RihalStyle.primaryButtonHeight,
                    child: ElevatedButton.icon(
                      onPressed: _showNearbyResults,
                      style: RihalStyle.primaryButtonStyle(),
                      icon: const Icon(
                        Icons.auto_awesome_rounded,
                      ),
                      label: Text(
                        transportMode == 'مشي' &&
                                walkingRoutePreference == 'ظل'
                            ? 'ابحث بأقل تعرض للشمس'
                            : 'ابحث عن أماكن قريبة',
                        style: const TextStyle(
                          fontSize: RihalStyle.primaryButtonTextSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  if (showResults) ...[
                    const SizedBox(height: 22),

                    Text(
                      transportMode == 'مشي' &&
                              walkingRoutePreference == 'ظل'
                          ? 'اقتراحات بأقل تعرض للشمس'
                          : 'اقتراحات قبل زيارة المتحف',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: RihalStyle.darkGreen,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      transportMode == 'مشي' &&
                              walkingRoutePreference == 'ظل'
                          ? 'سيتم تفضيل مسار مشي أقل تعرضًا للشمس. النسبة الحالية تقديرية لواجهة العرض.'
                          : 'يجب التحقق من المسافات وأوقات العمل والتنقل.',
                      style: const TextStyle(
                        fontSize: 12,
                        color: RihalStyle.brown,
                      ),
                    ),

                    const SizedBox(height: 12),

                    ClipRRect(
                      borderRadius: BorderRadius.circular(
                        RihalStyle.cardRadius,
                      ),
                      child: SizedBox(
                        height: 225,
                        child: FlutterMap(
                          mapController: mapController,
                          options: const MapOptions(
                            initialCenter: LatLng(
                              24.465,
                              39.659,
                            ),
                            initialZoom: 12.3,
                          ),
                          children: [
                            TileLayer(
                              urlTemplate:
                                  'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                              userAgentPackageName:
                                  'com.example.rihal',
                            ),
                            MarkerLayer(
                              markers: [
                                const Marker(
                                  point: museum,
                                  width: 52,
                                  height: 52,
                                  child: Icon(
                                    Icons.museum_rounded,
                                    color: RihalStyle.darkGreen,
                                    size: 39,
                                  ),
                                ),
                                if (category != 'مقاهي')
                                  const Marker(
                                    point: mall,
                                    width: 52,
                                    height: 52,
                                    child: Icon(
                                      Icons.shopping_bag_rounded,
                                      color: RihalStyle.brown,
                                      size: 39,
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    if (category != 'مقاهي')
                      _result(
                        'الراشد ميغا مول',
                        transportMode == 'مشي' &&
                                walkingRoutePreference == 'ظل'
                            ? 'مسار مشي بتعرض شمسي تقريبي 25%'
                            : 'تسوق ومقاهٍ ومطاعم',
                        Icons.shopping_bag_rounded,
                      ),

                    if (category != 'أسواق')
                      _result(
                        'استراحة في مقهى',
                        transportMode == 'مشي' &&
                                walkingRoutePreference == 'ظل'
                            ? 'مسار أقل تعرضًا للشمس قدر الإمكان'
                            : 'اختاري مقهى مناسبًا بعد التحقق من موقعه',
                        Icons.local_cafe_rounded,
                      ),

                    const SizedBox(height: 9),

                    const Text(
                      'مهم: خصّصي وقتًا للوصول إلى المتحف قبل 11:00 ص. لا تُحسب أزمنة القيادة مباشرة في هذه النسخة.',
                      style: TextStyle(
                        fontSize: 12,
                        height: 1.5,
                        color: RihalStyle.brown,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            RihalBottomNavigation(
              selectedIndex: 2,
              onMyTrips: () {
                Navigator.of(context).popUntil(
                  (route) => route.isFirst,
                );
              },
              onHome: () {
                Navigator.of(context).popUntil(
                  (route) => route.isFirst,
                );
              },
              onExplore: () {},

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
    );
  }

  Widget _transportOption({
    required IconData icon,
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Material(
      color: selected
          ? RihalStyle.darkGreen
          : RihalStyle.cardBackground,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 58,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected
                  ? RihalStyle.darkGreen
                  : RihalStyle.cardBorder,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: selected ? Colors.white : RihalStyle.darkGreen,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: selected ? Colors.white : RihalStyle.deepGreen,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _walkingRouteOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Material(
      color: selected
          ? RihalStyle.softGreen
          : RihalStyle.cardBackgroundLight,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected
                  ? RihalStyle.darkGreen
                  : RihalStyle.cardBorder,
              width: selected ? 1.4 : 1,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: selected
                    ? RihalStyle.darkGreen
                    : RihalStyle.brown,
                size: 24,
              ),
              const SizedBox(height: 6),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: RihalStyle.deepGreen,
                ),
              ),
              const SizedBox(height: 3),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.wb_sunny_outlined,
                    size: 13,
                    color: RihalStyle.brown,
                  ),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      subtitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 10.5,
                        color: RihalStyle.secondaryText,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _timeButton({
    required IconData icon,
    required bool enabled,
    required VoidCallback onPressed,
  }) {
    return Material(
      color: enabled
          ? RihalStyle.cardBackgroundLight
          : RihalStyle.cardBackgroundLight.withValues(
              alpha: 0.55,
            ),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: enabled ? onPressed : null,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: RihalStyle.cardBorder,
            ),
          ),
          child: Icon(
            icon,
            color: enabled
                ? RihalStyle.darkGreen
                : RihalStyle.inactiveGreen,
          ),
        ),
      ),
    );
  }

  Widget _result(
    String name,
    String detail,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: RihalCard(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: RihalStyle.cardBackgroundLight,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: RihalStyle.cardBorder,
                ),
              ),
              child: Icon(
                icon,
                color: RihalStyle.darkGreen,
                size: 29,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: RihalStyle.darkGreen,
                      fontSize: 17,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    detail,
                    style: const TextStyle(
                      color: RihalStyle.brown,
                      fontSize: 13,
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
}
