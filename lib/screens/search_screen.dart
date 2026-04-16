import 'package:flutter/material.dart';
import '../widgets/app_colors.dart';
import '../data/quran_data.dart';
import '../data/adhkar_data.dart';
import '../models/surah_model.dart';
import 'surah_reader_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _ctrl = TextEditingController();
  String _query = '';
  final _focus = FocusNode();

  @override
  void dispose() {
    _ctrl.dispose();
    _focus.dispose();
    super.dispose();
  }

  List<_SearchResult> get _results {
    if (_query.trim().isEmpty) return [];
    final q = _query.trim();
    final results = <_SearchResult>[];

    // Search surahs
    for (final s in kSurahs) {
      if (s.nameAr.contains(q) || s.nameEn.toLowerCase().contains(q.toLowerCase()) || s.number.toString() == q) {
        results.add(_SearchResult(type: _ResultType.surah, surah: s, title: s.nameAr, subtitle: '${s.type} • ${s.ayahCount} آية', tag: 'سورة'));
      }
    }

    // Search adhkar text
    for (final cat in kAdhkarCategories) {
      for (final z in cat.items) {
        if (z.text.contains(q) || (z.fadl ?? '').contains(q) || cat.title.contains(q)) {
          results.add(_SearchResult(
            type: _ResultType.zikr,
            title: z.text.length > 80 ? '${z.text.substring(0, 80)}...' : z.text,
            subtitle: z.source,
            tag: cat.title,
            categoryId: cat.id,
          ));
          if (results.length >= 30) break;
        }
      }
      if (results.length >= 30) break;
    }

    return results;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(child: _buildResults()),
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
                  const Icon(Icons.search_rounded, color: Colors.white, size: 22),
                  const SizedBox(width: 10),
                  const Text('البحث', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800, fontFamily: 'Tajawal')),
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
                  focusNode: _focus,
                  textDirection: TextDirection.rtl,
                  style: const TextStyle(color: Colors.white, fontFamily: 'Tajawal', fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'ابحث في القرآن والأذكار...',
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.55), fontFamily: 'Tajawal'),
                    prefixIcon: Icon(Icons.search, color: Colors.white.withOpacity(0.7), size: 20),
                    suffixIcon: _query.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.close, color: Colors.white.withOpacity(0.7), size: 18),
                          onPressed: () { _ctrl.clear(); setState(() => _query = ''); })
                      : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 13),
                  ),
                  onChanged: (v) => setState(() => _query = v),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResults() {
    if (_query.trim().isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_rounded, color: AppColors.muted.withOpacity(0.4), size: 52),
            const SizedBox(height: 12),
            const Text('اكتب للبحث في القرآن والأذكار',
              style: TextStyle(color: AppColors.muted, fontFamily: 'Tajawal', fontSize: 14)),
          ],
        ),
      );
    }

    final res = _results;
    if (res.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off_rounded, color: AppColors.muted.withOpacity(0.4), size: 52),
            const SizedBox(height: 12),
            const Text('لا توجد نتائج', style: TextStyle(color: AppColors.muted, fontFamily: 'Tajawal', fontSize: 14)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: res.length,
      itemBuilder: (ctx, i) => _ResultCard(result: res[i]),
    );
  }
}

enum _ResultType { surah, zikr }

class _SearchResult {
  final _ResultType type;
  final String title;
  final String subtitle;
  final String tag;
  final Surah? surah;
  final String? categoryId;

  const _SearchResult({
    required this.type,
    required this.title,
    required this.subtitle,
    required this.tag,
    this.surah,
    this.categoryId,
  });
}

class _ResultCard extends StatelessWidget {
  final _SearchResult result;
  const _ResultCard({required this.result});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (result.type == _ResultType.surah && result.surah != null) {
          Navigator.push(context, MaterialPageRoute(
            builder: (_) => SurahReaderScreen(surah: result.surah!),
          ));
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.06), blurRadius: 6, offset: const Offset(0,2))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(result.tag, style: const TextStyle(color: AppColors.primary, fontSize: 10, fontFamily: 'Tajawal')),
            ),
            const SizedBox(height: 6),
            Text(result.title, textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 14, height: 1.8, color: AppColors.txt, fontFamily: 'Tajawal')),
            const SizedBox(height: 4),
            Text(result.subtitle,
              style: const TextStyle(fontSize: 11, color: AppColors.muted, fontFamily: 'Tajawal')),
          ],
        ),
      ),
    );
  }
}
