class Surah {
  final int number;
  final String nameAr;
  final String nameEn;
  final int ayahCount;
  final String type;

  const Surah({
    required this.number,
    required this.nameAr,
    required this.nameEn,
    required this.ayahCount,
    required this.type,
  });
}

class Ayah {
  final int numberInSurah;
  final String text;

  const Ayah({required this.numberInSurah, required this.text});

  factory Ayah.fromJson(Map<String, dynamic> json) {
    return Ayah(
      numberInSurah: json['numberInSurah'] as int,
      text: json['text'] as String,
    );
  }
}
