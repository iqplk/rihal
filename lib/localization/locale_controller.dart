import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleController extends ChangeNotifier {
  LocaleController(this._prefs);

  static const _storageKey = 'rihal_locale';

  final SharedPreferences _prefs;

  static const supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('tr'),
    Locale('ur'),
  ];

  Locale _locale = const Locale('ar');

  Locale get locale => _locale;

  void loadSavedLocale() {
    final code = _prefs.getString(_storageKey);

    if (code == null) return;

    final isSupported = supportedLocales.any(
      (locale) => locale.languageCode == code,
    );

    if (isSupported) {
      _locale = Locale(code);
    }
  }

  Future<void> setLocale(Locale locale) async {
    final isSupported = supportedLocales.any(
      (item) => item.languageCode == locale.languageCode,
    );

    if (!isSupported || _locale.languageCode == locale.languageCode) {
      return;
    }

    _locale = Locale(locale.languageCode);
    notifyListeners();

    await _prefs.setString(
      _storageKey,
      _locale.languageCode,
    );
  }
}

class LocaleScope extends InheritedNotifier<LocaleController> {
  const LocaleScope({
    super.key,
    required LocaleController controller,
    required super.child,
  }) : super(notifier: controller);

  static LocaleController of(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<LocaleScope>();

    assert(scope != null, 'LocaleScope was not found above this context.');

    return scope!.notifier!;
  }
}
