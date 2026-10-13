import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'services/api_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  testBackendConnection();
  runApp(const RihalApp());
}

Future<void> testBackendConnection() async {
  try {
    final places = await ApiService.getPlaces();

    debugPrint('Backend connected successfully!');
    debugPrint('Number of places: ${places.length}');

    for (final place in places) {
      debugPrint('Place: ${place['name_ar']}');
    }
  } catch (e) {
    debugPrint('Backend connection failed: $e');
  }
}

class RihalApp extends StatelessWidget {
  const RihalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
