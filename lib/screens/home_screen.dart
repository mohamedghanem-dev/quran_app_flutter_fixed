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
  bool _showSplash = true;
  final _settings = SettingsProvider();

  @override
  void initState() {
    super.initState();
    _settings.load().then((_) => setState(() {}));
    _splashController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    Future.delayed(const Duration(milliseconds: 2600), () {
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
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1A2A4A), Color(0xFF243B6E), Color(0xFF1A2A4A)],
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(child: CustomPaint(painter: _StarsPainter())),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 110, height: 110,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(colors: [
                        AppColors.gold.withOpacity(0.25),
                        Colors.transparent,
                      ]),
                      border: Border.all(color: AppColors.gold, width: 2),
                    ),
                    child: Center(
                      child: Container(
                        width: 80, height: 80,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF2A3F6E),
                        ),
                        child: Center(
                          child: Text('☽',
                            style: TextStyle(fontSize: 38, color: AppColors.gold)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  const Text('القرآن الكريم',
                    style: TextStyle(
                      color: Colors.white, fontSize: 34,
                      fontWeight: FontWeight.w900, fontFamily: 'Tajawal')),
                  const SizedBox(height: 10),
                  Text('مصحف  •  أذكار  •  دعاء  •  تسبيح',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.65),
                      fontSize: 14, fontFamily: 'Tajawal')),
                  const SizedBox(height: 28),
                  const Text('﴿وَيُسَارِعُونَ فِي الْخَيْرَاتِ﴾',
                    style: TextStyle(
                      color: AppColors.gold, fontSize: 16, fontFamily: 'Hafs')),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(3, (i) => AnimatedContainer(
                      duration: Duration(milliseconds: 400 + i * 200),
                      width: i == 1 ? 22 : 8, height: 4,
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      decoration: BoxDecoration(
                        color: i == 1
                          ? AppColors.gold
                          : Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(4),
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
    final paint = Paint()..color = Colors.white.withOpacity(0.5);
    final stars = [
      [0.1,0.08],[0.9,0.12],[0.3,0.04],[0.7,0.07],[0.5,0.15],
      [0.15,0.25],[0.85,0.2],[0.05,0.45],[0.95,0.4],[0.4,0.02],
      [0.6,0.17],[0.2,0.2],[0.8,0.32],[0.45,0.27],[0.75,0.05],
      [0.55,0.35],[0.25,0.38],[0.65,0.42],[0.35,0.48],[0.88,0.5],
    ];
    for (final s in stars) {
      canvas.drawCircle(Offset(size.width*s[0], size.height*s[1]), 1.5, paint);
    }
  }
  @override
  bool shouldRepaint(_) => false;
}
