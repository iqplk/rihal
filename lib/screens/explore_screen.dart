import 'dart:async';

import 'package:flutter/material.dart' hide Text;
import '../localization/rihal_localized_text.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

import '../rihal_style.dart';

import 'place_details_screen.dart';
import 'trip_plan_screen.dart';
import 'my_trips_screen.dart';
import 'instant_explore_screen.dart';
import 'profile_screen.dart';

// ==========================================
// EXPLORE SCREEN
// ==========================================

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  // ==========================================
  // CONTROLLERS
  // ==========================================

  final MapController _mapController = MapController();

  final TextEditingController _searchController =
      TextEditingController();

  // ==========================================
  // MAP DATA
  // ==========================================

  final LatLng madinahCenter = const LatLng(
    24.4672,
    39.6111,
  );

  LatLng? _currentLocation;

  bool _isGettingLocation = false;

  // ==========================================
  // FILTERS
  // ==========================================

  String selectedMainFilter = 'الكل';

  String selectedCategory = 'الكل';

  // ==========================================
  // SELECTED PLACES
  // ==========================================

  final List<RihalPlace> selectedPlaces = [];

  // ==========================================
  // PLACES
  // ==========================================

  final List<RihalPlace> places = [
    RihalPlace(
      name: 'المسجد النبوي',
      category: 'دينية',
      location: const LatLng(
        24.4686804,
        39.611162,
      ),
      icon: Icons.mosque_rounded,
      imagePath: 'assets/images/majid-nabawi.jpeg',
    ),

    RihalPlace(
      name: 'مسجد قباء',
      category: 'دينية',
      location: const LatLng(
        24.4394233,
        39.6174593,
      ),
      icon: Icons.mosque_rounded,
      imagePath: 'assets/images/quba_mosque.jpg',
    ),

    RihalPlace(
      name: 'مسجد القبلتين',
      category: 'دينية',
      location: const LatLng(
        24.4840861,
        39.5789083,
      ),
      icon: Icons.mosque_rounded,
      imagePath: 'assets/images/gblteen.jpg',
    ),

    RihalPlace(
      name: 'جبل أحد',
      category: 'معالم',
      location: const LatLng(
        24.5227316,
        39.6182613,
      ),
      icon: Icons.landscape_rounded,
    ),

    RihalPlace(
      name: 'جبل عَيْر',
      category: 'معالم',
      location: const LatLng(
        24.407749,
        39.565148,
      ),
      icon: Icons.landscape_rounded,
      imagePath:
          'assets/images/jabal-ayr-madinah.2e16d0ba.fill-1920x1080.jpeg',
    ),

    RihalPlace(
      name: 'الحي التراثي',
      category: 'تراثي',
      location: const LatLng(
        24.417379,
        39.60968,
      ),
      icon: Icons.account_balance_rounded,
      imagePath: 'assets/images/hitrathe.jpeg',
    ),

    RihalPlace(
      name: 'حي المغيسلة',
      category: 'تراثي',
      location: const LatLng(
        24.45685,
        39.60083,
      ),
      icon: Icons.location_city_rounded,
      imagePath: 'assets/images/row.jpg',
    ),

    RihalPlace(
      name: 'المعرض والمتحف الدولي للسيرة النبوية',
      category: 'متاحف',
      location: const LatLng(
        24.4658057,
        39.6093539,
      ),
      icon: Icons.museum_rounded,
      imagePath: 'assets/images/mthfaldoliserahnboi.jpeg',
    ),

    RihalPlace(
      name: 'متحف دار المدينة',
      category: 'متاحف',
      location: const LatLng(
        24.4766728,
        39.6876878,
      ),
      icon: Icons.museum_rounded,
      imagePath:
          'assets/images/dar_al_madinah_museum.jpg',
    ),

    RihalPlace(
      name: 'جادة قباء',
      category: 'فعاليات',
      location: const LatLng(
        24.4594117,
        39.6081509,
      ),
      icon: Icons.celebration_rounded,
    ),

    RihalPlace(
      name: 'الراشد ميغا مول',
      category: 'أسواق',
      location: const LatLng(
        24.4780,
        39.6650,
      ),
      icon: Icons.shopping_bag_rounded,
      imagePath: 'assets/images/alrashdmall.jpg',
    ),

    RihalPlace(
      name: 'بيت سعف',
      category: 'مطاعم',
      location: const LatLng(
        24.44006,
        39.521361,
      ),
      icon: Icons.restaurant_rounded,
      imagePath: 'assets/images/bets3f.jpg',
    ),

    RihalPlace(
      name: 'كِفّة',
      category: 'مقاهي',
      location: const LatLng(
        24.4869,
        39.6495,
      ),
      icon: Icons.local_cafe_rounded,
      imagePath: 'assets/images/kfah.jpg',
    ),

    RihalPlace(
      name: 'مطعم طُعمة',
      category: 'مطاعم',
      location: const LatLng(
        24.4402965,
        39.6629878,
      ),
      icon: Icons.restaurant_rounded,
      imagePath: 'assets/images/t3maai.jpg',
    ),

    RihalPlace(
      name: 'مطعم زمان جَدّي',
      category: 'مطاعم',
      location: const LatLng(
        24.4335042,
        39.6554209,
      ),
      icon: Icons.restaurant_rounded,
      imagePath: 'assets/images/zmanjdi.jpg',
    ),

    RihalPlace(
      name: 'مسجد الميقات',
      category: 'دينية',
      location: const LatLng(
        24.412222,
        39.542500,
      ),
      icon: Icons.mosque_rounded,
      imagePath: 'assets/images/megat.jpg',
    ),

    RihalPlace(
      name: 'متحف وبستان الصافية',
      category: 'متاحف',
      location: const LatLng(
        24.463760,
        39.610990,
      ),
      icon: Icons.museum_rounded,
      imagePath: 'assets/images/mthfbstanalsafih.jpg',
    ),

    RihalPlace(
      name: 'تجربة السيرة - الرحلة إلى قباء',
      category: 'دينية',
      location: const LatLng(
        24.440200,
        39.617000,
      ),
      icon: Icons.auto_stories_rounded,
      imagePath:
          'assets/images/sirah-six.2e16d0ba.fill-1920x1080..jpeg',
    ),

    RihalPlace(
      name: 'مزرعة المربد',
      category: 'فعاليات',
      location: const LatLng(
        24.442390,
        39.628370,
      ),
      icon: Icons.celebration_rounded,
      imagePath: 'assets/images/al-marbad-farm.jpg.jpeg',
    ),

    RihalPlace(
      name: 'مقصد قباء',
      category: 'فعاليات',
      location: const LatLng(
        24.437210,
        39.616390,
      ),
      icon: Icons.celebration_rounded,
      imagePath: 'assets/images/mgsdgba.jpg',
    ),

    RihalPlace(
      name: 'سوشل فارم',
      category: 'فعاليات',
      location: const LatLng(
        24.432700,
        39.630900,
      ),
      icon: Icons.celebration_rounded,
      imagePath: 'assets/images/soshealfarm.jpg',
    ),

    RihalPlace(
      name: 'كوفيماتكس',
      category: 'مقاهي',
      location: const LatLng(
        24.468900,
        39.620800,
      ),
      icon: Icons.local_cafe_rounded,
      imagePath: 'assets/images/coffematex.jpeg',
    ),
  ];

  // ==========================================
  // DISPOSE
  // ==========================================

  @override
  void dispose() {
    _searchController.dispose();
    _mapController.dispose();
    super.dispose();
  }

  // ==========================================
  // FILTERED PLACES
  // ==========================================

  List<RihalPlace> get filteredPlaces {
    const entertainmentCategories = {
      'مطاعم',
      'مقاهي',
      'فعاليات',
      'أسواق',
      'متاحف',
    };

    return places.where((place) {
      final search =
          _searchController.text.trim().toLowerCase();

      bool matchesSearch = true;

      bool matchesFilter = true;

      // ========================================
      // SEARCH
      // ========================================

      if (search.isNotEmpty) {
        final localizedName =
            RihalTranslations.tr(
          context,
          place.name,
        ).toLowerCase();

        matchesSearch =
            place.name.toLowerCase().contains(search) ||
                localizedName.contains(search);
      }

      // ========================================
      // ALL
      // ========================================

      if (selectedMainFilter == 'الكل') {
        matchesFilter = true;
      }

      // ========================================
      // RELIGIOUS
      // ========================================

      else if (selectedMainFilter == 'دينية') {
        matchesFilter =
            place.category == 'دينية';
      }

      // ========================================
      // HERITAGE
      // ========================================

      else if (selectedMainFilter == 'تراثي') {
        matchesFilter =
            place.category == 'تراثي';
      }

      // ========================================
      // ENTERTAINMENT
      // ========================================

      else if (selectedMainFilter == 'ترفيه') {
        if (selectedCategory == 'الكل') {
          matchesFilter =
              entertainmentCategories.contains(
            place.category,
          );
        } else {
          matchesFilter =
              place.category == selectedCategory;
        }
      }

      return matchesSearch && matchesFilter;
    }).toList();
  }

  // ==========================================
  // LOCATION MESSAGE
  // ==========================================

  void _showLocationMessage(
    String message,
  ) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
        ),
        backgroundColor:
            RihalStyle.darkGreen,
        behavior:
            SnackBarBehavior.floating,
        duration:
            const Duration(seconds: 2),
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(14),
        ),
      ),
    );
  }

  // ==========================================
  // GET CURRENT LOCATION
  // ==========================================

  Future<void> _getCurrentLocation() async {
    if (_isGettingLocation) {
      return;
    }

    setState(() {
      _isGettingLocation = true;
    });

    try {
      final enabled =
          await Geolocator.isLocationServiceEnabled();

      if (!mounted) return;

      if (!enabled) {
        _showLocationMessage(
          'فعّلي خدمات الموقع من إعدادات الجهاز',
        );
        return;
      }

      LocationPermission permission =
          await Geolocator.checkPermission();

      if (!mounted) return;

      if (permission ==
          LocationPermission.denied) {
        permission =
            await Geolocator.requestPermission();

        if (!mounted) return;
      }

      if (permission ==
          LocationPermission.denied) {
        _showLocationMessage(
          'يرجى السماح للتطبيق بالوصول إلى الموقع',
        );

        return;
      }

      if (permission ==
          LocationPermission.deniedForever) {
        _showLocationMessage(
          'فعّلي إذن الموقع من إعدادات التطبيق',
        );

        return;
      }

      final cached =
          await Geolocator.getLastKnownPosition();

      if (!mounted) return;

      if (cached != null) {
        _moveToCurrentLocation(
          LatLng(
            cached.latitude,
            cached.longitude,
          ),
        );
      }

      final fresh =
          await Geolocator.getCurrentPosition(
        locationSettings:
            const LocationSettings(
          accuracy:
              LocationAccuracy.medium,
          timeLimit:
              Duration(seconds: 12),
        ),
      );

      if (!mounted) return;

      _moveToCurrentLocation(
        LatLng(
          fresh.latitude,
          fresh.longitude,
        ),
      );

      _showLocationMessage(
        'تم تحديث موقعك الحالي',
      );
    } on TimeoutException {
      if (mounted) {
        _showLocationMessage(
          'تأخر تحديد الموقع، حاولي مرة أخرى',
        );
      }
    } catch (_) {
      if (mounted) {
        _showLocationMessage(
          'تعذر تحديد الموقع، تأكدي من تشغيل GPS',
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isGettingLocation = false;
        });
      }
    }
  }

  // ==========================================
  // MOVE TO CURRENT LOCATION
  // ==========================================

  void _moveToCurrentLocation(
    LatLng point,
  ) {
    setState(() {
      _currentLocation = point;
    });

    _mapController.move(
      point,
      16,
    );
  }

  // ==========================================
  // ZOOM IN
  // ==========================================

  void _zoomIn() {
    final zoom =
        (_mapController.camera.zoom + 1)
            .clamp(
              3.0,
              18.0,
            )
            .toDouble();

    _mapController.move(
      _mapController.camera.center,
      zoom,
    );
  }

  // ==========================================
  // ZOOM OUT
  // ==========================================

  void _zoomOut() {
    final zoom =
        (_mapController.camera.zoom - 1)
            .clamp(
              3.0,
              18.0,
            )
            .toDouble();

    _mapController.move(
      _mapController.camera.center,
      zoom,
    );
  }

  // ==========================================
  // MAIN FILTER
  // ==========================================

  Widget _mainFilter(
    String title,
  ) {
    return RihalExploreMainFilter(
      title: title,
      selected:
          selectedMainFilter == title,
      onTap: () {
        setState(() {
          selectedMainFilter = title;

          // نلغي الفئة الفرعية القديمة
          selectedCategory = 'الكل';
        });
      },
    );
  }

  // ==========================================
  // CATEGORY BUTTON
  // ==========================================

  Widget _categoryButton({
    required String title,
    required IconData icon,
  }) {
    return RihalExploreCategoryButton(
      title: title,
      icon: icon,
      selected:
          selectedCategory == title,
      onTap: () {
        setState(() {
          selectedMainFilter = 'ترفيه';

          if (selectedCategory == title) {
            selectedCategory = 'الكل';
          } else {
            selectedCategory = title;
          }
        });
      },
    );
  }

  // ==========================================
  // BUILD
  // ==========================================

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection:
          RihalTranslations.direction(
        context,
      ),
      child: Scaffold(
        backgroundColor:
            RihalStyle.background,
        body: Stack(
          children: [
            // ==================================
            // MAP
            // ==================================

            Positioned.fill(
              child: FlutterMap(
                mapController:
                    _mapController,
                options: MapOptions(
                  initialCenter:
                      madinahCenter,
                  initialZoom:
                      13.5,
                  minZoom:
                      4,
                  maxZoom:
                      18,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName:
                        'com.example.rihal',
                  ),

                  // ==================================
                  // PLACE MARKERS
                  // ==================================

                  MarkerLayer(
                    markers:
                        filteredPlaces.map(
                      (place) {
                        return Marker(
                          point:
                              place.location,
                          width:
                              150,
                          height:
                              82,
                          child:
                              _buildPlaceMarker(
                            place,
                          ),
                        );
                      },
                    ).toList(),
                  ),

                  // ==================================
                  // CURRENT LOCATION MARKER
                  // ==================================

                  if (_currentLocation != null)
                    MarkerLayer(
                      markers: [
                        Marker(
                          point:
                              _currentLocation!,
                          width:
                              54,
                          height:
                              54,
                          child:
                              const RihalExploreCurrentLocationMarker(),
                        ),
                      ],
                    ),
                ],
              ),
            ),

            // ==================================
            // MAP TINT
            // ==================================

            IgnorePointer(
              child: Container(
                color:
                    RihalStyle.brown
                        .withValues(
                  alpha:
                      0.025,
                ),
              ),
            ),

            // ==================================
            // TOP AREA
            // ==================================

            SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.fromLTRB(
                  RihalStyle
                      .pageHorizontalPadding,
                  RihalStyle.spaceMd,
                  RihalStyle
                      .pageHorizontalPadding,
                  0,
                ),
                child: Column(
                  mainAxisSize:
                      MainAxisSize.min,
                  children: [
                    // ============================
                    // SEARCH BAR
                    // ============================

                    Row(
                      children: [
                        Expanded(
                          child:
                              RihalExploreSearchField(
                            controller:
                                _searchController,
                            onChanged: (_) {
                              setState(() {});
                            },
                          ),
                        ),

                        const SizedBox(
                          width: 9,
                        ),

                        RihalExploreCircleButton(
                          icon:
                              Icons.layers_rounded,
                          onTap:
                              _showMapOptions,
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 12,
                    ),

                    // ============================
                    // MAIN FILTERS
                    // ============================

                    RihalExploreFilterBar(
                      children: [
                        _mainFilter(
                          'الكل',
                        ),

                        _mainFilter(
                          'ترفيه',
                        ),

                        _mainFilter(
                          'دينية',
                        ),

                        _mainFilter(
                          'تراثي',
                        ),
                      ],
                    ),

                    // ============================
                    // ENTERTAINMENT SUBCATEGORIES
                    // ============================

                    if (selectedMainFilter ==
                        'ترفيه') ...[
                      const SizedBox(
                        height: 10,
                      ),

                      SizedBox(
                        height:
                            RihalStyle
                                .exploreCategoryHeight,
                        child: ListView(
                          scrollDirection:
                              Axis.horizontal,
                          children: [
                            _categoryButton(
                              title:
                                  'مطاعم',
                              icon:
                                  Icons.restaurant_rounded,
                            ),

                            _categoryButton(
                              title:
                                  'مقاهي',
                              icon:
                                  Icons.local_cafe_rounded,
                            ),

                            _categoryButton(
                              title:
                                  'فعاليات',
                              icon:
                                  Icons.celebration_outlined,
                            ),

                            _categoryButton(
                              title:
                                  'أسواق',
                              icon:
                                  Icons.shopping_bag_outlined,
                            ),

                            _categoryButton(
                              title:
                                  'متاحف',
                              icon:
                                  Icons.museum_outlined,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            // ==================================
            // MAP CONTROL BUTTONS
            // ==================================

            Positioned(
              left: 16,
              bottom:
                  selectedPlaces.isEmpty
                      ? 125
                      : 210,
              child: Column(
                mainAxisSize:
                    MainAxisSize.min,
                children: [
                  RihalMapButton(
                    icon:
                        Icons.navigation_rounded,
                    onTap: () {
                      _mapController.move(
                        madinahCenter,
                        14,
                      );
                    },
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  RihalMapButton(
                    icon:
                        Icons.my_location_rounded,
                    onTap:
                        _getCurrentLocation,
                    loading:
                        _isGettingLocation,
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  RihalMapButton(
                    icon:
                        Icons.add_rounded,
                    onTap:
                        _zoomIn,
                  ),

                  const SizedBox(
                    height: 9,
                  ),

                  RihalMapButton(
                    icon:
                        Icons.remove_rounded,
                    onTap:
                        _zoomOut,
                  ),
                ],
              ),
            ),

            // ==================================
            // PLAN CARD
            // ==================================

            if (selectedPlaces.isNotEmpty)
              Positioned(
                right:
                    RihalStyle
                        .pageHorizontalPadding,
                left:
                    RihalStyle
                        .pageHorizontalPadding,
                bottom:
                    105,
                child:
                    _buildMyPlanCard(),
              ),

            // ==================================
            // BOTTOM NAVIGATION
            // ==================================

            Positioned(
              right:
                  0,
              left:
                  0,
              bottom:
                  0,
              child:
                  RihalBottomNavigation(
                selectedIndex:
                    1,

                onMyTrips: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const MyTripsScreen(),
                    ),
                  );
                },

                onHome: () {},

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
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // PLACE MARKER
  // ==========================================

  Widget _buildPlaceMarker(
    RihalPlace place,
  ) {
    final isSelected =
        selectedPlaces.any(
      (item) =>
          item.name ==
          place.name,
    );

    final Color markerColor;

    if (place.category == 'دينية') {
      markerColor =
          RihalStyle.darkGreen;
    } else if (place.category ==
        'تراثي') {
      markerColor =
          RihalStyle.landmarkMarker;
    } else if (place.category ==
        'متاحف') {
      markerColor =
          RihalStyle.museumMarker;
    } else if (place.category ==
        'معالم') {
      markerColor =
          RihalStyle.landmarkMarker;
    } else {
      markerColor =
          RihalStyle.brown;
    }

    return RihalExplorePlaceMarker(
      name:
          place.name,
      icon:
          place.icon,
      color:
          markerColor,
      selected:
          isSelected,
      onTap: () {
        _showPlace(
          place,
        );
      },
    );
  }

  // ==========================================
  // MY PLAN CARD
  // ==========================================

  Widget _buildMyPlanCard() {
    return RihalExplorePlanCard(
      icons:
          selectedPlaces.map(
        (place) =>
            place.icon,
      ).toList(),
      onTap:
          _openTripPlan,
    );
  }

  // ==========================================
  // OPEN TRIP PLAN
  // ==========================================

  void _openTripPlan() {
    if (selectedPlaces.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        const SnackBar(
          content: Text(
            'اختاري مكانًا واحدًا على الأقل لإضافته إلى خطتك',
            textAlign:
                TextAlign.center,
          ),
        ),
      );

      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            const TripPlanScreen(),
      ),
    );
  }

  // ==========================================
  // OPEN PLACE DETAILS
  // ==========================================

  Future<void> _showPlace(
    RihalPlace place,
  ) async {
    final RihalPlace? selectedPlace =
        await Navigator.push<RihalPlace>(
      context,
      MaterialPageRoute(
        builder: (
          context,
        ) =>
            PlaceDetailsScreen(
          place:
              place,
        ),
      ),
    );

    if (!mounted) return;

    if (selectedPlace != null) {
      _addPlaceToPlan(
        selectedPlace,
      );
    }
  }

  // ==========================================
  // ADD PLACE TO PLAN
  // ==========================================

  void _addPlaceToPlan(
    RihalPlace place,
  ) {
    final alreadyAdded =
        selectedPlaces.any(
      (item) =>
          item.name ==
          place.name,
    );

    if (alreadyAdded) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
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
      selectedPlaces.add(
        place,
      );
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(
      SnackBar(
        content: Text(
          'تمت إضافة ${place.name} إلى خطتك',
          textAlign:
              TextAlign.center,
        ),
      ),
    );
  }

  // ==========================================
  // MAP OPTIONS
  // ==========================================

  void _showMapOptions() {
    showModalBottomSheet(
      context:
          context,
      backgroundColor:
          Colors.transparent,
      builder: (_) =>
          const RihalExploreMapOptionsSheet(),
    );
  }
}

// ==========================================
// PLACE MODEL
// ==========================================

class RihalPlace {
  final String name;

  final String category;

  final LatLng location;

  final IconData icon;

  final String? imagePath;

  const RihalPlace({
    required this.name,
    required this.category,
    required this.location,
    required this.icon,
    this.imagePath,
  });
}