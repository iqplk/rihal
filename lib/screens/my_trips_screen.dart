import 'package:flutter/material.dart';
import 'trip_plan_screen.dart';
import 'rihal_trip_store.dart';

/// شاشة رحلاتي - رحلة المدينة الحالية معدّة للعرض.
class MyTripsScreen extends StatefulWidget {
  const MyTripsScreen({super.key});

  @override
  State<MyTripsScreen> createState() => _MyTripsScreenState();
}

class _MyTripsScreenState extends State<MyTripsScreen> {
  static const green = Color(0xFF30452D);
  static const brown = Color(0xFF79553B);
  static const cream = Color(0xFFF7EFE3);
  bool upcoming = true;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: cream,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: cream,
          elevation: 0,
          centerTitle: true,
          title: const Text('رحلاتي', style: TextStyle(color: green, fontWeight: FontWeight.bold, fontSize: 24)),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 12),
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(color: const Color(0xFFFDF8F1), borderRadius: BorderRadius.circular(18)),
                child: Row(children: [
                  _tab('القادمة', true),
                  _tab('السابقة', false),
                ]),
              ),
            ),
            Expanded(
              child: upcoming
                  ? ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                      children: [
                        ValueListenableBuilder<bool>(
                          valueListenable: RihalTripStore.isSaved,
                          builder: (context, isSaved, _) => isSaved
                              ? _tripCard()
                              : const Padding(
                                  padding: EdgeInsets.only(top: 95),
                                  child: Center(child: Text('لا توجد رحلات محفوظة بعد', style: TextStyle(fontSize: 18, color: brown))),
                                ),
                        ),
                      ],
                    )
                  : Center(
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        Icon(Icons.luggage_outlined, size: 65, color: brown.withValues(alpha: .65)),
                        const SizedBox(height: 14),
                        const Text('لا توجد رحلات سابقة', style: TextStyle(fontSize: 18, color: brown)),
                      ]),
                    ),
            ),
          ],
        ),
        bottomNavigationBar: SafeArea(
          top: false,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
            decoration: const BoxDecoration(color: Color(0xFFFCF6ED), borderRadius: BorderRadius.vertical(top: Radius.circular(23))),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              _nav(Icons.calendar_month_rounded, 'رحلاتي', true, () {}),
              _nav(Icons.home_rounded, 'الرئيسية', false, () => Navigator.of(context).popUntil((route) => route.isFirst)),
              _nav(Icons.explore_outlined, 'استكشاف لحظي', false, () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('الاستكشاف اللحظي قريبًا')));
              }),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _tab(String label, bool value) => Expanded(
    child: InkWell(
      borderRadius: BorderRadius.circular(15),
      onTap: () => setState(() => upcoming = value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(color: upcoming == value ? green : Colors.transparent, borderRadius: BorderRadius.circular(15)),
        child: Text(label, textAlign: TextAlign.center, style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: upcoming == value ? Colors.white : brown)),
      ),
    ),
  );

  Widget _tripCard() => InkWell(
    borderRadius: BorderRadius.circular(22),
    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TripPlanScreen(readOnly: true))),
    child: Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9F0),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [BoxShadow(color: brown.withValues(alpha: .10), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Row(children: [
        Expanded(
          flex: 5,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('رحلتي إلى المدينة المنورة', maxLines: 2, style: TextStyle(color: Color(0xFF332C25), fontSize: 19, fontWeight: FontWeight.bold)),
            const SizedBox(height: 11),
            const Text('8 أكتوبر – 9 أكتوبر 2026', style: TextStyle(color: brown, fontSize: 14)),
            const SizedBox(height: 11),
            const Text('4 أماكن  •  يومان', style: TextStyle(color: brown, fontSize: 14)),
            const SizedBox(height: 8),
            const Row(children: [Icon(Icons.arrow_back_rounded, color: green, size: 18), SizedBox(width: 4), Text('عرض الخطة', style: TextStyle(color: green, fontWeight: FontWeight.w600))]),
          ]),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 4,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              'assets/images/quba_mosque.jpg',
              height: 160,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(height: 160, color: const Color(0xFFE4D8C6), child: const Icon(Icons.mosque_rounded, size: 52, color: green)),
            ),
          ),
        ),
      ]),
    ),
  );

  Widget _nav(IconData icon, String label, bool selected, VoidCallback onTap) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(12),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, color: selected ? green : brown, size: 26),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: selected ? green : brown, fontSize: 12, fontWeight: selected ? FontWeight.bold : FontWeight.normal)),
      ]),
    ),
  );
}
