import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart' hide Text;
import '../localization/rihal_localized_text.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

import '../rihal_style.dart';

// ==========================================
// SELECTED PLACE MODEL
// ==========================================

class SelectedPlace {
  final LatLng location;
  final String name;

  const SelectedPlace({
    required this.location,
    required this.name,
  });
}

// ==========================================
// MAP SCREEN
// ==========================================

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen>
    with SingleTickerProviderStateMixin {
  // ==========================================
  // MAP DATA
  // ==========================================

  final MapController _mapController = MapController();

  LatLng _selectedLocation = const LatLng(
    24.4672,
    39.6111,
  );

  String _selectedPlaceName = 'اضغطي على الخريطة لتحديد الموقع';

  bool _hasSelectedLocation = false;
  bool _isLoadingAddress = false;
  bool _isGettingLocation = false;

  int _addressRequestId = 0;

  Timer? _addressDebounce;

  // ==========================================
  // ANIMATION
  // ==========================================

  late final AnimationController _pinController;
  late final Animation<double> _pinScale;

  @override
  void initState() {
    super.initState();

    _pinController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    _pinScale = CurvedAnimation(
      parent: _pinController,
      curve: Curves.easeOutBack,
    );
  }

  void _animatePin() {
    _pinController.forward(from: 0);
  }

  // ==========================================
  // SELECT LOCATION - FAST
  // ==========================================

  void _selectLocation(LatLng location) {
    // Cancel previous scheduled address lookup.
    _addressDebounce?.cancel();

    // Invalidate older address requests.
    final requestId = ++_addressRequestId;

    // Update marker immediately.
    setState(() {
      _selectedLocation = location;
      _hasSelectedLocation = true;
      _selectedPlaceName = 'الموقع المحدد';
      _isLoadingAddress = true;
    });

    _animatePin();

    // Wait briefly before requesting the address.
    // This avoids repeated requests when the user taps quickly.
    _addressDebounce = Timer(
      const Duration(milliseconds: 350),
      () {
        _getPlaceName(
          location,
          requestId,
        );
      },
    );
  }

  // ==========================================
  // CURRENT LOCATION - FASTER
  // ==========================================

  Future<void> _getCurrentLocation() async {
    if (_isGettingLocation) return;

    setState(() {
      _isGettingLocation = true;
    });

    try {
      final enabled =
          await Geolocator.isLocationServiceEnabled();

      if (!enabled) {
        _showMessage('فعّلي خدمات الموقع من إعدادات الجهاز');
        return;
      }

      LocationPermission permission =
          await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        _showMessage('يرجى السماح للتطبيق بالوصول إلى الموقع');
        return;
      }

      if (permission == LocationPermission.deniedForever) {
        _showMessage(
          'فعّلي إذن الموقع من إعدادات التطبيق',
        );
        return;
      }

      // Step 1: Try showing the last known location immediately.
      final lastPosition =
          await Geolocator.getLastKnownPosition();

      if (!mounted) return;

      if (lastPosition != null) {
        final cachedLocation = LatLng(
          lastPosition.latitude,
          lastPosition.longitude,
        );

        _mapController.move(cachedLocation, 16);
        _selectLocation(cachedLocation);
      }

      // Step 2: Fetch a fresh position.
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 12),
        ),
      );

      if (!mounted) return;

      final currentLocation = LatLng(
        position.latitude,
        position.longitude,
      );

      _mapController.move(currentLocation, 16);
      _selectLocation(currentLocation);

      _showMessage('تم تحديث موقعك الحالي');
    } on TimeoutException {
      if (!mounted) return;

      _showMessage(
        'تأخر تحديد الموقع، حاولي مرة أخرى',
      );
    } catch (error) {
      if (!mounted) return;

      _showMessage(
        'تعذر تحديد الموقع، تأكدي من تشغيل GPS',
      );
    } finally {
      if (mounted) {
        setState(() {
          _isGettingLocation = false;
        });
      }
    }
  }

  // ==========================================
  // ZOOM
  // ==========================================

  void _zoomIn() {
    final zoom = (_mapController.camera.zoom + 1)
        .clamp(3.0, 18.0)
        .toDouble();

    _mapController.move(
      _mapController.camera.center,
      zoom,
    );
  }

  void _zoomOut() {
    final zoom = (_mapController.camera.zoom - 1)
        .clamp(3.0, 18.0)
        .toDouble();

    _mapController.move(
      _mapController.camera.center,
      zoom,
    );
  }

  // ==========================================
  // REVERSE GEOCODING
  // ==========================================

  Future<void> _getPlaceName(
    LatLng location,
    int requestId,
  ) async {
    try {
      final uri = Uri.https(
        'nominatim.openstreetmap.org',
        '/reverse',
        {
          'format': 'jsonv2',
          'lat': location.latitude.toString(),
          'lon': location.longitude.toString(),
          'addressdetails': '1',
          'accept-language': RihalTranslations.languageCode(context),
        },
      );

      final response = await http.get(
        uri,
        headers: {
          'User-Agent': 'Rihal/1.0',
          'Accept-Language': RihalTranslations.languageCode(context),
        },
      ).timeout(const Duration(seconds: 8));

      if (!mounted || requestId != _addressRequestId) {
        return;
      }

      if (response.statusCode != 200) {
        _addressError(requestId);
        return;
      }

      final data = jsonDecode(response.body);

      final address =
          data['address'] as Map<String, dynamic>? ?? {};

      final String? placeName =
          data['name']?.toString();

      final String? tourism =
          address['tourism']?.toString();

      final String? amenity =
          address['amenity']?.toString();

      final String? building =
          address['building']?.toString();

      final String? road =
          address['road']?.toString();

      final String? neighbourhood =
          address['neighbourhood']?.toString();

      final String? suburb =
          address['suburb']?.toString();

      final String? city =
          address['city']?.toString() ??
          address['town']?.toString() ??
          address['village']?.toString();

      String result = '';

      if (placeName != null && placeName.isNotEmpty) {
        result = placeName;
      } else if (tourism != null && tourism.isNotEmpty) {
        result = tourism;
      } else if (amenity != null && amenity.isNotEmpty) {
        result = amenity;
      } else if (building != null && building.isNotEmpty) {
        result = building;
      }

      if (result.isEmpty) {
        final parts = <String>[];

        if (road != null && road.isNotEmpty) {
          parts.add(road);
        }

        if (neighbourhood != null &&
            neighbourhood.isNotEmpty) {
          parts.add(neighbourhood);
        } else if (suburb != null && suburb.isNotEmpty) {
          parts.add(suburb);
        }

        if (city != null &&
            city.isNotEmpty &&
            !parts.contains(city)) {
          parts.add(city);
        }

        result = parts.join('، ');
      }

      if (result.isEmpty) {
        result =
            data['display_name']?.toString() ??
            'الموقع المحدد';
      }

      setState(() {
        _selectedPlaceName = result;
        _isLoadingAddress = false;
      });
    } catch (error) {
      _addressError(requestId);
    }
  }

  void _addressError(int requestId) {
    if (!mounted || requestId != _addressRequestId) {
      return;
    }

    setState(() {
      _selectedPlaceName = 'الموقع المحدد';
      _isLoadingAddress = false;
    });
  }

  // ==========================================
  // SNACKBAR
  // ==========================================

  void _showMessage(String message) {
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
  // RIHAL UI — MAP CONTROLS
  // ==========================================

  Widget _buildMapControls() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        RihalMapButton(
          icon: Icons.my_location_rounded,
          tooltip: RihalTranslations.tr(context, 'موقعي الحالي'),
          onTap: _getCurrentLocation,
          loading: _isGettingLocation,
        ),
        const SizedBox(height: 10),
        RihalMapButton(
          icon: Icons.add_rounded,
          tooltip: RihalTranslations.tr(context, 'تكبير الخريطة'),
          onTap: _zoomIn,
        ),
        const SizedBox(height: 9),
        RihalMapButton(
          icon: Icons.remove_rounded,
          tooltip: RihalTranslations.tr(context, 'تصغير الخريطة'),
          onTap: _zoomOut,
        ),
      ],
    );
  }

  // ==========================================
  // ANIMATED PIN — EXISTING BEHAVIOR
  // ==========================================

  Widget _buildAnimatedPin() =>
      RihalMapPin(scale: _pinScale);


  // ==========================================
  // HEADER
  // ==========================================

  Widget _buildHeader() => RihalMapHeader(
    onBack: () => Navigator.pop(context),
    title: 'حدد موقع إقامتك',
    subtitle: 'اختر موقع الفندق أو سكنك على الخريطة',
  );


  // ==========================================
  // MAP HINT
  // ==========================================

  Widget _buildMapHint() => RihalMapHint(hasSelectedLocation: _hasSelectedLocation);


  // ==========================================
  // SELECTED PLACE + CONFIRM BUTTON
  // ==========================================

  Widget _buildBottomBar() => RihalMapBottomBar(
    selectedPlaceName: _selectedPlaceName,
    isLoadingAddress: _isLoadingAddress,
    hasSelectedLocation: _hasSelectedLocation,
    onConfirm: () {
      Navigator.pop(
        context,
        SelectedPlace(
          location: _selectedLocation,
          name: _isLoadingAddress ? 'الموقع المحدد' : _selectedPlaceName,
        ),
      );
    },
  );


  // ==========================================
  // BUILD
  // ==========================================

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: RihalTranslations.direction(context),
      child: Scaffold(
        backgroundColor: RihalStyle.background,
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(22),
                    child: Stack(
                      children: [
                        FlutterMap(
                          mapController: _mapController,
                          options: MapOptions(
                            initialCenter: _selectedLocation,
                            initialZoom: 13,
                            onTap: (tapPosition, point) {
                              _selectLocation(point);
                            },
                          ),
                          children: [
                            TileLayer(
                              urlTemplate:
                                  'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                              userAgentPackageName: 'com.example.rihal',
                            ),
                            MarkerLayer(
                              markers: [
                                if (_hasSelectedLocation)
                                  Marker(
                                    point: _selectedLocation,
                                    width: 65,
                                    height: 65,
                                    child: _buildAnimatedPin(),
                                  ),
                              ],
                            ),
                          ],
                        ),
                        Positioned(
                          top: 14,
                          left: 14,
                          right: 14,
                          child: Center(child: _buildMapHint()),
                        ),
                        Positioned(
                          left: 14,
                          bottom: 18,
                          child: _buildMapControls(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              _buildBottomBar(),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================
  // DISPOSE
  // ==========================================

  @override
  void dispose() {
    _addressDebounce?.cancel();
    _addressRequestId++;

    _pinController.dispose();
    _mapController.dispose();

    super.dispose();
  }
}