import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/app_colors.dart';
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

  final List<Widget> _screens = const [
    QuranListScreen(),
    AdhkarScreen(),
    TasbihScreen(),
    SearchScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _splashController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    Future.delayed(const Duration(milliseconds: 2400), () {
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

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: IndexedStack(index: _currentIndex, children: _screens),
          bottomNavigationBar: _buildBottomNav(),
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
        decoration: const BoxDecoration(gradient: AppColors.gradient),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 100, height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 20, offset: const Offset(0,6))],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(22),
                  child: Image.asset('assets/images/app_icon.jpg', fit: BoxFit.cover),
                ),
              ),
              const SizedBox(height: 20),
              const Text('القرآن الكريم',
                style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900, fontFamily: 'Tajawal')),
              const SizedBox(height: 8),
              Text('مصحف إلكتروني • أذكار • سبحة',
                style: TextStyle(color: Colors.white.withOpacity(0.65), fontSize: 14, fontFamily: 'Tajawal')),
              const SizedBox(height: 30),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(3, (i) => _dot(i)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dot(int i) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 600 + i * 200),
      builder: (_, v, __) => AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        width: 8, height: 8,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(v * 0.6),
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    final items = [
      {'icon': Icons.menu_book_rounded, 'label': 'القرآن'},
      {'icon': Icons.mosque_rounded, 'label': 'الأذكار'},
      {'icon': Icons.radio_button_checked_rounded, 'label': 'السبحة'},
      {'icon': Icons.search_rounded, 'label': 'بحث'},
    ];
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.gradient,
        boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 12, offset: const Offset(0,-3))],
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
                          fontFamily: 'Tajawal',
                          fontSize: 10,
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
