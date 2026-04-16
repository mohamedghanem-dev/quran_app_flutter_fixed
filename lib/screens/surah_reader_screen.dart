import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/app_colors.dart';
import '../models/surah_model.dart';
import '../data/quran_service.dart';

// Ayah end marks ۝ with Arabic numbers
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
  const SurahReaderScreen({super.key, required this.surah, this.jumpToAyah});

  @override
  State<SurahReaderScreen> createState() => _SurahReaderScreenState();
}

class _SurahReaderScreenState extends State<SurahReaderScreen> {
  List<Ayah>? _ayahs;
  String? _error;
  bool _loading = true;
  late PageController _pageCtrl;
  int _currentPage = 0;
  double _fontSize = 22;

  @override
  void initState() {
    super.initState();
    _loadAyahs();
  }

  Future<void> _loadAyahs() async {
    try {
      final ayahs = await QuranService.getSurahAyahs(widget.surah.number);
      if (!mounted) return;
      setState(() { _ayahs = ayahs; _loading = false; });

      // Calculate which page to open if jumpToAyah
      int startPage = 0;
      if (widget.jumpToAyah != null) {
        startPage = ((widget.jumpToAyah! - 1) ~/ _ayahsPerPage);
      }
      _pageCtrl = PageController(initialPage: startPage);
      setState(() => _currentPage = startPage);
    } catch (e) {
      if (!mounted) return;
      setState(() { _error = 'تعذّر تحميل السورة\nتأكد من الاتصال بالإنترنت'; _loading = false; });
      _pageCtrl = PageController();
    }
  }

  int get _totalPages {
    if (_ayahs == null) return 1;
    return ((_ayahs!.length - 1) ~/ _ayahsPerPage) + 1;
  }

  @override
  void dispose() {
    if (!_loading) _pageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF7F0),
      body: Column(
        children: [
          _buildHeader(),
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
            Expanded(child: _buildReader()),
          if (!_loading && _error == null) _buildFooter(),
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
          padding: const EdgeInsets.fromLTRB(8, 8, 16, 12),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
                onPressed: () => Navigator.pop(context),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(widget.surah.nameAr,
                      style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800, fontFamily: 'Tajawal')),
                    Text('${widget.surah.type} • ${_toArabicNum(widget.surah.ayahCount)} آية',
                      style: TextStyle(color: Colors.white.withOpacity(0.65), fontSize: 11, fontFamily: 'Tajawal')),
                  ],
                ),
              ),
              // Font size controls
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _iconBtn(Icons.text_decrease, () => setState(() => _fontSize = (_fontSize - 2).clamp(16, 36))),
                  _iconBtn(Icons.text_increase, () => setState(() => _fontSize = (_fontSize + 2).clamp(16, 36))),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _iconBtn(IconData icon, VoidCallback onTap) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: 34, height: 34,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Icon(icon, color: Colors.white, size: 16),
    ),
  );

  Widget _buildReader() {
    return PageView.builder(
      controller: _pageCtrl,
      onPageChanged: (p) {
        HapticFeedback.selectionClick();
        setState(() => _currentPage = p);
      },
      itemCount: _totalPages,
      itemBuilder: (ctx, pageIndex) {
        final start = pageIndex * _ayahsPerPage;
        final end = (start + _ayahsPerPage).clamp(0, _ayahs!.length);
        final pageAyahs = _ayahs!.sublist(start, end);
        return _buildPage(pageAyahs, pageIndex);
      },
    );
  }

  Widget _buildPage(List<Ayah> ayahs, int pageIndex) {
    final hasBismillah = widget.surah.number != 1 && widget.surah.number != 9 && pageIndex == 0;

    return Container(
      color: const Color(0xFFFAF7F0),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
        child: Column(
          children: [
            // Surah header (first page only)
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

            // Bismillah
            if (hasBismillah) ...[
              Text('بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Hafs',
                  fontSize: _fontSize + 2,
                  color: AppColors.primary,
                  height: 2.2,
                )),
              Container(height: 1, color: AppColors.primary.withOpacity(0.1), margin: const EdgeInsets.symmetric(vertical: 12)),
            ],

            // Quran text as flowing paragraph
            RichText(
              textAlign: TextAlign.justify,
              textDirection: TextDirection.rtl,
              text: TextSpan(
                children: ayahs.map((a) => [
                  TextSpan(
                    text: a.text,
                    style: TextStyle(
                      fontFamily: 'Hafs',
                      fontSize: _fontSize,
                      color: const Color(0xFF1A2A3A),
                      height: 2.4,
                    ),
                  ),
                  TextSpan(
                    text: ' ${_getEndMark(a.numberInSurah)} ',
                    style: TextStyle(
                      fontFamily: 'Tajawal',
                      fontSize: _fontSize * 0.8,
                      color: AppColors.gold,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ]).expand((x) => x).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      color: AppColors.card,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: _currentPage > 0
              ? () => _pageCtrl.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut)
              : null,
            child: Icon(Icons.arrow_forward_ios_rounded,
              color: _currentPage > 0 ? AppColors.primary : AppColors.muted.withOpacity(0.3), size: 20),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('${_toArabicNum(_currentPage + 1)} / ${_toArabicNum(_totalPages)}',
                style: const TextStyle(color: AppColors.primary, fontSize: 13, fontWeight: FontWeight.w700, fontFamily: 'Tajawal')),
              const Text('صفحة', style: TextStyle(color: AppColors.muted, fontSize: 10, fontFamily: 'Tajawal')),
            ],
          ),
          GestureDetector(
            onTap: _currentPage < _totalPages - 1
              ? () => _pageCtrl.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut)
              : null,
            child: Icon(Icons.arrow_back_ios_rounded,
              color: _currentPage < _totalPages - 1 ? AppColors.primary : AppColors.muted.withOpacity(0.3), size: 20),
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
