import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'l10n/app_localizations.dart';
import 'localization/locale_controller.dart';
import 'rihal_style.dart';
import 'screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final preferences = await SharedPreferences.getInstance();
  final localeController = LocaleController(preferences)
    ..loadSavedLocale();

  runApp(
    RihalApp(
      localeController: localeController,
    ),
  );
}

class RihalApp extends StatelessWidget {
  const RihalApp({
    super.key,
    required this.localeController,
  });

  final LocaleController localeController;

  @override
  Widget build(BuildContext context) {
    return LocaleScope(
      controller: localeController,
      child: AnimatedBuilder(
        animation: localeController,
        builder: (context, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Rihal',
            theme: RihalStyle.theme,
            locale: localeController.locale,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            localeResolutionCallback: (deviceLocale, supportedLocales) {
              if (deviceLocale == null) {
                return localeController.locale;
              }

              for (final locale in supportedLocales) {
                if (locale.languageCode == deviceLocale.languageCode) {
                  return locale;
                }
              }

              return const Locale('ar');
            },
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
