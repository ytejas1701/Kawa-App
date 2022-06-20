import 'package:flutter/material.dart';
import 'package:kawa_app/models/kanji.dart';

class LessonSummaryCard extends StatelessWidget {
  final List<Kanji> kanjiList;
  LessonSummaryCard(this.kanjiList);
  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    return Container(
      height: deviceSize.height,
      margin: const EdgeInsets.all(8),
      child: Column(
        children: [
          Text('良くできました!',
              style: TextStyle(
                  fontSize: 30,
                  color: Theme.of(context).colorScheme.onBackground,
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
                          color: Theme.of(context).colorScheme.secondary),
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
