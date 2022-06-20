import 'package:flutter/material.dart';
import 'package:kawa_app/models/kanji.dart';

class ReviewSummaryCard extends StatelessWidget {
  List<Kanji> kanjiList;
  Map<String, int> attemptsData;

  ReviewSummaryCard(this.kanjiList, this.attemptsData);
  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    return Container(
      height: deviceSize.height,
      margin: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('良くできました!',
              style: TextStyle(
                  fontSize: 30,
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.bold)),
          const SizedBox(
            height: 20,
          ),
          Flexible(
            child: ListView.builder(
              itemBuilder: (context, index) {
                Kanji currKanji = kanjiList[index];
                return Container(
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(10)),
                  child: ListTile(
                    leading: Text(
                      currKanji.kanji,
                      style: TextStyle(
                          fontSize: 30,
                          color: attemptsData.containsKey(currKanji.id)
                              ? Theme.of(context).colorScheme.onSurface
                              : Theme.of(context).colorScheme.primary),
                    ),
                    title: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [Text(currKanji.meaning)]),
                    subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [Text(currKanji.reading)]),
                  ),
                );
              },
              itemCount: kanjiList.length,
            ),
          )
        ],
      ),
    );
  }
}
