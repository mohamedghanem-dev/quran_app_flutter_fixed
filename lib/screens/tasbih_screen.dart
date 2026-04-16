import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/app_colors.dart';

const _presets = [
  {'name': 'سبحان الله',          'target': 33},
  {'name': 'الحمد لله',           'target': 33},
  {'name': 'الله أكبر',           'target': 34},
  {'name': 'لا إله إلا الله',    'target': 100},
  {'name': 'الاستغفار',           'target': 100},
  {'name': 'الصلاة على النبي ﷺ', 'target': 100},
];

class TasbihScreen extends StatefulWidget {
  const TasbihScreen({super.key});
  @override
  State<TasbihScreen> createState() => _TasbihScreenState();
}

class _TasbihScreenState extends State<TasbihScreen> with SingleTickerProviderStateMixin {
  int _count = 0;
  int _rounds = 0;
  int _total = 0;
  int _savedTotal = 0;
  int _selectedPreset = 0;
  int get _target => _presets[_selectedPreset]['target'] as int;
  String get _name => _presets[_selectedPreset]['name'] as String;

  late AnimationController _pulseCtrl;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 1.0, end: 1.04).animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));
    _loadSaved();
  }

  Future<void> _loadSaved() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => _savedTotal = prefs.getInt('tasbih_total') ?? 0);
  }

  Future<void> _saveTasbih(int add) async {
    final prefs = await SharedPreferences.getInstance();
    final newTotal = _savedTotal + add;
    await prefs.setInt('tasbih_total', newTotal);
    setState(() => _savedTotal = newTotal);
  }

  void _tap() {
    HapticFeedback.lightImpact();
    _count++;
    _total++;
    if (_count >= _target) {
      _rounds++;
      _count = 0;
      HapticFeedback.mediumImpact();
      _saveTasbih(_target);
      _showRoundSnack();
      _pulseCtrl.reset();
      _pulseCtrl.repeat(reverse: true);
    }
    setState(() {});
  }

  void _showRoundSnack() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('أحسنت! جولة $_rounds ✓', style: const TextStyle(fontFamily: 'Tajawal', fontSize: 14)),
        duration: const Duration(seconds: 1),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _reset() {
    HapticFeedback.selectionClick();
    setState(() { _count = 0; _rounds = 0; _total = 0; });
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progress = _target > 0 ? _count / _target : 0.0;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  Text(_name, textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.txt, fontFamily: 'Tajawal')),
                  const SizedBox(height: 24),

                  // Main circle button
                  ScaleTransition(
                    scale: _count == 0 ? _pulseAnim : const AlwaysStoppedAnimation(1.0),
                    child: GestureDetector(
                      onTap: _tap,
                      child: Container(
                        width: 200, height: 200,
                        decoration: BoxDecoration(
                          gradient: AppColors.gradient,
                          shape: BoxShape.circle,
                          boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.35), blurRadius: 28, spreadRadius: 4, offset: const Offset(0,8))],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(_toArabicNum(_count),
                              style: const TextStyle(color: Colors.white, fontSize: 64, fontWeight: FontWeight.w900, fontFamily: 'Tajawal')),
                            Text('اضغط للتسبيح',
                              style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12, fontFamily: 'Tajawal')),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Progress bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: AppColors.primary.withOpacity(0.12),
                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.gold),
                      minHeight: 6,
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Stats row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _stat('الجولات', _toArabicNum(_rounds)),
                      Container(width: 1, height: 30, color: AppColors.primary.withOpacity(0.2), margin: const EdgeInsets.symmetric(horizontal: 20)),
                      _stat('المجموع', _toArabicNum(_total)),
                      Container(width: 1, height: 30, color: AppColors.primary.withOpacity(0.2), margin: const EdgeInsets.symmetric(horizontal: 20)),
                      _stat('الهدف', _toArabicNum(_target)),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Saved total
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.06), blurRadius: 8, offset: const Offset(0,2))],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_toArabicNum(_savedTotal),
                          style: const TextStyle(color: AppColors.primary, fontSize: 16, fontWeight: FontWeight.w800, fontFamily: 'Tajawal')),
                        const Text('إجمالي محفوظ',
                          style: TextStyle(color: AppColors.muted, fontSize: 12, fontFamily: 'Tajawal')),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Controls
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: _reset,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 13),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(11),
                            ),
                            child: const Center(child: Text('إعادة تعيين',
                              style: TextStyle(color: AppColors.primary, fontSize: 13, fontWeight: FontWeight.w700, fontFamily: 'Tajawal'))),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            HapticFeedback.selectionClick();
                            setState(() {
                              _selectedPreset = (_selectedPreset + 1) % _presets.length;
                              _count = 0;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 13),
                            decoration: BoxDecoration(gradient: AppColors.gradient, borderRadius: BorderRadius.circular(11)),
                            child: const Center(child: Text('التالي ◄',
                              style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700, fontFamily: 'Tajawal'))),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Preset grid
                  const Align(
                    alignment: Alignment.centerRight,
                    child: Text('اختر الذكر', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.txt, fontFamily: 'Tajawal')),
                  ),
                  const SizedBox(height: 10),
                  GridView.count(
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 2.2,
                    children: List.generate(_presets.length, (i) {
                      final selected = i == _selectedPreset;
                      return GestureDetector(
                        onTap: () {
                          HapticFeedback.selectionClick();
                          setState(() { _selectedPreset = i; _count = 0; });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            gradient: selected ? AppColors.gradient : null,
                            color: selected ? null : AppColors.card,
                            borderRadius: BorderRadius.circular(9),
                            border: Border.all(
                              color: selected ? Colors.transparent : AppColors.primary.withOpacity(0.2),
                              width: 1.5,
                            ),
                          ),
                          child: Center(
                            child: Text(_presets[i]['name'] as String,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: selected ? Colors.white : AppColors.primary,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Tajawal',
                              )),
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
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
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
          child: Row(
            children: [
              const Icon(Icons.radio_button_checked_rounded, color: AppColors.gold, size: 22),
              const SizedBox(width: 10),
              const Text('السبحة الإلكترونية',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800, fontFamily: 'Tajawal')),
            ],
          ),
        ),
      ),
    );
  }

  Widget _stat(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(color: AppColors.primary, fontSize: 18, fontWeight: FontWeight.w800, fontFamily: 'Tajawal')),
        Text(label, style: const TextStyle(color: AppColors.muted, fontSize: 11, fontFamily: 'Tajawal')),
      ],
    );
  }

  String _toArabicNum(int n) {
    const digits = ['٠','١','٢','٣','٤','٥','٦','٧','٨','٩'];
    return n.toString().split('').map((d) => int.tryParse(d) != null ? digits[int.parse(d)] : d).join();
  }
}
