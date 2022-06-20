import 'package:flutter/material.dart';
import 'package:kawa_app/models/kanji.dart';
import 'package:kawa_app/models/review.dart';
import 'package:provider/provider.dart';

class ReviewBackCard extends StatelessWidget {
  late final Kanji currKanji;
  late final String _responseMeaning;
  late final String _responseReading;
  final Function _nextCard;
  ReviewBackCard(this._nextCard);

  @override
  Widget build(BuildContext context) {
    final reviewData = Provider.of<Review>(context, listen: false);
    currKanji = reviewData.currKanji;
    _responseMeaning = reviewData.responseMeaning;
    _responseReading = reviewData.responseReading;
    return SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          Center(
              child: Text(
            currKanji.kanji,
            style: const TextStyle(fontSize: 150),
          )),
          const SizedBox(height: 10),
          Column(children: [
            reviewData.isMeaningCorrect
                ? Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 12),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                            color: Theme.of(context).colorScheme.primary)),
                    alignment: Alignment.centerLeft,
                    child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          _responseMeaning,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 20),
                        )))
                : Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 12),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                            color: Theme.of(context).colorScheme.onError)),
                    alignment: Alignment.centerLeft,
                    child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(children: [
                          Text(
                            '$_responseMeaning ',
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.onError,
                                fontSize: 20),
                          ),
                          Text(
                            '--> ${currKanji.meaning}',
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: 20),
                          )
                        ]))),
            const SizedBox(height: 10),
            reviewData.isReadingCorrect
                ? Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 12),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                            color: Theme.of(context).colorScheme.primary)),
                    alignment: Alignment.centerLeft,
                    child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          _responseReading,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 20),
                        )))
                : Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 12),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                            color: Theme.of(context).colorScheme.onError)),
                    alignment: Alignment.centerLeft,
                    child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(children: [
                          Text(
                            '$_responseReading ',
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.onError,
                                fontSize: 20),
                          ),
                          Text(
                            '--> ${currKanji.reading}',
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: 20),
                          )
                        ]))),
          ]),
          const SizedBox(height: 10),
          Container(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                mini: true,
                backgroundColor:
                    Theme.of(context).colorScheme.primary.withOpacity(0.9),
                onPressed: () {
                  _nextCard(context);
                },
              )),
          const SizedBox(height: 10),
        ]));
  }
}
