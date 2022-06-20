import 'package:flutter/material.dart';

import '../models/kanji.dart';

class LessonCard extends StatelessWidget {
  final Kanji _currKanji;
  final Function _nextCard;
  LessonCard(this._currKanji, this._nextCard);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
            child: Text(
          _currKanji.kanji,
          style: const TextStyle(fontSize: 150),
        )),
        const SizedBox(height: 20),
        Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _currKanji.meaning,
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: 50,
                    color: Theme.of(context).colorScheme.secondary),
              ),
              Text(
                "SYNONYMS: ${(_currKanji.synonyms).join(', ')}",
                maxLines: 1,
                style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onSurface),
              ),
            ]),
        const SizedBox(height: 10),
        Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _currKanji.reading,
                textAlign: TextAlign.left,
                style: const TextStyle(
                  fontSize: 50,
                ),
              ),
              Text(
                "ON'YOMI: ${(_currKanji.onyomi..removeWhere((item) => item == 'None')).join(', ')}",
                maxLines: 1,
                style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onSurface),
              ),
              Text(
                "KUN'YOMI: ${(_currKanji.kunyomi..removeWhere((item) => item == 'None')).join(', ')}",
                maxLines: 1,
                style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onSurface),
              ),
            ]),
        const Spacer(),
        Container(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              mini: true,
              backgroundColor:
                  Theme.of(context).colorScheme.secondary.withOpacity(0.9),
              onPressed: () {
                _nextCard();
              },
            )),
        const SizedBox(
          height: 20,
        )
      ],
    );
  }
}
