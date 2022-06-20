import 'package:flutter/cupertino.dart';
import 'package:kana_kit/kana_kit.dart';

import '../models/kanji.dart';

class Review with ChangeNotifier {
  late Kanji currKanji;
  int correctResponses = 0;
  late String responseMeaning;
  late String responseReading;

  final kanaKit = const KanaKit();

  void increaseCorrectResponses() {
    correctResponses++;
    notifyListeners();
  }

  void setKanji(Kanji currKanji) {
    this.currKanji = currKanji;
  }

  void setResponses(String responseMeaning, String responseReading) {
    this.responseMeaning = responseMeaning;
    this.responseReading = responseReading;
  }

  bool get isMeaningCorrect {
    if (currKanji.meaning == responseMeaning.toLowerCase() ||
        currKanji.synonyms.contains(responseMeaning.toLowerCase())) {
      return true;
    } else {
      return false;
    }
  }

  bool get isReadingCorrect {
    if (currKanji.reading == responseReading ||
        currKanji.onyomi.contains(responseReading) ||
        currKanji.kunyomi.contains(responseReading)) {
      return true;
    } else {
      return false;
    }
  }

  String toHiragana(String text) {
    return kanaKit.toHiragana(text);
  }

  String toRomaji(String text) {
    return kanaKit.toRomaji(text);
  }

  bool isHiragana(String text) {
    return kanaKit.isHiragana(text);
  }
}
