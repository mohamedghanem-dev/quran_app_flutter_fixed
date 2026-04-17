import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/app_colors.dart';
import '../models/surah_model.dart';
import '../data/quran_service.dart';
import '../data/settings_provider.dart';
import 'quran_list_screen.dart';

const List<String> _endMarks = [
  '','۝١','۝٢','۝٣','۝٤','۝٥','۝٦','۝٧','۝٨','۝٩','۝١٠',
  '۝١١','۝١٢','۝١٣','۝١٤','۝١٥','۝١٦','۝١٧','۝١٨','۝١٩','۝٢٠',
  '۝٢١','۝٢٢','۝٢٣','۝٢٤','۝٢٥','۝٢٦','۝٢٧','۝٢٨','۝٢٩','۝٣٠',
  '۝٣١','۝٣٢','۝٣٣','۝٣٤','۝٣٥','۝٣٦','۝٣٧','۝٣٨','۝٣٩','۝٤٠',
  '۝٤١','۝٤٢','۝٤٣','۝٤٤','۝٤٥','۝٤٦','۝٤٧','۝٤٨','۝٤٩','۝٥٠',
  '۝٥١','۝٥٢','۝٥٣','۝٥٤','۝٥٥','۝٥٦','۝٥٧','۝٥٨','۝٥٩','۝٦٠',
  '۝٦١','۝٦٢','۝٦٣','۝٦٤','۝٦٥','۝٦٦','۝٦٧','۝٦٨','۝٦٩','۝٧٠',
  '۝٧١','۝٧٢','۝٧٣','۝٧٤','۝٧٥','۝٧٦','۝٧٧','۝٧٨','۝٧٩','۝٨٠',
  '۝٨١','۝٨٢','۝٨٣','۝٨٤','۝٨٥','۝٨٦','۝٨٧','۝٨٨','۝٨٩','۝٩٠',
  '۝٩١','۝٩٢','۝٩٣','۝٩٤','۝٩٥','۝٩٦','۝٩٧','۝٩٨','۝٩٩','۝١٠٠',
  '۝١٠١','۝١٠٢','۝١٠٣','۝١٠٤','۝١٠٥','۝١٠٦','۝١٠٧','۝١٠٨','۝١٠٩','۝١١٠',
  '۝١١١','۝١١٢','۝١١٣','۝١١٤','۝١١٥','۝١١٦','۝١١٧','۝١١٨','۝١١٩','۝١٢٠',
  '۝١٢١','۝١٢٢','۝١٢٣','۝١٢٤','۝١٢٥','۝١٢٦','۝١٢٧','۝١٢٨','۝١٢٩','۝١٣٠',
  '۝١٣١','۝١٣٢','۝١٣٣','۝١٣٤','۝١٣٥','۝١٣٦','۝١٣٧','۝١٣٨','۝١٣٩','۝١٤٠',
  '۝١٤١','۝١٤٢','۝١٤٣','۝١٤٤','۝١٤٥','۝١٤٦','۝١٤٧','۝١٤٨','۝١٤٩','۝١٥٠',
  '۝١٥١','۝١٥٢','۝١٥٣','۝١٥٤','۝١٥٥','۝١٥٦','۝١٥٧','۝١٥٨','۝١٥٩','۝١٦٠',
  '۝١٦١','۝١٦٢','۝١٦٣','۝١٦٤','۝١٦٥','۝١٦٦','۝١٦٧','۝١٦٨','۝١٦٩','۝١٧٠',
  '۝١٧١','۝١٧٢','۝١٧٣','۝١٧٤','۝١٧٥','۝١٧٦','۝١٧٧','۝١٧٨','۝١٧٩','۝١٨٠',
  '۝١٨١','۝١٨٢','۝١٨٣','۝١٨٤','۝١٨٥','۝١٨٦','۝١٨٧','۝١٨٨','۝١٨٩','۝١٩٠',
  '۝١٩١','۝١٩٢','۝١٩٣','۝١٩٤','۝١٩٥','۝١٩٦','۝١٩٧','۝١٩٨','۝١٩٩','۝٢٠٠',
  '۝٢٠١','۝٢٠٢','۝٢٠٣','۝٢٠٤','۝٢٠٥','۝٢٠٦','۝٢٠٧','۝٢٠٨','۝٢٠٩','۝٢١٠',
  '۝٢١١','۝٢١٢','۝٢١٣','۝٢١٤','۝٢١٥','۝٢١٦','۝٢١٧','۝٢١٨','۝٢١٩','۝٢٢٠',
  '۝٢٢١','۝٢٢٢','۝٢٢٣','۝٢٢٤','۝٢٢٥','۝٢٢٦','۝٢٢٧','۝٢٢٨','۝٢٢٩','۝٢٣٠',
  '۝٢٣١','۝٢٣٢','۝٢٣٣','۝٢٣٤','۝٢٣٥','۝٢٣٦','۝٢٣٧','۝٢٣٨','۝٢٣٩','۝٢٤٠',
  '۝٢٤١','۝٢٤٢','۝٢٤٣','۝٢٤٤','۝٢٤٥','۝٢٤٦','۝٢٤٧','۝٢٤٨','۝٢٤٩','۝٢٥٠',
  '۝٢٥١','۝٢٥٢','۝٢٥٣','۝٢٥٤','۝٢٥٥','۝٢٥٦','۝٢٥٧','۝٢٥٨','۝٢٥٩','۝٢٦٠',
  '۝٢٦١','۝٢٦٢','۝٢٦٣','۝٢٦٤','۝٢٦٥','۝٢٦٦','۝٢٦٧','۝٢٦٨','۝٢٦٩','۝٢٧٠',
  '۝٢٧١','۝٢٧٢','۝٢٧٣','۝٢٧٤','۝٢٧٥','۝٢٧٦','۝٢٧٧','۝٢٧٨','۝٢٧٩','۝٢٨٠',
  '۝٢٨١','۝٢٨٢','۝٢٨٣','۝٢٨٤','۝٢٨٥','۝٢٨٦',
];

