import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/app_colors.dart';
import '../data/adhkar_data.dart';

class AdhkarScreen extends StatefulWidget {
  const AdhkarScreen({super.key});
  @override
  State<AdhkarScreen> createState() => _AdhkarScreenState();
}

class _AdhkarScreenState extends State<AdhkarScreen> {
  AdhkarCategory? _selected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: _selected == null
              ? _buildCategories()
              : _buildZikrList(_selected!),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(gradient: AppColors.gradient),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 16, 14),
          child: Row(
            children: [
              if (_selected != null)
                GestureDetector(
                  onTap: () => setState(() => _selected = null),
                  child: Container(
                    width: 34, height: 34,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 16),
                  ),
                ),
              if (_selected != null) const SizedBox(width: 10),
              Expanded(
                child: Text(
                  _selected?.title ?? 'الأذكار والأدعية',
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800, fontFamily: 'Tajawal'),
                ),
              ),
              if (_selected != null)
                _progressWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _progressWidget() {
    // Will be built dynamically in _ZikrListState
    return const SizedBox.shrink();
  }

  Widget _buildCategories() {
    final icons = {
      'sabah': Icons.wb_sunny_rounded,
      'masaa': Icons.nights_stay_rounded,
      'nawm': Icons.bedtime_rounded,
      'istiqaz': Icons.alarm_rounded,
      'salah': Icons.mosque_rounded,
      'adiya': Icons.favorite_rounded,
      'marad': Icons.medical_services_rounded,
      'safar': Icons.flight_takeoff_rounded,
    };

    return ListView(
      padding: const EdgeInsets.all(14),
      children: [
        // Daily dua card
        Container(
          padding: const EdgeInsets.all(18),
          margin: const EdgeInsets.only(bottom: 14),
          decoration: BoxDecoration(
            gradient: AppColors.gradient,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.2), blurRadius: 14, offset: const Offset(0,4))],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('دعاء اليوم', style: TextStyle(color: AppColors.gold, fontSize: 13, fontWeight: FontWeight.w700, fontFamily: 'Tajawal')),
              const SizedBox(height: 8),
              Text(_dailyDua(), textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 14, fontFamily: 'Tajawal', height: 1.9)),
            ],
          ),
        ),

        const Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Text('الأذكار اليومية', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.txt, fontFamily: 'Tajawal')),
        ),

        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1.4,
          children: kAdhkarCategories.map((cat) {
            final icon = icons[cat.id] ?? Icons.star_rounded;
            return GestureDetector(
              onTap: () => setState(() => _selected = cat),
              child: Container(
                decoration: BoxDecoration(
                  gradient: AppColors.gradient,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.15), blurRadius: 8, offset: const Offset(0,3))],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon, color: Colors.white, size: 28),
                    const SizedBox(height: 8),
                    Text(cat.title, textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700, fontFamily: 'Tajawal')),
                    const SizedBox(height: 2),
                    Text('${cat.items.length} أذكار',
                      style: TextStyle(color: Colors.white.withOpacity(0.55), fontSize: 10, fontFamily: 'Tajawal')),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildZikrList(AdhkarCategory cat) {
    return _ZikrListView(category: cat);
  }

  String _dailyDua() {
    final duas = [
      'اللَّهُمَّ إِنِّي أَسْأَلُكَ الْعَفْوَ وَالْعَافِيَةَ فِي الدُّنْيَا وَالآخِرَةِ',
      'اللَّهُمَّ رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الآخِرَةِ حَسَنَةً',
      'يَا حَيُّ يَا قَيُّومُ بِرَحْمَتِكَ أَسْتَغِيثُ أَصْلِحْ لِي شَأْنِي كُلَّهُ',
      'اللَّهُمَّ اغْفِرْ لِي وَارْحَمْنِي وَعَافِنِي وَارْزُقْنِي',
      'اللَّهُمَّ إِنَّكَ عَفُوٌّ تُحِبُّ الْعَفْوَ فَاعْفُ عَنِّي',
      'اللَّهُمَّ إِنِّي أَسْأَلُكَ الْهُدَى وَالتُّقَى وَالْعَفَافَ وَالْغِنَى',
      'يَا مُقَلِّبَ الْقُلُوبِ ثَبِّتْ قَلْبِي عَلَى دِينِكَ',
    ];
    return duas[DateTime.now().weekday % duas.length];
  }
}

