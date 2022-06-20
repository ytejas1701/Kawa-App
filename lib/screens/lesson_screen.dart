import 'package:flutter/material.dart';
import 'package:kawa_app/models/customer.dart';
import 'package:kawa_app/models/kanji.dart';
import 'package:kawa_app/widgets/lesson_summary_card.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

import '../widgets/lesson_card.dart';

class LessonScreen extends StatefulWidget {
  final List<Map<String, dynamic>> lessonKanjisData;
  LessonScreen(this.lessonKanjisData);

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  int _currIndex = 0;
  List<Kanji> kanjiList = [];
  bool _isLoading = true;
  bool _sessionDone = false;

  void _nextCard() {
    Provider.of<Customer>(context, listen: false)
        .updateLessonKanji(kanjiList[_currIndex].id);
    setState(() {
      _currIndex++;
      _isLoading = kanjiList.length > _currIndex ? false : true;
      if (_currIndex == widget.lessonKanjisData.length) _sessionDone = true;
    });
  }

  void buildKanjiList() async {
    for (var element in widget.lessonKanjisData) {
      Kanji newKanji = await Provider.of<Customer>(context, listen: false)
          .fetchKanji(element['level'], element['id']);
      kanjiList.add(newKanji);
      if (_isLoading) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();

    if (mounted) {
      buildKanjiList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.background,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: CircularPercentIndicator(
              radius: 20,
              percent: _currIndex / widget.lessonKanjisData.length,
              backgroundColor: Colors.transparent,
              progressColor: Theme.of(context).colorScheme.secondary,
            ),
          )
        ],
      ),
      body: _sessionDone
          ? LessonSummaryCard(kanjiList)
          : Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  height: deviceSize.height * 0.70,
                  width: deviceSize.width,
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(20)),
                  child: _isLoading
                      ? Center(
                          child: LinearProgressIndicator(
                          color: Theme.of(context).colorScheme.secondary,
                        ))
                      : LessonCard(kanjiList[_currIndex], _nextCard))),
    );
  }
}
