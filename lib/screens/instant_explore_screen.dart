import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

/// نموذج عرض للاستكشاف اللحظي: الاقتراحات والمواقع والأوقات ليست بيانات مباشرة.
class InstantExploreScreen extends StatefulWidget {
  const InstantExploreScreen({super.key});

  @override
  State<InstantExploreScreen> createState() => _InstantExploreScreenState();
}

class _InstantExploreScreenState extends State<InstantExploreScreen> {
  static const green = Color(0xFF30452D);
  static const cream = Color(0xFFF7EFE3);
  static const brown = Color(0xFF79553B);
  int minutes = 90;
  String category = 'الكل';
  bool showResults = false;
  final MapController mapController = MapController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _showNearbyResults() {
    setState(() => showResults = true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 550),
        curve: Curves.easeInOut,
      );
    });
  }
  // إحداثيات تقريبية للديمو، وليست نتائج توجيه أو ملاحة.
  static const museum = LatLng(24.4515, 39.6534);
  static const mall = LatLng(24.4780, 39.6650);

  @override
  Widget build(BuildContext context) => Directionality(
    textDirection: TextDirection.rtl,
    child: Scaffold(
      backgroundColor: cream,
      appBar: AppBar(
        backgroundColor: cream,
        centerTitle: true,
        title: const Text('الاستكشاف اللحظي', style: TextStyle(color: green, fontWeight: FontWeight.bold)),
        leading: IconButton(icon: const Icon(Icons.arrow_forward_ios_rounded, color: green), onPressed: () => Navigator.pop(context)),
      ),
      body: Column(children: [
        Expanded(child: ListView(controller: _scrollController, padding: const EdgeInsets.all(17), children: [
          const Icon(Icons.explore_rounded, color: green, size: 54),
          const SizedBox(height: 8),
          const Text('لديك وقت فراغ؟', textAlign: TextAlign.center, style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: green)),
          const SizedBox(height: 6),
          const Text('اكتشف مكانًا مناسبًا قبل موعدك التالي', textAlign: TextAlign.center, style: TextStyle(fontSize: 15, color: brown)),
          const SizedBox(height: 18),
          _card(Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Row(children: [Icon(Icons.location_on_rounded, color: green), SizedBox(width: 8), Text('موقعك الحالي', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))]),
            const SizedBox(height: 6),
            const Text('جبل أحد )', style: TextStyle(color: brown)),
            const Divider(height: 25),
            const Row(children: [Icon(Icons.flag_rounded, color: green), SizedBox(width: 8), Text('وجهتك التالية', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))]),
            const SizedBox(height: 6),
            const Text('متحف دار المدينة — 11:00 صباحًا', style: TextStyle(color: brown)),
          ])),
          const SizedBox(height: 13),
          _card(Column(children: [
            const Row(children: [Icon(Icons.access_time_rounded, color: green), SizedBox(width: 8), Text('الوقت المتاح', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17))]),
            const SizedBox(height: 13),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              IconButton.filledTonal(onPressed: minutes > 30 ? () => setState(() {minutes -= 15; showResults = false;}) : null, icon: const Icon(Icons.remove)),
              Text('$minutes دقيقة', style: const TextStyle(fontSize: 23, fontWeight: FontWeight.bold, color: green)),
              IconButton.filled(onPressed: minutes < 180 ? () => setState(() {minutes += 15; showResults = false;}) : null, style: IconButton.styleFrom(backgroundColor: green), icon: const Icon(Icons.add)),
            ]),
            const Text('من 9:30 إلى 11:00 صباحًا في مثال رحلتك', style: TextStyle(fontSize: 12, color: brown)),
          ])),
          const SizedBox(height: 15),
          const Text('الاهتمامات (اختياري)', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: green)),
          const SizedBox(height: 9),
          Wrap(spacing: 8, runSpacing: 6, children: ['الكل', 'أسواق', 'مقاهي'].map((c) => ChoiceChip(
            label: Text(c), selected: category == c,
            selectedColor: green, labelStyle: TextStyle(color: category == c ? Colors.white : brown),
            onSelected: (_) => setState(() {category = c; showResults = false;}),
          )).toList()),
          const SizedBox(height: 18),
          SizedBox(height: 56, child: ElevatedButton.icon(
            onPressed: _showNearbyResults,
            style: ElevatedButton.styleFrom(backgroundColor: green, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18))),
            icon: const Icon(Icons.auto_awesome_rounded), label: const Text('ابحث عن أماكن قريبة', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          )),
          if (showResults) ...[
            const SizedBox(height: 22),
            const Text('اقتراحات قبل زيارة المتحف', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: green)),
            const SizedBox(height: 8),
            const Text(' يجب التحقق من المسافات وأوقات العمل والتنقل.', style: TextStyle(fontSize: 12, color: brown)),
            const SizedBox(height: 12),
            SizedBox(height: 225, child: ClipRRect(borderRadius: BorderRadius.circular(20), child: FlutterMap(
              mapController: mapController,
              options: const MapOptions(initialCenter: LatLng(24.465, 39.659), initialZoom: 12.3),
              children: [
                TileLayer(urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png', userAgentPackageName: 'com.example.rihal'),
                MarkerLayer(markers: [
                  Marker(point: museum, width: 52, height: 52, child: const Icon(Icons.museum_rounded, color: green, size: 39)),
                  if (category != 'مقاهي') Marker(point: mall, width: 52, height: 52, child: const Icon(Icons.shopping_bag_rounded, color: brown, size: 39)),
                ]),
              ],
            ))),
            const SizedBox(height: 12),
            if (category != 'مقاهي') _result('الراشد ميغا مول', 'تسوق ومقاهٍ ومطاعم', Icons.shopping_bag_rounded),
            if (category != 'أسواق') _result('استراحة في مقهى', 'اختاري مقهى مناسبًا بعد التحقق من موقعه', Icons.local_cafe_rounded),
            const SizedBox(height: 9),
            const Text('مهم: خصّصي وقتًا للوصول إلى المتحف قبل 11:00 ص. لا تُحسب أزمنة القيادة مباشرة في هذه النسخة.', style: TextStyle(fontSize: 12, height: 1.5, color: brown)),
          ],
        ])),
        _bottomNavigation(),
      ]),
    ),
  );

  Widget _card(Widget child) => Container(width: double.infinity, padding: const EdgeInsets.all(18), decoration: BoxDecoration(color: Colors.white.withValues(alpha: .82), borderRadius: BorderRadius.circular(20)), child: child);

  Widget _result(String name, String detail, IconData icon) => Padding(padding: const EdgeInsets.only(bottom: 10), child: _card(Row(children: [
    Container(width: 56, height: 56, decoration: BoxDecoration(color: cream, borderRadius: BorderRadius.circular(14)), child: Icon(icon, color: green, size: 29)),
    const SizedBox(width: 12),
    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(name, style: const TextStyle(fontWeight: FontWeight.bold, color: green, fontSize: 17)), const SizedBox(height: 5), Text(detail, style: const TextStyle(color: brown, fontSize: 13))])),
  ])));

  Widget _bottomNavigation() => Container(
    padding: const EdgeInsets.fromLTRB(8, 10, 8, 10),
    decoration: const BoxDecoration(color: Color(0xFFF9F1E5), borderRadius: BorderRadius.vertical(top: Radius.circular(22))),
    child: SafeArea(top: false, child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
      _nav(Icons.calendar_month_outlined, 'رحلاتي', false, () {Navigator.of(context).popUntil((route) => route.isFirst);}),
      _nav(Icons.home_rounded, 'الرئيسية', false, () {Navigator.of(context).popUntil((route) => route.isFirst);}),
      _nav(Icons.explore_rounded, 'استكشاف لحظي', true, () {}),
    ])),
  );

  Widget _nav(IconData icon, String label, bool active, VoidCallback onTap) => InkWell(onTap: onTap, child: Padding(padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3), child: Column(mainAxisSize: MainAxisSize.min, children: [
    Icon(icon, color: active ? green : brown, size: 26),
    const SizedBox(height: 4),
    Text(label, style: TextStyle(fontSize: 11, color: active ? green : brown, fontWeight: active ? FontWeight.bold : FontWeight.normal)),
  ])));
}
