import 'package:flutter/material.dart';
import '../widgets/app_colors.dart';
import '../data/quran_data.dart';
import '../data/quran_service.dart';
import 'surah_reader_screen.dart';

class QuranListScreen extends StatefulWidget {
  const QuranListScreen({super.key});
  @override
  State<QuranListScreen> createState() => _QuranListScreenState();
}

class _QuranListScreenState extends State<QuranListScreen> {
  String _search = '';
  final _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  List get _filtered => kSurahs.where((s) =>
    s.nameAr.contains(_search) ||
    s.nameEn.toLowerCase().contains(_search.toLowerCase()) ||
    s.number.toString().contains(_search)
  ).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(child: _buildList()),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(gradient: AppColors.gradient),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset('assets/images/app_icon.jpg', width: 30, height: 30, fit: BoxFit.cover),
                  ),
                  const SizedBox(width: 10),
                  const Text('القرآن الكريم',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800, fontFamily: 'Tajawal')),
                  const Spacer(),
                  Text('١١٤ سورة',
                    style: TextStyle(color: Colors.white.withOpacity(0.65), fontSize: 12, fontFamily: 'Tajawal')),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: _ctrl,
                  textDirection: TextDirection.rtl,
                  style: const TextStyle(color: Colors.white, fontFamily: 'Tajawal', fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'ابحث عن سورة...',
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.55), fontFamily: 'Tajawal'),
                    prefixIcon: Icon(Icons.search, color: Colors.white.withOpacity(0.7), size: 20),
                    suffixIcon: _search.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.close, color: Colors.white.withOpacity(0.7), size: 18),
                          onPressed: () { _ctrl.clear(); setState(() => _search = ''); })
                      : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 13),
                  ),
                  onChanged: (v) => setState(() => _search = v),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList() {
    final list = _filtered;
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      itemCount: list.length,
      itemBuilder: (ctx, i) => _SurahCard(surah: list[i]),
    );
  }
}

class _SurahCard extends StatefulWidget {
  final dynamic surah;
  const _SurahCard({required this.surah});
  @override
  State<_SurahCard> createState() => _SurahCardState();
}

class _SurahCardState extends State<_SurahCard> {
  bool _cached = false;

  @override
  void initState() {
    super.initState();
    QuranService.isCached(widget.surah.number).then((v) {
      if (mounted) setState(() => _cached = v);
    });
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.surah;
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(
        builder: (_) => SurahReaderScreen(surah: s),
      )).then((_) => QuranService.isCached(s.number).then((v) {
        if (mounted) setState(() => _cached = v);
      })),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.07), blurRadius: 8, offset: const Offset(0,2))],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              // Surah number badge
              Container(
                width: 42, height: 42,
                decoration: const BoxDecoration(gradient: AppColors.gradient, shape: BoxShape.circle),
                child: Center(
                  child: Text(_toArabicNum(s.number),
                    style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'Tajawal')),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(s.nameAr,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.txt, fontFamily: 'Tajawal')),
                    const SizedBox(height: 2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('${s.type} • ${_toArabicNum(s.ayahCount)} آية',
                          style: const TextStyle(fontSize: 11, color: AppColors.muted, fontFamily: 'Tajawal')),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              if (_cached)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.green.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text('محفوظ', style: TextStyle(color: AppColors.green, fontSize: 9, fontFamily: 'Tajawal')),
                )
              else
                Icon(Icons.cloud_download_outlined, color: AppColors.muted.withOpacity(0.4), size: 16),
            ],
          ),
        ),
      ),
    );
  }

  String _toArabicNum(int n) {
    const digits = ['٠','١','٢','٣','٤','٥','٦','٧','٨','٩'];
    return n.toString().split('').map((d) => int.tryParse(d) != null ? digits[int.parse(d)] : d).join();
  }
}
