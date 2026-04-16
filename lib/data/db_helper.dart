import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/surah_model.dart';

class DbHelper {
  static Database? _db;

  static Future<Database> get db async {
    _db ??= await _initDb();
    return _db!;
  }

  static Future<Database> _initDb() async {
    final path = join(await getDatabasesPath(), 'quran.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE ayahs (
            surah_number INTEGER,
            ayah_number INTEGER,
            text TEXT,
            PRIMARY KEY (surah_number, ayah_number)
          )
        ''');
      },
    );
  }

  static Future<List<Ayah>?> getSurahAyahs(int surahNumber) async {
    final database = await db;
    final results = await database.query(
      'ayahs',
      where: 'surah_number = ?',
      whereArgs: [surahNumber],
      orderBy: 'ayah_number ASC',
    );
    if (results.isEmpty) return null;
    return results.map((r) => Ayah(
      numberInSurah: r['ayah_number'] as int,
      text: r['text'] as String,
    )).toList();
  }

  static Future<void> saveSurahAyahs(int surahNumber, List<Ayah> ayahs) async {
    final database = await db;
    final batch = database.batch();
    for (final ayah in ayahs) {
      batch.insert(
        'ayahs',
        {
          'surah_number': surahNumber,
          'ayah_number': ayah.numberInSurah,
          'text': ayah.text,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  static Future<bool> isSurahCached(int surahNumber) async {
    final database = await db;
    final result = await database.query(
      'ayahs',
      where: 'surah_number = ?',
      whereArgs: [surahNumber],
      limit: 1,
    );
    return result.isNotEmpty;
  }
}
