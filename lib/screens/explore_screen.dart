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
  // FILTER PLACES
  // ==========================================

  List<RihalPlace> get filteredPlaces {
    return places.where((place) {
      final search = _searchController.text
          .trim()
          .toLowerCase();

      bool matchesSearch = true;
      bool matchesMain = true;
      bool matchesCategory = true;

      if (search.isNotEmpty) {
        final localizedName =
            RihalTranslations.tr(context, place.name).toLowerCase();
        matchesSearch =
            place.name.toLowerCase().contains(search) ||
            localizedName.contains(search);
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

  // ==========================================
  // LOCATION MESSAGE
  // ==========================================

  void _showLocationMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
        ),
        backgroundColor: RihalStyle.darkGreen,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }

  // ==========================================
  // GET CURRENT LOCATION
  // ==========================================

  Future<void> _getCurrentLocation() async {
    if (_isGettingLocation) return;

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

      if (permission == LocationPermission.denied) {
        permission =
            await Geolocator.requestPermission();

        if (!mounted) return;
      }

      if (permission == LocationPermission.denied) {
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
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 12),
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
  // MOVE MAP TO LOCATION
  // ==========================================

  void _moveToCurrentLocation(LatLng point) {
    setState(() {
      _currentLocation = point;
    });

    _mapController.move(point, 16);
  }

  // ==========================================
  // ZOOM
  // ==========================================

  void _zoomIn() {
    final zoom =
        (_mapController.camera.zoom + 1)
            .clamp(3.0, 18.0)
            .toDouble();

    _mapController.move(
      _mapController.camera.center,
      zoom,
    );
  }

  void _zoomOut() {
    final zoom =
        (_mapController.camera.zoom - 1)
            .clamp(3.0, 18.0)
            .toDouble();

    _mapController.move(
      _mapController.camera.center,
      zoom,
    );
  }

  // ==========================================
  // MAIN FILTER
  // ==========================================

  Widget _mainFilter(String title) {
    return RihalExploreMainFilter(
      title: title,
      selected: selectedMainFilter == title,
      onTap: () {
        setState(() {
          selectedMainFilter = title;
          selectedCategory = 'الكل';
        });
      },
    );
  }

  // ==========================================
  // CATEGORY FILTER
  // ==========================================

  Widget _categoryButton({
    required String title,
    required IconData icon,
  }) {
    return RihalExploreCategoryButton(
      title: title,
      icon: icon,
      selected: selectedCategory == title,
      onTap: () {
        setState(() {
          if (selectedCategory == title) {
            selectedCategory = 'الكل';
          } else {
            selectedCategory = title;
          }

          selectedMainFilter = 'الكل';
        });
      },
    );
  }

  // ==========================================
  // BUILD SCREEN
  // ==========================================

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: RihalTranslations.direction(context),
      child: Scaffold(
        backgroundColor: RihalStyle.background,
        body: Stack(
          children: [
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

                  if (_currentLocation != null)
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: _currentLocation!,
                          width: 54,
                          height: 54,
                          child:
                              const RihalExploreCurrentLocationMarker(),
                        ),
                      ],
                    ),
                ],
              ),
            ),

            IgnorePointer(
              child: Container(
                color: RihalStyle.brown.withValues(
                  alpha: 0.025,
                ),
              ),
            ),

            SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  RihalStyle.pageHorizontalPadding,
                  RihalStyle.spaceMd,
                  RihalStyle.pageHorizontalPadding,
                  0,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // بدون أيقونة الحساب
                    Row(
                      children: [
                        Expanded(
                          child: RihalExploreSearchField(
                            controller: _searchController,
                            onChanged: (_) {
                              setState(() {});
                            },
                          ),
                        ),

                        const SizedBox(width: 9),

                        RihalExploreCircleButton(
                          icon: Icons.layers_rounded,
                          onTap: _showMapOptions,
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    RihalExploreFilterBar(
                      children: [
                        _mainFilter('الكل'),
                        _mainFilter('ترفيه'),
                        _mainFilter('دينية'),
                      ],
                    ),

                    const SizedBox(height: 10),

                    SizedBox(
                      height:
                          RihalStyle.exploreCategoryHeight,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
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

            Positioned(
              left: 16,
              bottom:
                  selectedPlaces.isEmpty ? 125 : 210,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RihalMapButton(
                    icon: Icons.navigation_rounded,
                    onTap: () {
                      _mapController.move(
                        madinahCenter,
                        14,
                      );
                    },
                  ),

                  const SizedBox(height: 10),

                  RihalMapButton(
                    icon: Icons.my_location_rounded,
                    onTap: _getCurrentLocation,
                    loading: _isGettingLocation,
                  ),

                  const SizedBox(height: 10),

                  RihalMapButton(
                    icon: Icons.add_rounded,
                    onTap: _zoomIn,
                  ),

                  const SizedBox(height: 9),

                  RihalMapButton(
                    icon: Icons.remove_rounded,
                    onTap: _zoomOut,
                  ),
                ],
              ),
            ),

            if (selectedPlaces.isNotEmpty)
              Positioned(
                right:
                    RihalStyle.pageHorizontalPadding,
                left:
                    RihalStyle.pageHorizontalPadding,
                bottom: 105,
                child: _buildMyPlanCard(),
              ),

            Positioned(
              right: 0,
              left: 0,
              bottom: 0,
              child: RihalBottomNavigation(
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

  Widget _buildPlaceMarker(RihalPlace place) {
    final isSelected = selectedPlaces.any(
      (item) => item.name == place.name,
    );

    final Color markerColor;

    if (place.category == 'دينية') {
      markerColor = RihalStyle.darkGreen;
    } else if (place.category == 'متاحف') {
      markerColor = RihalStyle.museumMarker;
    } else if (place.category == 'معالم') {
      markerColor = RihalStyle.landmarkMarker;
    } else {
      markerColor = RihalStyle.brown;
    }

    return RihalExplorePlaceMarker(
      name: place.name,
      icon: place.icon,
      color: markerColor,
      selected: isSelected,
      onTap: () => _showPlace(place),
    );
  }

  // ==========================================
  // MY PLAN CARD
  // ==========================================

  Widget _buildMyPlanCard() {
    return RihalExplorePlanCard(
      icons: selectedPlaces
          .map((place) => place.icon)
          .toList(),
      onTap: _openTripPlan,
    );
  }

  // ==========================================
  // OPEN TRIP PLAN
  // ==========================================

  void _openTripPlan() {
    const requiredPlaces = {
      'جبل أحد',
      'متحف دار المدينة',
      'مسجد قباء',
      'جادة قباء',
    };

    final chosenNames =
        selectedPlaces.map((place) => place.name).toSet();

    if (chosenNames.length != 4 ||
        !chosenNames.containsAll(requiredPlaces)) {
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
      MaterialPageRoute(
        builder: (_) => const TripPlanScreen(),
      ),
    );
  }

  // ==========================================
  // OPEN PLACE DETAILS
  // ==========================================

  Future<void> _showPlace(RihalPlace place) async {
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

    if (!mounted) return;

    if (selectedPlace != null) {
      _addPlaceToPlan(selectedPlace);
    }
  }

  // ==========================================
  // ADD PLACE TO PLAN
  // ==========================================

  void _addPlaceToPlan(RihalPlace place) {
    final alreadyAdded = selectedPlaces.any(
      (item) => item.name == place.name,
    );

    if (alreadyAdded) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${place.name} موجود بالفعل في خطتك',
            textAlign: TextAlign.center,
          ),
        ),
      );

      return;
    }

    setState(() {
      selectedPlaces.add(place);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'تمت إضافة ${place.name} إلى خطتك',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  // ==========================================
  // MAP OPTIONS
  // ==========================================

  void _showMapOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
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