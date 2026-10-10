import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class SelectedPlace {
  final LatLng location;
  final String name;

  const SelectedPlace({
    required this.location,
    required this.name,
  });
}

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Color darkGreen = const Color(0xFF30452D);

  LatLng selectedLocation = const LatLng(
    24.4672,
    39.6111,
  );

  String selectedPlaceName = 'حدد موقع السكن على الخريطة';

  bool isLoadingAddress = false;

  Future<void> _getPlaceName(LatLng location) async {
    setState(() {
      isLoadingAddress = true;
      selectedPlaceName = 'جاري تحديد الموقع...';
    });

    try {
      final uri = Uri.https(
        'nominatim.openstreetmap.org',
        '/reverse',
        {
          'format': 'jsonv2',
          'lat': location.latitude.toString(),
          'lon': location.longitude.toString(),
          'addressdetails': '1',
          'accept-language': 'ar',
        },
      );

      final response = await http.get(
        uri,
        headers: {
          'User-Agent': 'Rihal/1.0',
          'Accept-Language': 'ar',
        },
      );

      if (response.statusCode == 200) {
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

        // الأولوية لاسم الفندق أو المكان
        if (placeName != null && placeName.isNotEmpty) {
          result = placeName;
        } else if (tourism != null && tourism.isNotEmpty) {
          result = tourism;
        } else if (amenity != null && amenity.isNotEmpty) {
          result = amenity;
        } else if (building != null && building.isNotEmpty) {
          result = building;
        }

        // إذا لم نجد اسم منشأة، نعرض عنوانًا مختصرًا
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

        // آخر حل: display_name
        if (result.isEmpty) {
          result =
              data['display_name']?.toString() ??
              'موقع محدد على الخريطة';
        }

        if (!mounted) return;

        setState(() {
          selectedPlaceName = result;
          isLoadingAddress = false;
        });
      } else {
        _addressError();
      }
    } catch (e) {
      _addressError();
    }
  }

  void _addressError() {
    if (!mounted) return;

    setState(() {
      selectedPlaceName = 'موقع محدد على الخريطة';
      isLoadingAddress = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Stack(
          children: [
            FlutterMap(
              options: MapOptions(
                initialCenter: selectedLocation,
                initialZoom: 13,

                onTap: (tapPosition, point) {
                  setState(() {
                    selectedLocation = point;
                  });

                  _getPlaceName(point);
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
                    Marker(
                      point: selectedLocation,
                      width: 60,
                      height: 60,
                      child: Icon(
                        Icons.location_on_rounded,
                        color: darkGreen,
                        size: 48,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // العنوان العلوي
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Container(
                  height: 65,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(
                      alpha: 0.94,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(
                          alpha: 0.12,
                        ),
                        blurRadius: 15,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.arrow_back_rounded,
                        ),
                      ),

                      const Expanded(
                        child: Text(
                          'حدد موقع سكنك',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(width: 48),
                    ],
                  ),
                ),
              ),
            ),

            // اسم الموقع المحدد
            Positioned(
              right: 20,
              left: 20,
              bottom: 112,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(
                    alpha: 0.95,
                  ),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: 0.10,
                      ),
                      blurRadius: 12,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      color: darkGreen,
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: Text(
                        selectedPlaceName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    if (isLoadingAddress)
                      const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // زر التأكيد
            Positioned(
              right: 20,
              left: 20,
              bottom: 35,
              child: SafeArea(
                child: SizedBox(
                  height: 62,
                  child: ElevatedButton.icon(
                    onPressed: isLoadingAddress
                        ? null
                        : () {
                            Navigator.pop(
                              context,
                              SelectedPlace(
                                location: selectedLocation,
                                name: selectedPlaceName,
                              ),
                            );
                          },
                    icon: const Icon(
                      Icons.check_circle_outline_rounded,
                    ),
                    label: const Text(
                      'تأكيد موقع السكن',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: darkGreen,
                      foregroundColor: Colors.white,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
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
}