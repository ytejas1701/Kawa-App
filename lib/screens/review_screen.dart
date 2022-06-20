import 'package:flutter/material.dart';
import 'package:kawa_app/widgets/review_summary_card.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

import '../models/review.dart';
import '../models/customer.dart';
import '../models/kanji.dart';

import '../widgets/review_back_card.dart';
import '../widgets/review_front_card.dart';

class ReviewScreen extends StatefulWidget {
  final List<Map<String, dynamic>> reviewKanjisData;
  ReviewScreen(this.reviewKanjisData);

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

enum CardSide { front, back }

class _ReviewScreenState extends State<ReviewScreen> {
  int _currIndex = 0;
  bool _sessionDone = false;
  bool _isListBuilt = false;
  List<Kanji> kanjiList = [];
  List<Kanji> originalKanjiList = [];
  List<Kanji> wrongList = [];
  Map<String, int> attemptsData = {};
  bool _isLoading = true;
  CardSide cardSide = CardSide.front;

  void _nextCard(BuildContext context) {
    var reviewData = Provider.of<Review>(context, listen: false);
    String kanjiId = kanjiList[_currIndex].id;
    bool isMeaningCorrect = reviewData.isMeaningCorrect;
    bool isReadingCorrect = reviewData.isReadingCorrect;
    if (isMeaningCorrect && isReadingCorrect) {
      Provider.of<Customer>(context, listen: false).updateReviewKanji(
        kanjiId,
        (attemptsData[kanjiId]) ?? 0,
        widget.reviewKanjisData[_currIndex]['stage'],
      );
      reviewData.increaseCorrectResponses();
    } else {
      wrongList.add(kanjiList[_currIndex]);
      attemptsData[kanjiId] =
          attemptsData.containsKey(kanjiId) ? attemptsData[kanjiId]! + 1 : 1;
    }
    int maxLength =
        _isListBuilt ? kanjiList.length : widget.reviewKanjisData.length;
    setState(() {
      if (reviewData.correctResponses == widget.reviewKanjisData.length) {
        _sessionDone = true;
      }
      if (!_sessionDone) {
        _currIndex++;
        if (_currIndex == maxLength) {
          _currIndex = 0;
          kanjiList = wrongList;
          wrongList = [];
        }
        _isLoading = kanjiList.length > _currIndex ? false : true;
      }
      cardSide = CardSide.front;
    });
  }

  void _flipCard() {
    setState(() {
      cardSide = CardSide.back;
    });
  }

  void buildKanjiList() async {
    for (var element in widget.reviewKanjisData) {
      Kanji newKanji = await Provider.of<Customer>(context, listen: false)
          .fetchKanji(element['level'], element['id']);
      kanjiList.add(newKanji);
      if (_isLoading) {
        setState(() {
          _isLoading = false;
        });
      }
    }
    originalKanjiList = kanjiList;
    _isListBuilt = true;
  }

  Widget buildCard(BuildContext context) {
    Provider.of<Review>(context, listen: false).setKanji(kanjiList[_currIndex]);
    if (cardSide == CardSide.front) {
      return ReviewFrontCard(_flipCard);
    } else {
      return ReviewBackCard(_nextCard);
    }
  }

  @override
  void initState() {
    super.initState();
    if (mounted) buildKanjiList();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return ChangeNotifierProvider(
      create: (context) => Review(),
      builder: (context, child) {
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
                  percent: Provider.of<Review>(context).correctResponses /
                      widget.reviewKanjisData.length,
                  backgroundColor: Colors.transparent,
                  progressColor: Theme.of(context).colorScheme.primary,
                ),
              )
            ],
          ),
          body: Container(
              alignment: Alignment.center,
              child: _sessionDone
                  ? ReviewSummaryCard(originalKanjiList, attemptsData)
                  : Container(
                      constraints: const BoxConstraints(maxHeight: 396),
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      width: deviceSize.width,
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(20)),
                      child: !_isLoading
                          ? buildCard(context)
                          : const Center(child: LinearProgressIndicator()),
                    )),
        );
      },
    );
  }
}
