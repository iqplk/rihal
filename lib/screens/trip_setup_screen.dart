import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import 'map_screen.dart';
import 'explore_screen.dart';

class TripSetupScreen extends StatefulWidget {
  const TripSetupScreen({super.key});

  @override
  State<TripSetupScreen> createState() => _TripSetupScreenState();
}

class _TripSetupScreenState extends State<TripSetupScreen> {
  final Color darkGreen = const Color(0xFF30452D);
  final Color brown = const Color(0xFF6B4423);

  String selectedLanguage = 'العربية';

  DateTime? startDate;
  DateTime? endDate;

  LatLng? selectedHomeLocation;

  final TextEditingController _locationController =
      TextEditingController();

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  // ==========================
  // حساب عدد الأيام
  // ==========================

  int get numberOfDays {
    if (startDate == null || endDate == null) {
      return 0;
    }

    return endDate!.difference(startDate!).inDays + 1;
  }

  // ==========================
  // اختيار تاريخ البداية
  // ==========================

  Future<void> _selectStartDate() async {
    final DateTime now = DateTime.now();

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: startDate ?? now,
      firstDate: now,
      lastDate: DateTime(now.year + 3),
      helpText: 'اختر تاريخ بداية الرحلة',
      cancelText: 'إلغاء',
      confirmText: 'اختيار',
    );

