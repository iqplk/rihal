import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'place_details_screen.dart';
import 'trip_plan_screen.dart';
import 'instant_explore_screen.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final MapController _mapController = MapController();

  final Color darkGreen = const Color(0xFF30452D);
  final Color brown = const Color(0xFF7B5235);
  final Color beige = const Color(0xFFF8F0E4);

  final TextEditingController _searchController =
      TextEditingController();

  String selectedMainFilter = 'الكل';
  String selectedCategory = 'الكل';

  // ============================
  // الأماكن المضافة إلى الخطة
  // ============================

  final List<RihalPlace> selectedPlaces = [];

  // ============================
  // مركز المدينة المنورة
  // ============================

  final LatLng madinahCenter =
      const LatLng(24.4672, 39.6111);

  // ============================
  // المعالم
  // ============================

  final List<RihalPlace> places = [
    RihalPlace(
      name: 'المسجد النبوي',
      category: 'دينية',
      location: const LatLng(24.4672, 39.6111),
      icon: Icons.mosque_rounded,
    ),
    RihalPlace(
      name: 'مسجد قباء',
      category: 'دينية',
      location: const LatLng(24.4397, 39.6172),
      icon: Icons.mosque_rounded,
    ),
    RihalPlace(
      name: 'جبل أحد',
      category: 'معالم',
      location: const LatLng(24.5039, 39.6137),
      icon: Icons.landscape_rounded,
    ),
    RihalPlace(
      name: 'مسجد القبلتين',
      category: 'دينية',
      location: const LatLng(24.4841, 39.5788),
      icon: Icons.mosque_rounded,
    ),
    RihalPlace(
      name: 'متحف دار المدينة',
      category: 'متاحف',
      location: const LatLng(24.4515, 39.6534),
      icon: Icons.museum_rounded,
    ),
    RihalPlace(
      name: 'سكة الحجاز',
      category: 'متاحف',
      location: const LatLng(24.4593, 39.6004),
      icon: Icons.train_rounded,
    ),
    RihalPlace(
      name: 'جادة قباء',
      category: 'ترفيه',
      location: const LatLng(24.4545, 39.6108),
      icon: Icons.directions_walk_rounded,
    ),
    RihalPlace(
      name: 'الراشد ميغا مول',
      category: 'أسواق',
      location: const LatLng(24.4780, 39.6650),
      icon: Icons.shopping_bag_rounded,
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ============================
  // فلترة الأماكن
  // ============================

  List<RihalPlace> get filteredPlaces {
    return places.where((place) {
      final String search =
          _searchController.text.trim().toLowerCase();

      bool matchesSearch = true;
      bool matchesMain = true;
      bool matchesCategory = true;

      if (search.isNotEmpty) {
        matchesSearch =
            place.name.toLowerCase().contains(search);
      }

      if (selectedMainFilter == 'دينية') {
        matchesMain = place.category == 'دينية';
      } else if (selectedMainFilter == 'ترفيه') {
        matchesMain = place.category != 'دينية';
      }

      if (selectedCategory != 'الكل') {
        matchesCategory =
            place.category == selectedCategory;
      }

      return matchesSearch &&
          matchesMain &&
          matchesCategory;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Stack(
          children: [
            // ============================
            // الخريطة
            // ============================

            Positioned.fill(
              child: FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: madinahCenter,
                  initialZoom: 13.5,
                  minZoom: 4,
                  maxZoom: 18,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName:
                        'com.example.rihal',
                  ),

                  MarkerLayer(
                    markers: filteredPlaces.map((place) {
                      return Marker(
                        point: place.location,
                        width: 150,
                        height: 82,
                        child: _buildPlaceMarker(place),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

            // لمسة لونية خفيفة
            IgnorePointer(
              child: Container(
                color: const Color(0xFF8B6949)
                    .withValues(alpha: 0.025),
              ),
            ),

            // ============================
            // أعلى الشاشة
            // ============================

            SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  15,
                  12,
                  15,
                  0,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ============================
                    // المستخدم + البحث + الطبقات
                    // ============================

                    Row(
                      children: [
                        _circleButton(
                          icon:
                              Icons.person_outline_rounded,
                          onTap: () {
                            // صفحة الحساب لاحقاً
                          },
                        ),

                        const SizedBox(width: 9),

                        Expanded(
                          child: Container(
                            height: 52,
                            decoration: BoxDecoration(
                              color: beige.withValues(
                                alpha: 0.97,
                              ),
                              borderRadius:
                                  BorderRadius.circular(27),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      Colors.black.withValues(
                                    alpha: 0.12,
                                  ),
                                  blurRadius: 12,
                                  offset:
                                      const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: TextField(
                              controller:
                                  _searchController,
                              onChanged: (_) {
                                setState(() {});
                              },
                              textAlign: TextAlign.right,
                              decoration: InputDecoration(
                                hintText:
                                    'ابحث عن معلم، مطعم، مقهى...',
                                hintStyle:
                                    const TextStyle(
                                  color:
                                      Color(0xFF958A80),
                                  fontSize: 13,
                                ),
                                prefixIcon: Icon(
                                  Icons.search_rounded,
                                  color: brown,
                                ),
                                border: InputBorder.none,
                                contentPadding:
                                    const EdgeInsets
                                        .symmetric(
                                  vertical: 16,
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 9),

                        _circleButton(
                          icon: Icons.layers_rounded,
                          onTap: _showMapOptions,
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // ============================
                    // الكل / ترفيه / دينية
                    // ============================

                    Container(
                      height: 47,
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: beige.withValues(
                          alpha: 0.97,
                        ),
                        borderRadius:
                            BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color:
                                Colors.black.withValues(
                              alpha: 0.09,
                            ),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          _mainFilter('الكل'),
                          _mainFilter('ترفيه'),
                          _mainFilter('دينية'),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),

                    // ============================
                    // التصنيفات
                    // ============================

                    SizedBox(
                      height: 72,
                      child: ListView(
                        scrollDirection:
                            Axis.horizontal,
                        children: [
                          _categoryButton(
                            title: 'مطاعم',
                            icon:
                                Icons.restaurant_rounded,
                          ),
                          _categoryButton(
                            title: 'مقاهي',
                            icon:
                                Icons.local_cafe_rounded,
                          ),
                          _categoryButton(
                            title: 'فعاليات',
                            icon: Icons
                                .celebration_outlined,
                          ),
                          _categoryButton(
                            title: 'معالم',
                            icon:
                                Icons.landscape_outlined,
                          ),
                          _categoryButton(
                            title: 'متاحف',
                            icon:
                                Icons.museum_outlined,
                          ),
                          _categoryButton(
                            title: 'أسواق',
                            icon: Icons
                                .shopping_bag_outlined,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ============================
            // أزرار الخريطة
            // ============================

            Positioned(
              left: 16,
              bottom:
                  selectedPlaces.isEmpty ? 125 : 210,
              child: Column(
                children: [
                  _mapActionButton(
                    icon: Icons.navigation_rounded,
                    onTap: () {
                      _mapController.move(
                        madinahCenter,
                        14,
                      );
                    },
                  ),

                  const SizedBox(height: 10),

                  _mapActionButton(
                    icon: Icons.my_location_rounded,
                    onTap: () {
                      _mapController.move(
                        madinahCenter,
                        15,
                      );
                    },
                  ),
                ],
              ),
            ),

            // ============================
            // كرت خطتي
            // يظهر عند إضافة مكان
            // ============================

            if (selectedPlaces.isNotEmpty)
              Positioned(
                right: 15,
                left: 15,
                bottom: 105,
                child: _buildMyPlanCard(),
              ),

            // ============================
            // القائمة السفلية
            // ============================

            Positioned(
              right: 0,
              left: 0,
              bottom: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF9F1E5)
                      .withValues(alpha: 0.98),
                  borderRadius:
                      const BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color:
                          Colors.black.withValues(
                        alpha: 0.12,
                      ),
                      blurRadius: 18,
                      offset: const Offset(0, -3),
                    ),
                  ],
                ),
                child: SafeArea(
                  top: false,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(
                      top: 11,
                      bottom: 10,
                    ),
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment
                              .spaceAround,
                      children: [
                        _bottomItem(
                          icon: Icons
                              .calendar_month_outlined,
                          label: 'رحلاتي',
                          selected: false,
                          onTap: () {
                            // نربطه لاحقاً
                          },
                        ),

                        _bottomItem(
                          icon: Icons.home_rounded,
                          label: 'الرئيسية',
                          selected: true,
                          onTap: () {},
                        ),

                        _bottomItem(
                          icon:
                              Icons.explore_outlined,
                          label: 'استكشاف لحظي',
                          selected: false,
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const InstantExploreScreen()));
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================
  // Marker المكان
  // ============================

  Widget _buildPlaceMarker(RihalPlace place) {
    final bool isSelected =
        selectedPlaces.any(
      (item) => item.name == place.name,
    );

    Color markerColor;

    if (place.category == 'دينية') {
      markerColor = darkGreen;
    } else if (place.category == 'متاحف') {
      markerColor =
          const Color(0xFF75518A);
    } else if (place.category == 'معالم') {
      markerColor =
          const Color(0xFF9A6542);
    } else {
      markerColor = brown;
    }

    return GestureDetector(
      onTap: () {
        _showPlace(place);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            constraints:
                const BoxConstraints(
              maxWidth: 145,
            ),
            padding:
                const EdgeInsets.symmetric(
              horizontal: 9,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color:
                  beige.withValues(alpha: 0.98),
              borderRadius:
                  BorderRadius.circular(20),
              border: isSelected
                  ? Border.all(
                      color: darkGreen,
                      width: 2,
                    )
                  : null,
              boxShadow: [
                BoxShadow(
                  color:
                      Colors.black.withValues(
                    alpha: 0.16,
                  ),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              mainAxisSize:
                  MainAxisSize.min,
              children: [
                Container(
                  width: 31,
                  height: 31,
                  decoration: BoxDecoration(
                    color: markerColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isSelected
                        ? Icons.check_rounded
                        : place.icon,
                    size: 18,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(width: 7),

                Flexible(
                  child: Text(
                    place.name,
                    maxLines: 1,
                    overflow:
                        TextOverflow.ellipsis,
                    style:
                        const TextStyle(
                      color:
                          Color(0xFF40362F),
                      fontSize: 12,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Icon(
            Icons.location_on_rounded,
            color: markerColor,
            size: 27,
          ),
        ],
      ),
    );
  }

  // ============================
  // كرت خطتي
  // ============================

  Widget _buildMyPlanCard() {
    return InkWell(
      onTap: _openTripPlan,
      borderRadius: BorderRadius.circular(24),
      child: Container(
      height: 86,
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 11,
      ),
      decoration: BoxDecoration(
        color:
            beige.withValues(alpha: 0.98),
        borderRadius:
            BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withValues(
              alpha: 0.16,
            ),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // أيقونات الأماكن المختارة
          SizedBox(
            width: 100,
            child: Stack(
              children: [
                for (
                  int i = 0;
                  i <
                      selectedPlaces.length
                          .clamp(0, 3);
                  i++
                )
                  Positioned(
                    right: i * 27,
                    top: 7,
                    child: Container(
                      width: 46,
                      height: 46,
                      decoration:
                          BoxDecoration(
                        color: darkGreen,
                        borderRadius:
                            BorderRadius
                                .circular(14),
                        border: Border.all(
                          color: beige,
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        selectedPlaces[i]
                            .icon,
                        color: Colors.white,
                        size: 23,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          Expanded(
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'خطتي (${selectedPlaces.length})',
                  style:
                      const TextStyle(
                    color:
                        Color(0xFF332A24),
                    fontSize: 18,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  selectedPlaces.length == 1
                      ? 'مكان مختار'
                      : 'أماكن مختارة',
                  style:
                      const TextStyle(
                    color:
                        Color(0xFF8A7D72),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: darkGreen
                  .withValues(alpha: 0.10),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons
                  .arrow_back_ios_new_rounded,
              color: darkGreen,
              size: 17,
            ),
          ),
        ],
      ),
      ),
    );
  }

  void _openTripPlan() {
    const requiredPlaces = {
      'جبل أحد',
      'متحف دار المدينة',
      'مسجد قباء',
      'جادة قباء',
    };
    final chosenNames = selectedPlaces.map((place) => place.name).toSet();
    if (chosenNames.length != 4 || !chosenNames.containsAll(requiredPlaces)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'لخطة العرض اختاري الأماكن الأربعة: جبل أحد، متحف دار المدينة، مسجد قباء، جادة قباء',
            textAlign: TextAlign.center,
          ),
        ),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const TripPlanScreen()),
    );
  }

  // ============================
  // فتح تفاصيل المكان
  // ============================

  Future<void> _showPlace(
    RihalPlace place,
  ) async {
    final RihalPlace? selectedPlace =
        await Navigator.push<RihalPlace>(
      context,
      MaterialPageRoute(
        builder: (context) =>
            PlaceDetailsScreen(
          place: place,
        ),
      ),
    );

    if (selectedPlace != null) {
      _addPlaceToPlan(selectedPlace);
    }
  }

  // ============================
  // إضافة المكان إلى الخطة
  // ============================

  void _addPlaceToPlan(
    RihalPlace place,
  ) {
    final bool alreadyAdded =
        selectedPlaces.any(
      (item) =>
          item.name == place.name,
    );

    if (alreadyAdded) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            '${place.name} موجود بالفعل في خطتك',
            textAlign:
                TextAlign.center,
          ),
        ),
      );

      return;
    }

    setState(() {
      selectedPlaces.add(place);
    });

    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(
          'تمت إضافة ${place.name} إلى خطتك',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  // ============================
  // الفلاتر الرئيسية
  // ============================

  Widget _mainFilter(
    String title,
  ) {
    final bool selected =
        selectedMainFilter == title;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedMainFilter =
                title;
            selectedCategory =
                'الكل';
          });
        },
        child: AnimatedContainer(
          duration:
              const Duration(
            milliseconds: 180,
          ),
          alignment:
              Alignment.center,
          decoration: BoxDecoration(
            color: selected
                ? darkGreen
                : Colors.transparent,
            borderRadius:
                BorderRadius.circular(21),
          ),
          child: Text(
            title,
            style: TextStyle(
              color: selected
                  ? Colors.white
                  : const Color(
                      0xFF554A41,
                    ),
              fontSize: 14,
              fontWeight:
                  FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  // ============================
  // التصنيفات
  // ============================

  Widget _categoryButton({
    required String title,
    required IconData icon,
  }) {
    final bool selected =
        selectedCategory == title;

    return GestureDetector(
      onTap: () {
        setState(() {
          if (selectedCategory ==
              title) {
            selectedCategory =
                'الكل';
          } else {
            selectedCategory =
                title;
          }

          selectedMainFilter =
              'الكل';
        });
      },
      child: AnimatedContainer(
        duration:
            const Duration(
          milliseconds: 180,
        ),
        width: 69,
        margin:
            const EdgeInsets.only(
          left: 8,
        ),
        decoration: BoxDecoration(
          color: selected
              ? darkGreen
              : beige.withValues(
                  alpha: 0.97,
                ),
          borderRadius:
              BorderRadius.circular(17),
          boxShadow: [
            BoxShadow(
              color:
                  Colors.black.withValues(
                alpha: 0.09,
              ),
              blurRadius: 8,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 23,
              color: selected
                  ? Colors.white
                  : brown,
            ),

            const SizedBox(height: 4),

            Text(
              title,
              style: TextStyle(
                color: selected
                    ? Colors.white
                    : const Color(
                        0xFF4D423A,
                      ),
                fontSize: 10.5,
                fontWeight:
                    FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================
  // زر دائري علوي
  // ============================

  Widget _circleButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 51,
        height: 51,
        decoration: BoxDecoration(
          color: beige.withValues(
            alpha: 0.98,
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color:
                  Colors.black.withValues(
                alpha: 0.12,
              ),
              blurRadius: 10,
            ),
          ],
        ),
        child: Icon(
          icon,
          color: darkGreen,
          size: 27,
        ),
      ),
    );
  }

  // ============================
  // أزرار الخريطة
  // ============================

  Widget _mapActionButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 49,
        height: 49,
        decoration: BoxDecoration(
          color: beige,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color:
                  Colors.black.withValues(
                alpha: 0.14,
              ),
              blurRadius: 9,
            ),
          ],
        ),
        child: Icon(
          icon,
          color: darkGreen,
          size: 25,
        ),
      ),
    );
  }

  // ============================
  // Bottom Navigation
  // ============================

  Widget _bottomItem({
    required IconData icon,
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior:
          HitTestBehavior.opaque,
      child: SizedBox(
        width: 105,
        child: Column(
          mainAxisSize:
              MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 27,
              color: selected
                  ? darkGreen
                  : const Color(
                      0xFF5B4C41,
                    ),
            ),

            const SizedBox(height: 4),

            Text(
              label,
              maxLines: 1,
              style: TextStyle(
                color: selected
                    ? darkGreen
                    : const Color(
                        0xFF5B4C41,
                      ),
                fontSize: 11.5,
                fontWeight: selected
                    ? FontWeight.bold
                    : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================
  // خيارات الخريطة
  // ============================

  void _showMapOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor:
          Colors.transparent,
      builder: (context) {
        return Directionality(
          textDirection:
              TextDirection.rtl,
          child: Container(
            margin:
                const EdgeInsets.all(14),
            padding:
                const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: beige,
              borderRadius:
                  BorderRadius.circular(28),
            ),
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize:
                    MainAxisSize.min,
                children: [
                  Container(
                    width: 45,
                    height: 4,
                    decoration:
                        BoxDecoration(
                      color:
                          const Color(
                        0xFFD1C5B8,
                      ),
                      borderRadius:
                          BorderRadius
                              .circular(10),
                    ),
                  ),

                  const SizedBox(
                    height: 18,
                  ),

                  const Text(
                    'عرض الخريطة',
                    style: TextStyle(
                      color:
                          Color(
                        0xFF40362F,
                      ),
                      fontSize: 18,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                    height: 15,
                  ),

                  const Text(
                    'سنضيف أنماط عرض إضافية للخريطة لاحقاً',
                    textAlign:
                        TextAlign.center,
                    style: TextStyle(
                      color:
                          Color(
                        0xFF8C8178,
                      ),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ============================
// بيانات المكان
// ============================

class RihalPlace {
  final String name;
  final String category;
  final LatLng location;
  final IconData icon;

  // صورة المكان اختيارية
  final String? imagePath;

  const RihalPlace({
    required this.name,
    required this.category,
    required this.location,
    required this.icon,
    this.imagePath,
  });
}