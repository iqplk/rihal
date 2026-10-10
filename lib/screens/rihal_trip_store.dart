import 'package:flutter/foundation.dart';

/// حفظ مؤقت داخل جلسة التطبيق، دون قاعدة بيانات.
class RihalTripStore {
  static final ValueNotifier<bool> isSaved = ValueNotifier<bool>(false);

  static void save() => isSaved.value = true;
}
