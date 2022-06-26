class Vocab {
  final String id;
  final String vocab;
  final String meaning;
  final String reading;
  final List<String> synonyms;
  final List<String> subKanjis;

  Vocab(
      {required this.id,
      required this.vocab,
      required this.meaning,
      required this.reading,
      required this.synonyms,
      required this.subKanjis});
}