    if (picked != null) {
      setState(() {
        startDate = picked;

        if (endDate != null && endDate!.isBefore(startDate!)) {
          endDate = null;
        }
      });
    }
  }

  // ==========================
  // اختيار تاريخ النهاية
  // ==========================

  Future<void> _selectEndDate() async {
    if (startDate == null) {
      _showMessage('اختاري تاريخ بداية الرحلة أولاً');
      return;
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: endDate ?? startDate!,
      firstDate: startDate!,
      lastDate: DateTime(startDate!.year + 3),
      helpText: 'اختر تاريخ نهاية الرحلة',
      cancelText: 'إلغاء',
      confirmText: 'اختيار',
    );

    if (picked != null) {
      setState(() {
        endDate = picked;
      });
    }
  }

  // ==========================
  // تنسيق التاريخ
  // ==========================

  String _formatDate(DateTime? date) {
    if (date == null) {
      return 'اختر التاريخ';
    }

    return '${date.day}/${date.month}/${date.year}';
  }

  // ==========================
  // فتح خريطة تحديد السكن
  // ==========================

  Future<void> _openMap() async {
    final SelectedPlace? place =
        await Navigator.push<SelectedPlace>(
      context,
      MaterialPageRoute(
        builder: (context) => const MapScreen(),
      ),
    );

    if (place != null) {
      setState(() {
        selectedHomeLocation = place.location;
        _locationController.text = place.name;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            // ==========================
            // الخلفية
            // ==========================

            Image.asset(
              'assets/images/2.jpg',
              fit: BoxFit.cover,
            ),

            Container(
              color: Colors.white.withValues(alpha: 0.10),
            ),

            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  15,
                  20,
                  30,
                ),
                child: Column(
                  children: [
                    // ==========================
                    // اختيار اللغة
                    // ==========================

                    Align(
                      alignment: Alignment.centerRight,
                      child: PopupMenuButton<String>(
                        onSelected: (value) {
                          setState(() {
                            selectedLanguage = value;
                          });
                        },
                        color: const Color(0xFFF9F1E5),
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        itemBuilder: (context) => const [
                          PopupMenuItem(
                            value: 'العربية',
                            child: Text('🇸🇦  العربية'),
                          ),
                          PopupMenuItem(
                            value: 'English',
                            child: Text('🇬🇧  English'),
                          ),
                          PopupMenuItem(
                            value: 'Urdu',
                            child: Text('🇵🇰  Urdu'),
                          ),
                          PopupMenuItem(
                            value: 'Türkçe',
                            child: Text('🇹🇷  Türkçe'),
                          ),
                        ],
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(
                              alpha: 0.50,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: brown.withValues(alpha: 0.10),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.language_rounded,
                                size: 16,
                                color: brown,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                selectedLanguage,
                                style: TextStyle(
                                  color: darkGreen,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 2),
                              Icon(
                                Icons.keyboard_arrow_down_rounded,
                                size: 16,
                                color: brown,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 2),

                    // ==========================
                    // اللوقو
                    // ==========================

                    Image.asset(
                      'assets/images/1.png',
                      width: 155,
                      height: 120,
                      fit: BoxFit.contain,
                    ),

                    const SizedBox(height: 4),

                    Text(
                      'لنبدأ رحلتك',
                      style: TextStyle(
                        color: darkGreen,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 28),

                    // ==========================
                    // مدة الإقامة
                    // ==========================

                    _buildCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _sectionTitle(
                            Icons.calendar_month_rounded,
                            'مدة الإقامة',
                          ),

                          const SizedBox(height: 22),

                          Row(
                            children: [
                              Expanded(
                                child: _dateBox(
                                  title: 'من',
                                  date: _formatDate(startDate),
                                  onTap: _selectStartDate,
                                ),
                              ),

                              const SizedBox(width: 12),

                              Expanded(
                                child: _dateBox(
                                  title: 'إلى',
                                  date: _formatDate(endDate),
                                  onTap: _selectEndDate,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          Center(
                            child: Text(
                              numberOfDays == 0
                                  ? 'حددي تاريخ الرحلة'
                                  : 'عدد الأيام: $numberOfDays ${numberOfDays == 1 ? 'يوم' : 'أيام'}',
                              style: TextStyle(
                                color: darkGreen,
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 18),

                    // ==========================
                    // موقع السكن
                    // ==========================

                    _buildCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _sectionTitle(
                            Icons.home_rounded,
                            'حدد موقع سكنك',
                          ),

                          const SizedBox(height: 8),

                          const Text(
                            'اختر موقع الفندق أو مكان إقامتك على الخريطة',
                            style: TextStyle(
                              color: Color(0xFF8B8178),
                              fontSize: 13,
                            ),
                          ),

                          const SizedBox(height: 16),

                          // ==========================
                          // اسم الموقع المختار
                          // ==========================

                          InkWell(
                            onTap: _openMap,
                            borderRadius: BorderRadius.circular(18),
                            child: Container(
                              constraints: const BoxConstraints(
                                minHeight: 62,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(
                                  alpha: 0.55,
                                ),
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                  color: brown.withValues(
                                    alpha: 0.20,
                                  ),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.location_on_outlined,
                                    color: brown,
                                    size: 25,
                                  ),

                                  const SizedBox(width: 10),

                                  Expanded(
                                    child: Text(
                                      selectedHomeLocation == null
                                          ? 'اضغط لتحديد موقع السكن'
                                          : _locationController.text,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color:
                                            selectedHomeLocation == null
                                                ? const Color(
                                                    0xFF9B9085,
                                                  )
                                                : darkGreen,
                                        fontSize: 14,
                                        fontWeight:
                                            selectedHomeLocation == null
                                                ? FontWeight.normal
                                                : FontWeight.w600,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(width: 8),

                                  Icon(
                                    Icons.arrow_back_ios_new_rounded,
                                    color: darkGreen,
                                    size: 16,
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 15),

                          // ==========================
                          // مربع الخريطة
                          // ==========================

                          InkWell(
                            onTap: _openMap,
                            borderRadius: BorderRadius.circular(18),
                            child: Container(
                              height: 145,
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFECE2D2),
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Opacity(
                                    opacity: 0.12,
                                    child: Icon(
                                      Icons.map_rounded,
                                      size: 130,
                                      color: brown,
                                    ),
                                  ),

                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.location_on_rounded,
                                        color: darkGreen,
                                        size: 42,
                                      ),

                                      const SizedBox(height: 6),

                                      Text(
                                        selectedHomeLocation == null
                                            ? 'فتح الخريطة'
                                            : _locationController.text,
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: darkGreen,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),

                                      const SizedBox(height: 3),

                                      Text(
                                        selectedHomeLocation == null
                                            ? 'اضغط هنا لتحديد الموقع'
                                            : 'اضغط لتغيير الموقع',
                                        style: const TextStyle(
                                          color: Color(0xFF8B8178),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 25),

                    // ==========================
                    // استكشف الأماكن
                    // ==========================

                    SizedBox(
                      width: double.infinity,
                      height: 65,
                      child: ElevatedButton(
                        onPressed: _explorePlaces,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: darkGreen,
                          foregroundColor: Colors.white,
                          elevation: 3,
                          shadowColor:
                              Colors.black.withValues(alpha: 0.15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(22),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'استكشف الأماكن',
                              style: TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: 15),
                            Icon(
                              Icons.arrow_back_rounded,
                              size: 27,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================
  // تصميم الكروت
  // ==========================

  Widget _buildCard({
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F1E5).withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.55),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: child,
    );
  }

  // ==========================
  // عنوان القسم
  // ==========================

  Widget _sectionTitle(
    IconData icon,
    String title,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          color: brown,
          size: 27,
        ),

        const SizedBox(width: 9),

        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF493629),
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // ==========================
  // التاريخ
  // ==========================

  Widget _dateBox({
    required String title,
    required String date,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Text(
            title,
            style: TextStyle(
              color: brown,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        const SizedBox(height: 7),

        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(17),
          child: Container(
            height: 62,
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.55),
              borderRadius: BorderRadius.circular(17),
              border: Border.all(
                color: brown.withValues(alpha: 0.18),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    date,
                    style: const TextStyle(
                      color: Color(0xFF55483D),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                Icon(
                  Icons.calendar_today_rounded,
                  color: brown,
                  size: 21,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ==========================
  // استكشف الأماكن
  // ==========================

  void _explorePlaces() {
    if (startDate == null || endDate == null) {
      _showMessage('الرجاء تحديد مدة الرحلة');
      return;
    }

    if (selectedHomeLocation == null) {
      _showMessage('الرجاء تحديد موقع السكن من الخريطة');
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ExploreScreen(),
      ),
    );
  }

  // ==========================
  // الرسائل
  // ==========================

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}