String _getEndMark(int n) => n < _endMarks.length ? _endMarks[n] : '۝$n';

const int _ayahsPerPage = 10;

class SurahReaderScreen extends StatefulWidget {
  final Surah surah;
  final int? jumpToAyah;
  final SettingsProvider settings;
  const SurahReaderScreen({
    super.key,
    required this.surah,
    required this.settings,
    this.jumpToAyah,
  });

  @override
  State<SurahReaderScreen> createState() => _SurahReaderScreenState();
}

class _SurahReaderScreenState extends State<SurahReaderScreen> {
  List<Ayah>? _ayahs;
  String? _error;
  bool _loading = true;
  late PageController _pageCtrl;
  int _currentPage = 0;
  bool _showBars = false; // شريط يظهر عند الضغط
  bool _bookmarked = false;

  @override
  void initState() {
    super.initState();
    _pageCtrl = PageController();
    _loadAyahs();
    _checkBookmark();
  }

  void _checkBookmark() {
    final s = widget.settings;
    if (s.bookmarkSurah == widget.surah.number) {
      setState(() {
        _bookmarked = true;
        _currentPage = s.bookmarkPage;
      });
    }
  }

  Future<void> _loadAyahs() async {
    try {
      final ayahs = await QuranService.getSurahAyahs(widget.surah.number);
      if (!mounted) return;
      int startPage = 0;
      if (widget.jumpToAyah != null) {
        startPage = ((widget.jumpToAyah! - 1) ~/ _ayahsPerPage);
      } else if (widget.settings.bookmarkSurah == widget.surah.number) {
        startPage = widget.settings.bookmarkPage;
      }
      setState(() { _ayahs = ayahs; _loading = false; });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && startPage > 0) {
          _pageCtrl.jumpToPage(startPage);
          setState(() => _currentPage = startPage);
        }
      });
    } catch (e) {
      if (!mounted) return;
      setState(() { _error = 'تعذّر تحميل السورة\nتأكد من الاتصال بالإنترنت'; _loading = false; });
    }
  }

  int get _totalPages {
    if (_ayahs == null) return 1;
    return ((_ayahs!.length - 1) ~/ _ayahsPerPage) + 1;
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  void _toggleBars() {
    setState(() => _showBars = !_showBars);
  }

  void _saveBookmark() {
    widget.settings.setBookmark(widget.surah.number, _currentPage);
    setState(() => _bookmarked = true);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم حفظ علامة القراءة ✓', style: TextStyle(fontFamily: 'Tajawal')),
        duration: Duration(seconds: 2),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dark = widget.settings.darkMode;
    final bgColor = dark ? const Color(0xFF1A1A2E) : const Color(0xFFFAF7F0);

    return Scaffold(
      backgroundColor: bgColor,
      body: GestureDetector(
        onTap: _toggleBars,
        child: Stack(
          children: [
            // محتوى القرآن
            Column(
              children: [
                // مساحة بدل الهيدر
                SizedBox(height: MediaQuery.of(context).padding.top + (_showBars ? 70 : 0)),
                if (_loading)
                  const Expanded(child: Center(child: CircularProgressIndicator(color: AppColors.primary)))
                else if (_error != null)
                  Expanded(child: Center(child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.wifi_off_rounded, color: AppColors.muted, size: 48),
                      const SizedBox(height: 12),
                      Text(_error!, textAlign: TextAlign.center,
                        style: const TextStyle(color: AppColors.muted, fontFamily: 'Tajawal', fontSize: 15)),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () { setState(() { _loading = true; _error = null; }); _loadAyahs(); },
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                        child: const Text('إعادة المحاولة', style: TextStyle(color: Colors.white, fontFamily: 'Tajawal')),
                      ),
                    ],
                  )))
                else
                  Expanded(child: _buildReader(bgColor)),
                // Footer ثابت دائماً
                if (!_loading && _error == null) _buildFooter(dark),
              ],
            ),

            // شريط علوي يظهر عند الضغط
            if (_showBars)
              Positioned(
                top: 0, left: 0, right: 0,
                child: Container(
                  decoration: const BoxDecoration(gradient: AppColors.gradient),
                  child: SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 6, 16, 10),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
                            onPressed: () => Navigator.pop(context),
                          ),
                          // زر الفهرس
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Icon(Icons.menu, color: Colors.white, size: 16),
                                  SizedBox(width: 4),
                                  Text('الفهرس', style: TextStyle(color: Colors.white, fontSize: 12, fontFamily: 'Tajawal')),
                                ],
                              ),
                            ),
                          ),
                          const Spacer(),
                          // اسم السورة في المنتصف
                          Text(widget.surah.nameAr,
                            style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800, fontFamily: 'Tajawal')),
                          const Spacer(),
                          // علامة القراءة
                          GestureDetector(
                            onTap: _saveBookmark,
                            child: Icon(
                              _bookmarked ? Icons.bookmark : Icons.bookmark_border,
                              color: _bookmarked ? AppColors.gold : Colors.white,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 8),
                          // الإعدادات
                          GestureDetector(
                            onTap: () {},
                            child: const Icon(Icons.settings_rounded, color: Colors.white, size: 20),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildReader(Color bgColor) {
    return PageView.builder(
      controller: _pageCtrl,
      reverse: true, // تمرير من اليمين لليسار (عربي)
      onPageChanged: (p) {
        HapticFeedback.selectionClick();
        setState(() => _currentPage = p);
        widget.settings.saveLastPosition(widget.surah.number, p);
      },
      itemCount: _totalPages,
      itemBuilder: (ctx, pageIndex) {
        final start = pageIndex * _ayahsPerPage;
        final end = (start + _ayahsPerPage).clamp(0, _ayahs!.length);
        final pageAyahs = _ayahs!.sublist(start, end);
        return _buildPage(pageAyahs, pageIndex, bgColor);
      },
    );
  }

  Widget _buildPage(List<Ayah> ayahs, int pageIndex, Color bgColor) {
    final dark = widget.settings.darkMode;
    final textColor = dark ? const Color(0xFFE8E0D0) : const Color(0xFF1A2A3A);
    final hasBismillah = widget.surah.number != 1 && widget.surah.number != 9 && pageIndex == 0;
    final fontSize = widget.settings.fontSize;

    return GestureDetector(
      onTap: _toggleBars,
      child: Container(
        color: bgColor,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: Column(
            children: [
              // رأس السورة (صفحة أولى فقط)
              if (pageIndex == 0) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    gradient: AppColors.gradient,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.2), blurRadius: 12, offset: const Offset(0,4))],
                  ),
                  child: Column(
                    children: [
                      Text(widget.surah.nameAr,
                        style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w800, fontFamily: 'Tajawal')),
                      Text(widget.surah.nameEn,
                        style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 13, fontFamily: 'Tajawal')),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],

              // بسملة
              if (hasBismillah) ...[
                Text('بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Hafs', fontSize: fontSize + 2,
                    color: AppColors.primary, height: 2.2,
                  )),
                Container(height: 1, color: AppColors.primary.withOpacity(0.1),
                  margin: const EdgeInsets.symmetric(vertical: 12)),
              ],

              // نص القرآن
              RichText(
                textAlign: TextAlign.justify,
                textDirection: TextDirection.rtl,
                text: TextSpan(
                  children: ayahs.map((a) => [
                    TextSpan(
                      text: a.text,
                      style: TextStyle(
                        fontFamily: 'Hafs', fontSize: fontSize,
                        color: textColor, height: 2.4,
                      ),
                    ),
                    TextSpan(
                      text: ' ${_getEndMark(a.numberInSurah)} ',
                      style: TextStyle(
                        fontFamily: 'Tajawal', fontSize: fontSize * 0.8,
                        color: AppColors.gold, fontWeight: FontWeight.bold,
                      ),
                    ),
                  ]).expand((x) => x).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooter(bool dark) {
    final footerBg = dark ? const Color(0xFF16213E) : AppColors.card;
    return Container(
      color: footerBg,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // السهم الأيسر = الصفحة التالية (reverse=true)
          GestureDetector(
            onTap: _currentPage < _totalPages - 1
              ? () => _pageCtrl.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut)
              : null,
            child: Icon(Icons.arrow_back_ios_rounded,
              color: _currentPage < _totalPages - 1 ? AppColors.primary : AppColors.muted.withOpacity(0.3),
              size: 20),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('${_toArabicNum(_currentPage + 1)} / ${_toArabicNum(_totalPages)}',
                style: const TextStyle(color: AppColors.primary, fontSize: 13, fontWeight: FontWeight.w700, fontFamily: 'Tajawal')),
              const Text('صفحة', style: TextStyle(color: AppColors.muted, fontSize: 10, fontFamily: 'Tajawal')),
            ],
          ),
          // السهم الأيمن = الصفحة السابقة (reverse=true)
          GestureDetector(
            onTap: _currentPage > 0
              ? () => _pageCtrl.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut)
              : null,
            child: Icon(Icons.arrow_forward_ios_rounded,
              color: _currentPage > 0 ? AppColors.primary : AppColors.muted.withOpacity(0.3),
              size: 20),
          ),
        ],
      ),
    );
  }

  String _toArabicNum(int n) {
    const digits = ['٠','١','٢','٣','٤','٥','٦','٧','٨','٩'];
    return n.toString().split('').map((d) => int.tryParse(d) != null ? digits[int.parse(d)] : d).join();
  }
}
