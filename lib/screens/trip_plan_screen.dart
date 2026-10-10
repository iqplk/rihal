import 'package:flutter/material.dart';
import 'rihal_trip_store.dart';
import 'my_trips_screen.dart';
import 'instant_explore_screen.dart';

// واجهة خطة رِحال للديمو: الترتيب ثابت حاليًا، ويمكن استبداله بمخرجات AI لاحقًا.
class TripPlanScreen extends StatefulWidget {
  const TripPlanScreen({super.key, this.readOnly = false});

  final bool readOnly;

  @override
  State<TripPlanScreen> createState() => _TripPlanScreenState();
}

class _TripPlanScreenState extends State<TripPlanScreen> {
  static const Color green = Color(0xFF30452D);
  static const Color brown = Color(0xFF79553B);
  static const Color cream = Color(0xFFF7EFE3);

  int selectedDay = 0;
  bool planReady = false;
  bool saved = false;

  @override
  void initState() {
    super.initState();
    if (widget.readOnly) {
      planReady = true;
      saved = true;
    }
  }

  final List<List<_Stop>> days = const [
    [
      _Stop('جبل أحد', '08:00 – 09:30 ص', 'زيارة معلم تاريخي',
          'assets/images/uhud.jpg', Icons.landscape_rounded),
      _Stop('متحف دار المدينة', '11:00 ص – 12:30 م', 'تاريخ المدينة وتراثها',
          'assets/images/dar_al_madinah_museum.jpg', Icons.museum_rounded),
    ],
    [
      _Stop('مسجد قباء', '09:00 – 10:00 ص', 'زيارة المسجد والصلاة',
          'assets/images/quba_mosque.jpg', Icons.mosque_rounded),
      _Stop('جادة قباء', '10:15 – 11:45 ص', 'نزهة في الممشى',
          'assets/images/quba_walk.jpg', Icons.directions_walk_rounded),
    ],
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: cream,
        appBar: AppBar(
          backgroundColor: cream,
          centerTitle: true,
          title: const Text('خطتي', style: TextStyle(color: green, fontWeight: FontWeight.bold)),
          leading: IconButton(
            icon: const Icon(Icons.arrow_forward_ios_rounded, color: green),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(17, 8, 17, 20),
                  children: [
                    _header(),
                    const SizedBox(height: 18),
                    if (!planReady) ...[
                      _intro(),
                    ] else ...[
                      _daySelector(),
                      const SizedBox(height: 18),
                      ...List.generate(days[selectedDay].length, (i) => Column(children: [
                         _stopCard(days[selectedDay][i], i),
                         if (selectedDay == 0 && i == 0) _freeTimeCard(),
                       ])),
                      const SizedBox(height: 14),
                      _note(),
                    ],
                  ],
                ),
              ),
              if (!widget.readOnly) _bottomButton(),
              _bottomNavigation(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header() => Container(
    padding: const EdgeInsets.all(22),
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: 0.75),
      borderRadius: BorderRadius.circular(25),
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('رحلتي إلى المدينة المنورة',
          style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold, color: green)),
      const SizedBox(height: 10),
      const Row(children: [
        Icon(Icons.calendar_month_outlined, color: brown, size: 20),
        SizedBox(width: 7),
        Text('يومان', style: TextStyle(fontSize: 16, color: brown)),
        SizedBox(width: 20),
        Icon(Icons.place_outlined, color: brown, size: 20),
        SizedBox(width: 7),
        Text('4 أماكن', style: TextStyle(fontSize: 16, color: brown)),
      ]),
    ]),
  );

  Widget _intro() => Container(
    padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 32),
    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.7), borderRadius: BorderRadius.circular(24)),
    child: const Column(children: [
      Icon(Icons.auto_awesome_rounded, color: green, size: 52),
      SizedBox(height: 18),
      Text('أماكنك جاهزة للترتيب',
          style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold, color: green)),
      SizedBox(height: 10),
      Text('سنوزّع الأماكن الأربعة على يومين، مع مراعاة قرب الوجهات ومواعيد زيارتها.',
          textAlign: TextAlign.center, style: TextStyle(fontSize: 16, height: 1.8, color: brown)),
    ]),
  );

  Widget _daySelector() => Row(children: List.generate(2, (i) {
    final active = selectedDay == i;
    return Expanded(child: Padding(
      padding: EdgeInsets.only(left: i == 0 ? 8 : 0),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => setState(() => selectedDay = i),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(color: active ? green : Colors.white, borderRadius: BorderRadius.circular(16)),
          alignment: Alignment.center,
          child: Text(i == 0 ? 'اليوم الأول' : 'اليوم الثاني',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: active ? Colors.white : brown)),
        ),
      ),
    ));
  }));

  Widget _stopCard(_Stop stop, int index) => Padding(
    padding: const EdgeInsets.only(bottom: 13),
    child: Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.85), borderRadius: BorderRadius.circular(21)),
      child: Row(children: [
        Container(
          height: 37, width: 37,
          alignment: Alignment.center,
          decoration: const BoxDecoration(color: green, shape: BoxShape.circle),
          child: Text('${index + 1}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17)),
        ),
        const SizedBox(width: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Image.asset(stop.image, width: 87, height: 91, fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              width: 87, height: 91, color: cream,
              child: Icon(stop.icon, size: 38, color: brown),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(stop.time, style: const TextStyle(fontSize: 13, color: brown, fontWeight: FontWeight.w600)),
          const SizedBox(height: 5),
          Text(stop.name, style: const TextStyle(fontSize: 17, color: green, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          Text(stop.subtitle, style: const TextStyle(fontSize: 12, color: brown)),
        ])),
      ]),
    ),
  );

  Widget _freeTimeCard() => Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const InstantExploreScreen())),
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(color: const Color(0xFFE4EDDF), borderRadius: BorderRadius.circular(18)),
        child: const Row(children: [
          Icon(Icons.bolt_rounded, color: green, size: 30),
          SizedBox(width: 10),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('وقت فراغ: 9:30 – 11:00 ص', style: TextStyle(fontWeight: FontWeight.bold, color: green, fontSize: 15)),
            SizedBox(height: 4),
            Text('استكشف مكانًا قبل متحف دار المدينة', style: TextStyle(color: brown, fontSize: 12)),
          ])),
          Icon(Icons.arrow_back_ios_new_rounded, color: green, size: 18),
        ]),
      ),
    ),
  );

  Widget _note() => const Padding(
    padding: EdgeInsets.all(8),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Icon(Icons.info_outline_rounded, size: 19, color: brown),
      SizedBox(width: 8),
      Expanded(child: Text('الأوقات مقترحة للعرض، ويُراعى التحقق من مواعيد الأماكن قبل الزيارة.',
          style: TextStyle(color: brown, fontSize: 13, height: 1.6))),
    ]),
  );

  Widget _bottomButton() => Padding(
    padding: const EdgeInsets.fromLTRB(17, 8, 17, 16),
    child: SizedBox(
      width: double.infinity, height: 60,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: green, foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        ),
        icon: Icon(planReady ? Icons.bookmark_added_outlined : Icons.auto_awesome_rounded, size: 24),
        label: Text(planReady ? (saved ? 'تم حفظ رحلتي' : 'حفظ رحلتي') : 'رتّب رحلتي',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        onPressed: () {
          if (!planReady) {
            setState(() { planReady = true; selectedDay = 0; });
          } else {
            RihalTripStore.save();
            setState(() => saved = true);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const MyTripsScreen()),
            );
          }
        },
      ),
    ),
  );

  Widget _bottomNavigation() => Container(
    padding: const EdgeInsets.fromLTRB(8, 10, 8, 10),
    decoration: const BoxDecoration(
      color: Color(0xFFF9F1E5),
      borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      boxShadow: [BoxShadow(color: Color(0x18000000), blurRadius: 12)],
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _navItem(Icons.calendar_month_rounded, 'رحلاتي', false, () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const MyTripsScreen()));
        }),
        _navItem(Icons.home_rounded, 'الرئيسية', true, () {
          Navigator.of(context).popUntil((route) => route.isFirst);
        }),
        _navItem(Icons.explore_outlined, 'استكشاف لحظي', false, () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('الاستكشاف اللحظي قريبًا')),
          );
        }),
      ],
    ),
  );

  Widget _navItem(IconData icon, String label, bool selected, VoidCallback onTap) =>
      InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: selected ? green : brown, size: 26),
              const SizedBox(height: 4),
              Text(label, style: TextStyle(
                color: selected ? green : brown,
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                fontSize: 12,
              )),
            ],
          ),
        ),
      );

}

class _Stop {
  final String name;
  final String time;
  final String subtitle;
  final String image;
  final IconData icon;
  const _Stop(this.name, this.time, this.subtitle, this.image, this.icon);
}


