import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/surah_model.dart';
import 'db_helper.dart';

class QuranService {
  static const _api = 'https://api.alquran.cloud/v1';

  static Future<List<Ayah>> getSurahAyahs(int surahNumber) async {
    // Try cache first
    final cached = await DbHelper.getSurahAyahs(surahNumber);
    if (cached != null && cached.isNotEmpty) return cached;

    // Fetch from API
    final response = await http
        .get(Uri.parse('$_api/surah/$surahNumber/quran-uthmani'))
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception('فشل تحميل السورة');
    }

    final data = jsonDecode(response.body);
    final ayahsJson = data['data']['ayahs'] as List;
    final ayahs = ayahsJson.map((a) => Ayah.fromJson(a)).toList();

    // Cache it
    await DbHelper.saveSurahAyahs(surahNumber, ayahs);
    return ayahs;
  }

  static Future<bool> isCached(int surahNumber) =>
      DbHelper.isSurahCached(surahNumber);
}
