import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math' as math;
import '../widgets/app_colors.dart';

const List<Map<String, dynamic>> _presets = [
  {'name': 'سبحان الله',          'target': 33},
  {'name': 'الحمد لله',           'target': 33},
  {'name': 'الله أكبر',           'target': 34},
  {'name': 'لا إله إلا الله',    'target': 100},
  {'name': 'الاستغفار',           'target': 100},
  {'name': 'الصلاة على النبي ﷺ', 'target': 100},
  {'name': 'لا حول ولا قوة',     'target': 33},
  {'name': 'سبحان الله العظيم',   'target': 100},
];

class TasbihScreen extends StatefulWidget {
  const TasbihScreen({super.key});
  @override
  State<TasbihScreen> createState() => _TasbihScreenState();
}

class _TasbihScreenState extends State<TasbihScreen>
    with SingleTickerProviderStateMixin {
  int _count = 0;
  int _rounds = 0;
  int _total = 0;
  int _savedTotal = 0;
  int _selectedPreset = 0; // -1 = مخصص
  String _customName = '';
  int _customTarget = 33;
  bool _isCustom = false;

  late AnimationController _rippleCtrl;
  late Animation<double> _rippleAnim;

  int get _target => _isCustom ? _customTarget : _presets[_selectedPreset]['target'] as int;
  String get _name => _isCustom ? _customName : _presets[_selectedPreset]['name'] as String;

  @override
  void initState() {
    super.initState();
    _rippleCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _rippleAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _rippleCtrl, curve: Curves.easeOut),
    );
    _loadSaved();
  }

  Future<void> _loadSaved() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => _savedTotal = prefs.getInt('tasbih_total') ?? 0);
  }

  Future<void> _saveTotal(int add) async {
    final prefs = await SharedPreferences.getInstance();
    final newTotal = _savedTotal + add;
    await prefs.setInt('tasbih_total', newTotal);
    setState(() => _savedTotal = newTotal);
  }

  void _tap() {
    HapticFeedback.lightImpact();
    _rippleCtrl.forward(from: 0);
    setState(() {
      _count++;
      _total++;
      if (_count >= _target) {
        _rounds++;
        _count = 0;
        HapticFeedback.heavyImpact();
        _saveTotal(_target);
        _showRoundDialog();
      }
    });
  }

  void _showRoundDialog() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text('أحسنت! اكتملت الجولة $_rounds 🎉',
              style: const TextStyle(fontFamily: 'Tajawal', fontSize: 14)),
          ],
        ),
        duration: const Duration(seconds: 2),
        backgroundColor: const Color(0xFF2E7D32),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(12),
      ),
    );
  }

  void _reset() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('إعادة تعيين', style: TextStyle(fontFamily: 'Tajawal', fontWeight: FontWeight.w700)),
        content: const Text('هل تريد إعادة تعيين العداد؟', style: TextStyle(fontFamily: 'Tajawal')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء', style: TextStyle(fontFamily: 'Tajawal', color: AppColors.muted)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: () {
              Navigator.pop(context);
              HapticFeedback.selectionClick();
              setState(() { _count = 0; _rounds = 0; _total = 0; });
            },
            child: const Text('تأكيد', style: TextStyle(fontFamily: 'Tajawal', color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showAddCustomDialog() {
    final nameCtrl = TextEditingController();
    final targetCtrl = TextEditingController(text: '33');
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('إضافة ذكر خاص', style: TextStyle(fontFamily: 'Tajawal', fontWeight: FontWeight.w700)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              textDirection: TextDirection.rtl,
              decoration: const InputDecoration(
                labelText: 'نص الذكر',
                labelStyle: TextStyle(fontFamily: 'Tajawal'),
                border: OutlineInputBorder(),
              ),
              style: const TextStyle(fontFamily: 'Tajawal'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: targetCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'العدد المطلوب',
                labelStyle: TextStyle(fontFamily: 'Tajawal'),
                border: OutlineInputBorder(),
              ),
              style: const TextStyle(fontFamily: 'Tajawal'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء', style: TextStyle(fontFamily: 'Tajawal', color: AppColors.muted)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: () {
              if (nameCtrl.text.trim().isEmpty) return;
              Navigator.pop(context);
              setState(() {
                _isCustom = true;
                _customName = nameCtrl.text.trim();
                _customTarget = int.tryParse(targetCtrl.text) ?? 33;
                _count = 0;
                _rounds = 0;
                _total = 0;
              });
            },
            child: const Text('حفظ', style: TextStyle(fontFamily: 'Tajawal', color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _rippleCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progress = _target > 0 ? (_count / _target).clamp(0.0, 1.0) : 0.0;
    final size = MediaQuery.of(context).size;
    final circleSize = size.width * 0.52;

    return Scaffold(
      backgroundColor: const Color(0xFF0D2137),
      body: Column(
        children: [
          _buildHeader(),
          // أزرار الأذكار
          _buildPresetChips(),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // اسم الذكر
                Text(_name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Tajawal',
                  )),

                // الدائرة الرئيسية
                GestureDetector(
                  onTap: _tap,
                  child: AnimatedBuilder(
                    animation: _rippleAnim,
                    builder: (_, child) => Stack(
                      alignment: Alignment.center,
                      children: [
                        // ripple
                        if (_rippleCtrl.isAnimating)
                          Container(
                            width: circleSize + _rippleAnim.value * 40,
                            height: circleSize + _rippleAnim.value * 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.gold.withOpacity(1 - _rippleAnim.value),
                                width: 2,
                              ),
                            ),
                          ),
                        child!,
                      ],
                    ),
                    child: CustomPaint(
                      painter: _CircleProgressPainter(progress: progress),
                      child: Container(
                        width: circleSize,
                        height: circleSize,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              const Color(0xFF1E3A5F),
                              const Color(0xFF0D2137),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.gold.withOpacity(0.2),
                              blurRadius: 20,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(_toArabicNum(_count),
                              style: TextStyle(
                                color: AppColors.gold,
                                fontSize: circleSize * 0.28,
                                fontWeight: FontWeight.w900,
                                fontFamily: 'Tajawal',
                              )),
                            Text('/ ${_toArabicNum(_target)}',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.5),
                                fontSize: 14,
                                fontFamily: 'Tajawal',
                              )),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // إحصائيات
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _statBox('الجولات', _toArabicNum(_rounds)),
                    _statBox('المجموع', _toArabicNum(_total)),
                    _statBox('الإجمالي', _toArabicNum(_savedTotal)),
                  ],
                ),

                // أزرار التحكم
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: _actionBtn(
                          'إعادة تعيين',
                          Icons.refresh_rounded,
                          const Color(0xFF8B0000),
                          _reset,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _actionBtn(
                          'ذكر خاص',
                          Icons.add_circle_outline_rounded,
                          AppColors.primary,
                          _showAddCustomDialog,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0D2137), Color(0xFF1B3A5C)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.gold.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.radio_button_checked_rounded, color: AppColors.gold, size: 20),
              ),
              const SizedBox(width: 10),
              const Text('السبحة الإلكترونية',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800, fontFamily: 'Tajawal')),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPresetChips() {
    return Container(
      color: const Color(0xFF0D2137),
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        children: [
          ...List.generate(_presets.length, (i) {
            final selected = !_isCustom && i == _selectedPreset;
            return GestureDetector(
              onTap: () {
                HapticFeedback.selectionClick();
                setState(() {
                  _isCustom = false;
                  _selectedPreset = i;
                  _count = 0;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(left: 8),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                decoration: BoxDecoration(
                  color: selected ? AppColors.gold : Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: selected ? AppColors.gold : Colors.white.withOpacity(0.15),
                    width: 1,
                  ),
                ),
                child: Text(_presets[i]['name'] as String,
                  style: TextStyle(
                    color: selected ? const Color(0xFF0D2137) : Colors.white.withOpacity(0.7),
                    fontSize: 12,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.normal,
                    fontFamily: 'Tajawal',
                  )),
              ),
            );
          }),
          if (_isCustom)
            Container(
              margin: const EdgeInsets.only(left: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.gold,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(_customName,
                style: const TextStyle(
                  color: Color(0xFF0D2137),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Tajawal',
                )),
            ),
        ],
      ),
    );
  }

  Widget _statBox(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Column(
        children: [
          Text(value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w800,
              fontFamily: 'Tajawal',
            )),
          const SizedBox(height: 2),
          Text(label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.45),
              fontSize: 11,
              fontFamily: 'Tajawal',
            )),
        ],
      ),
    );
  }

  Widget _actionBtn(String label, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 6),
            Text(label, style: TextStyle(
              color: color,
              fontSize: 13,
              fontWeight: FontWeight.w700,
              fontFamily: 'Tajawal',
            )),
          ],
        ),
      ),
    );
  }

  String _toArabicNum(int n) {
    const digits = ['٠','١','٢','٣','٤','٥','٦','٧','٨','٩'];
    return n.toString().split('').map((d) => int.tryParse(d) != null ? digits[int.parse(d)] : d).join();
  }
}

class _CircleProgressPainter extends CustomPainter {
  final double progress;
  const _CircleProgressPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 4;

    // خلفية
    canvas.drawCircle(center, radius,
      Paint()
        ..color = Colors.white.withOpacity(0.05)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6);

    // تقدم
    if (progress > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2,
        2 * math.pi * progress,
        false,
        Paint()
          ..color = AppColors.gold
          ..style = PaintingStyle.stroke
          ..strokeWidth = 6
          ..strokeCap = StrokeCap.round,
      );
    }
  }

  @override
  bool shouldRepaint(_CircleProgressPainter old) => old.progress != progress;
}
