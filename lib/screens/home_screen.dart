import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/app_colors.dart';
import '../data/settings_provider.dart';
import 'quran_list_screen.dart';
import 'adhkar_screen.dart';
import 'tasbih_screen.dart';
import 'search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _splashController;
  late AnimationController _pulseController;
  bool _showSplash = true;
  final _settings = SettingsProvider();

  @override
  void initState() {
    super.initState();
    _settings.load().then((_) => setState(() {}));
    _splashController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    Future.delayed(const Duration(milliseconds: 2800), () {
      if (mounted) {
        _splashController.forward().then((_) {
          if (mounted) setState(() => _showSplash = false);
        });
      }
    });
  }

  @override
  void dispose() {
    _splashController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  List<Widget> get _screens => [
    QuranListScreen(settings: _settings),
    const AdhkarScreen(),
    const TasbihScreen(),
    const SearchScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final dark = _settings.darkMode;
    return Stack(
      children: [
        Scaffold(
          backgroundColor: dark ? const Color(0xFF1A1A2E) : AppColors.bg,
          body: IndexedStack(index: _currentIndex, children: _screens),
          bottomNavigationBar: _buildBottomNav(dark),
        ),
        if (_showSplash) _buildSplash(),
      ],
    );
  }

  Widget _buildSplash() {
    return FadeTransition(
      opacity: Tween<double>(begin: 1, end: 0).animate(
        CurvedAnimation(parent: _splashController, curve: Curves.easeOut),
      ),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1B2A4A), Color(0xFF1E3560), Color(0xFF152238)],
          ),
        ),
        child: Stack(
          children: [
            // نجوم خلفية
            Positioned.fill(child: CustomPaint(painter: _StarsPainter())),
            // محتوى
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // أيقونة التطبيق بدون هلال
                  AnimatedBuilder(
                    animation: _pulseController,
                    builder: (_, __) => Container(
                      width: 120, height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.gold.withOpacity(0.5 + _pulseController.value * 0.5),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.gold.withOpacity(0.1 + _pulseController.value * 0.15),
                            blurRadius: 20 + _pulseController.value * 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/app_icon.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  // اسم التطبيق بدون underline
                  const Text(
                    'القرآن الكريم',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 34,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'Tajawal',
                      decoration: TextDecoration.none,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'مصحف  •  أذكار  •  دعاء  •  تسبيح',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 14,
                      fontFamily: 'Tajawal',
                      decoration: TextDecoration.none,
                    ),
                  ),
                  const SizedBox(height: 28),
                  // الآية بدون قوسين مقلوبين
                  Text(
                    'وَيُسَارِعُونَ فِي الْخَيْرَاتِ',
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      color: AppColors.gold.withOpacity(0.9),
                      fontSize: 16,
                      fontFamily: 'Hafs',
                      decoration: TextDecoration.none,
                    ),
                  ),
                  const SizedBox(height: 36),
                  // نقاط تحميل
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(3, (i) => AnimatedBuilder(
                      animation: _pulseController,
                      builder: (_, __) => Container(
                        width: i == 1 ? 24 : 8, height: 4,
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        decoration: BoxDecoration(
                          color: i == 1
                            ? AppColors.gold.withOpacity(0.7 + _pulseController.value * 0.3)
                            : Colors.white.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    )),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav(bool dark) {
    final items = [
      {'icon': Icons.menu_book_rounded, 'label': 'القرآن'},
      {'icon': Icons.mosque_rounded, 'label': 'الأذكار'},
      {'icon': Icons.radio_button_checked_rounded, 'label': 'السبحة'},
      {'icon': Icons.search_rounded, 'label': 'بحث'},
    ];
    return Container(
      decoration: BoxDecoration(
        gradient: dark
          ? const LinearGradient(colors: [Color(0xFF16213E), Color(0xFF0F3460)])
          : AppColors.gradient,
        boxShadow: [BoxShadow(
          color: AppColors.primary.withOpacity(0.3),
          blurRadius: 12, offset: const Offset(0,-3))],
      ),
      child: SafeArea(
        child: Row(
          children: List.generate(items.length, (i) {
            final selected = _currentIndex == i;
            return Expanded(
              child: GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  setState(() => _currentIndex = i);
                },
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(items[i]['icon'] as IconData,
                        color: selected ? AppColors.gold : Colors.white.withOpacity(0.45),
                        size: 22),
                      const SizedBox(height: 3),
                      Text(items[i]['label'] as String,
                        style: TextStyle(
                          fontFamily: 'Tajawal', fontSize: 10,
                          color: selected ? AppColors.gold : Colors.white.withOpacity(0.45),
                          fontWeight: selected ? FontWeight.w700 : FontWeight.normal,
                        )),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _StarsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(0.45);
    final stars = [
      [0.08,0.06],[0.92,0.10],[0.25,0.03],[0.72,0.07],[0.48,0.14],
      [0.14,0.22],[0.87,0.18],[0.04,0.42],[0.96,0.38],[0.38,0.02],
      [0.62,0.16],[0.19,0.19],[0.82,0.30],[0.44,0.25],[0.77,0.04],
      [0.55,0.33],[0.22,0.36],[0.68,0.40],[0.33,0.46],[0.90,0.48],
      [0.12,0.55],[0.58,0.08],[0.42,0.58],[0.78,0.55],[0.02,0.65],
    ];
    for (final s in stars) {
      final r = s[0] < 0.3 || s[0] > 0.7 ? 1.2 : 1.0;
      canvas.drawCircle(Offset(size.width*s[0], size.height*s[1]), r, paint);
    }
  }
  @override
  bool shouldRepaint(_) => false;
}
