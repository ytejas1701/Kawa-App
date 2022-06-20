class Kanji {
  final String id;
  final String kanji;
  final String meaning;
  final String reading;
  final List<String> synonyms;
  final List<String> onyomi;
  final List<String> kunyomi;

  Kanji(
      {required this.id,
      required this.kanji,
      required this.meaning,
      required this.reading,
      required this.synonyms,
      required this.kunyomi,
      required this.onyomi});
}