class _ZikrListView extends StatefulWidget {
  final AdhkarCategory category;
  const _ZikrListView({required this.category});
  @override
  State<_ZikrListView> createState() => _ZikrListViewState();
}

class _ZikrListViewState extends State<_ZikrListView> {
  late List<int> _counters;

  @override
  void initState() {
    super.initState();
    _counters = widget.category.items.map((z) => z.count).toList();
  }

  int get _done => _counters.where((c) => c == 0).length;
  double get _progress => widget.category.items.isEmpty ? 0 : _done / widget.category.items.length;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Progress bar
        Container(
          height: 4,
          color: AppColors.bg,
          child: FractionallySizedBox(
            alignment: Alignment.centerRight,
            widthFactor: _progress,
            child: Container(color: AppColors.gold),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: widget.category.items.length,
            itemBuilder: (ctx, i) => _ZikrCard(
              zikr: widget.category.items[i],
              remaining: _counters[i],
              index: i,
              total: widget.category.items.length,
              onDecrement: () => setState(() {
                if (_counters[i] > 0) {
                  _counters[i]--;
                  HapticFeedback.lightImpact();
                }
              }),
            ),
          ),
        ),
      ],
    );
  }
}

class _ZikrCard extends StatelessWidget {
  final ZikrItem zikr;
  final int remaining;
  final int index;
  final int total;
  final VoidCallback onDecrement;

  const _ZikrCard({
    required this.zikr,
    required this.remaining,
    required this.index,
    required this.total,
    required this.onDecrement,
  });

  bool get _done => remaining == 0;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: _done ? const Color(0xFFF0FBF0) : AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: _done ? const Color(0xFF4CAF50).withOpacity(0.3) : AppColors.primary.withOpacity(0.07),
          width: 1.5,
        ),
        boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.06), blurRadius: 8, offset: const Offset(0,2))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(zikr.source,
                  style: const TextStyle(color: AppColors.green, fontSize: 11, fontWeight: FontWeight.w600, fontFamily: 'Tajawal')),
                if (_done)
                  const Icon(Icons.check_circle_rounded, color: Color(0xFF4CAF50), size: 18)
                else
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text('${index + 1}/$total',
                      style: const TextStyle(color: AppColors.primary, fontSize: 10, fontFamily: 'Tajawal')),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            // Text
            Text(zikr.text,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 16,
                height: 2.1,
                color: _done ? const Color(0xFF2E7D32) : AppColors.txt,
                fontFamily: 'Tajawal',
                fontWeight: FontWeight.w500,
              )),
            // Fadl
            if (zikr.fadl != null) ...[
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFBEA),
                  border: Border.all(color: AppColors.gold.withOpacity(0.35)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(zikr.fadl!,
                  textAlign: TextAlign.right,
                  style: const TextStyle(fontSize: 11, color: Color(0xFF7B5E00), fontFamily: 'Tajawal', height: 1.7)),
              ),
            ],
            const SizedBox(height: 10),
            // Footer
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: zikr.text));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('تم النسخ ✓', style: TextStyle(fontFamily: 'Tajawal')),
                        duration: Duration(seconds: 1), backgroundColor: AppColors.primary),
                    );
                  },
                  child: const Icon(Icons.copy_rounded, color: AppColors.primary, size: 18),
                ),
                if (_done)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                    decoration: BoxDecoration(color: const Color(0xFF4CAF50), borderRadius: BorderRadius.circular(18)),
                    child: const Text('تم ✓', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700, fontFamily: 'Tajawal')),
                  )
                else
                  GestureDetector(
                    onTap: onDecrement,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                      decoration: BoxDecoration(gradient: AppColors.gradient, borderRadius: BorderRadius.circular(18)),
                      child: Text(
                        zikr.count > 1 ? '$remaining / ${zikr.count}' : 'تم',
                        style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700, fontFamily: 'Tajawal'),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
