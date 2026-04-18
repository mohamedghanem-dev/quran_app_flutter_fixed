import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/app_colors.dart';
import '../models/surah_model.dart';
import '../data/quran_service.dart';
import '../data/quran_data.dart';
import '../data/settings_provider.dart';

// علامات نهاية الآيات
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

const int _ayahsPerPage = 15;

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
  // بيانات السورة الحالية
  List<Ayah>? _ayahs;
  // بيانات السورة التالية (للتكملة)
  List<Ayah>? _nextAyahs;
  String? _error;
  bool _loading = true;
  late PageController _pageCtrl;
  int _currentPage = 0;
  bool _showBars = false;
  bool _bookmarked = false;
  late Surah _currentSurah;

  @override
  void initState() {
    super.initState();
    _currentSurah = widget.surah;
    _pageCtrl = PageController();
    _loadAyahs();
    _checkBookmark();
  }

  void _checkBookmark() {
    final s = widget.settings;
    if (s.bookmarkSurah == widget.surah.number) {
      setState(() => _bookmarked = true);
    }
  }

  Future<void> _loadAyahs() async {
    try {
      final ayahs = await QuranService.getSurahAyahs(widget.surah.number);
      if (!mounted) return;

      // حمّل السورة التالية لو موجودة
      List<Ayah>? nextAyahs;
      if (widget.surah.number < 114) {
        try {
          nextAyahs = await QuranService.getSurahAyahs(widget.surah.number + 1);
        } catch (_) {}
      }

      int startPage = 0;
      if (widget.jumpToAyah != null) {
        startPage = ((widget.jumpToAyah! - 1) ~/ _ayahsPerPage);
      } else if (widget.settings.bookmarkSurah == widget.surah.number) {
        startPage = widget.settings.bookmarkPage;
      }

      setState(() {
        _ayahs = ayahs;
        _nextAyahs = nextAyahs;
        _loading = false;
      });

      if (startPage > 0) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _pageCtrl.jumpToPage(startPage);
            setState(() => _currentPage = startPage);
          }
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() { _error = 'تعذّر تحميل السورة\nتأكد من الاتصال بالإنترنت'; _loading = false; });
    }
  }

  // إجمالي الصفحات (السورة الحالية + التالية)
  int get _totalPages {
    if (_ayahs == null) return 1;
    final currentPages = ((_ayahs!.length - 1) ~/ _ayahsPerPage) + 1;
    if (_nextAyahs == null) return currentPages;
    final nextPages = ((_nextAyahs!.length - 1) ~/ _ayahsPerPage) + 1;
    return currentPages + nextPages;
  }

  int get _currentSurahPages {
    if (_ayahs == null) return 1;
    return ((_ayahs!.length - 1) ~/ _ayahsPerPage) + 1;
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  void _saveBookmark() {
    widget.settings.setBookmark(_currentSurah.number, _currentPage);
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
    final bgColor = dark ? const Color(0xFF1A1A2E) : const Color(0xFFFDF8F0);

    return Scaffold(
      backgroundColor: bgColor,
      body: GestureDetector(
        onTap: () => setState(() => _showBars = !_showBars),
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(height: MediaQuery.of(context).padding.top + (_showBars ? 68 : 8)),
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
                  Expanded(child: _buildReader(bgColor, dark)),
                if (!_loading && _error == null) _buildFooter(dark),
              ],
            ),

            // شريط علوي
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
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.menu, color: Colors.white, size: 16),
                                  SizedBox(width: 4),
                                  Text('الفهرس', style: TextStyle(color: Colors.white, fontSize: 12, fontFamily: 'Tajawal')),
                                ],
                              ),
                            ),
                          ),
                          const Spacer(),
                          Text(_currentSurah.nameAr,
                            style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800, fontFamily: 'Tajawal')),
                          const Spacer(),
                          GestureDetector(
                            onTap: _saveBookmark,
                            child: Icon(
                              _bookmarked ? Icons.bookmark : Icons.bookmark_border,
                              color: _bookmarked ? AppColors.gold : Colors.white, size: 22),
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

  Widget _buildReader(Color bgColor, bool dark) {
    return PageView.builder(
      controller: _pageCtrl,
      reverse: true,
      onPageChanged: (p) {
        HapticFeedback.selectionClick();
        setState(() => _currentPage = p);
        widget.settings.saveLastPosition(_currentSurah.number, p);
      },
      itemCount: _totalPages,
      itemBuilder: (ctx, pageIndex) {
        // هل الصفحة من السورة الحالية أم التالية؟
        if (pageIndex < _currentSurahPages) {
          final start = pageIndex * _ayahsPerPage;
          final end = (start + _ayahsPerPage).clamp(0, _ayahs!.length);
          return _buildPage(_ayahs!.sublist(start, end), pageIndex, _currentSurah, bgColor, dark);
        } else {
          // صفحات السورة التالية
          final nextPageIndex = pageIndex - _currentSurahPages;
          final start = nextPageIndex * _ayahsPerPage;
          final end = (start + _ayahsPerPage).clamp(0, _nextAyahs!.length);
          final nextSurah = _currentSurah.number < kSurahs.length ? kSurahs[_currentSurah.number] : _currentSurah;
          return _buildPage(_nextAyahs!.sublist(start, end), nextPageIndex, nextSurah, bgColor, dark);
        }
      },
    );
  }

  Widget _buildPage(List<Ayah> ayahs, int pageIndex, Surah surah, Color bgColor, bool dark) {
    final textColor = dark ? const Color(0xFFEDE4D0) : const Color(0xFF1C1C1C);
    final borderColor = dark ? Colors.white.withOpacity(0.08) : const Color(0xFFD4C5A9);
    final hasBismillah = surah.number != 1 && surah.number != 9 && pageIndex == 0;
    final fontSize = widget.settings.fontSize;

    return GestureDetector(
      onTap: () => setState(() => _showBars = !_showBars),
      child: Container(
        color: bgColor,
        child: Column(
          children: [
            // إطار المصحف
            Expanded(
              child: Container(
                margin: const EdgeInsets.fromLTRB(8, 4, 8, 2),
                decoration: BoxDecoration(
                  color: dark ? const Color(0xFF1E1E2E) : const Color(0xFFFFFDF7),
                  border: Border.all(color: borderColor, width: 1),
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 8, offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // رأس السورة
                    if (pageIndex == 0) _buildSurahHeader(surah, borderColor),

                    // بسملة
                    if (hasBismillah) _buildBismillah(fontSize, borderColor),

                    // نص القرآن
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                        child: RichText(
                          textAlign: TextAlign.justify,
                          textDirection: TextDirection.rtl,
                          text: TextSpan(
                            children: ayahs.map((a) => [
                              TextSpan(
                                text: a.text,
                                style: TextStyle(
                                  fontFamily: 'Hafs',
                                  fontSize: fontSize,
                                  color: textColor,
                                  height: 2.0,
                                ),
                              ),
                              WidgetSpan(
                                child: Container(
                                  // no margin
                                  child: Text(
                                    ' \u06DD${_toArabicNum(a.numberInSurah)} ',
                                    style: TextStyle(
                                      fontFamily: 'Tajawal',
                                      fontSize: fontSize * 0.7,
                                      color: dark
                                        ? AppColors.gold.withOpacity(0.8)
                                        : const Color(0xFF8B4513),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ]).expand((x) => x).toList(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSurahHeader(Surah surah, Color borderColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        gradient: AppColors.gradient,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(3),
          topRight: Radius.circular(3),
        ),
      ),
      child: Column(
        children: [
          Text(surah.nameAr,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w800,
              fontFamily: 'Tajawal',
            )),
          const SizedBox(height: 2),
          Text('${surah.type}  •  ${_toArabicNum(surah.ayahCount)} آية',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 11,
              fontFamily: 'Tajawal',
            )),
        ],
      ),
    );
  }

  Widget _buildBismillah(double fontSize, Color borderColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: borderColor, width: 1)),
      ),
      child: Text(
        'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'Hafs',
          fontSize: fontSize + 1,
          color: AppColors.primary,
          height: 1.8,
        ),
      ),
    );
  }

  Widget _buildFooter(bool dark) {
    final footerBg = dark ? const Color(0xFF16213E) : const Color(0xFFF5EDD8);
    final textColor = dark ? Colors.white : AppColors.primary;

    return Container(
      color: footerBg,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: _currentPage < _totalPages - 1
              ? () => _pageCtrl.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut)
              : null,
            child: Icon(Icons.arrow_back_ios_rounded,
              color: _currentPage < _totalPages - 1 ? AppColors.primary : AppColors.muted.withOpacity(0.3),
              size: 18),
          ),
          Text(
            '${_toArabicNum(_currentPage + 1)} / ${_toArabicNum(_totalPages)}',
            style: TextStyle(
              color: textColor,
              fontSize: 13,
              fontWeight: FontWeight.w700,
              fontFamily: 'Tajawal',
            ),
          ),
          GestureDetector(
            onTap: _currentPage > 0
              ? () => _pageCtrl.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut)
              : null,
            child: Icon(Icons.arrow_forward_ios_rounded,
              color: _currentPage > 0 ? AppColors.primary : AppColors.muted.withOpacity(0.3),
              size: 18),
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
