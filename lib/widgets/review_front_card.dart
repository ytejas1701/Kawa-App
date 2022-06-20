import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/kanji.dart';
import '../models/review.dart';

class ReviewFrontCard extends StatelessWidget {
  late final Kanji currKanji;
  final Function _flipCard;
  ReviewFrontCard(this._flipCard);

  static final GlobalKey<FormState> _formKey = GlobalKey();

  var readingController = TextEditingController();
  String responseMeaning = '';
  String responseReading = '';

  void _submitForm() {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      _formKey.currentState!.save();
      _flipCard();
    }
  }

  @override
  Widget build(BuildContext context) {
    final reviewData = Provider.of<Review>(context, listen: false);
    currKanji = reviewData.currKanji;
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
          Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    style: const TextStyle(fontSize: 20),
                    cursorColor: Colors.white,
                    decoration: const InputDecoration(
                        label: Text('meaning'),
                        labelStyle: TextStyle(fontSize: 20),
                        floatingLabelStyle: TextStyle(color: Colors.white),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        isDense: true,
                        border: OutlineInputBorder()),
                    validator: (value) {
                      // if (value!.isEmpty) {
                      //   return 'please enter your answer';
                      // }
                      return null;
                    },
                    onSaved: (value) {
                      responseMeaning = value as String;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: readingController,
                    style: const TextStyle(fontSize: 20),
                    cursorColor: Colors.white,
                    decoration: const InputDecoration(
                        labelStyle: TextStyle(fontSize: 20),
                        label: Text('reading'),
                        floatingLabelStyle: TextStyle(color: Colors.white),
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        isDense: true,
                        border: OutlineInputBorder()),
                    validator: (value) {
                      // if (value!.isEmpty || !reviewData.isHiragana(value)) {
                      //   return 'please enter your answer';
                      // }
                      return null;
                    },
                    onChanged: (value) {
                      String convertedText =
                          reviewData.toHiragana(reviewData.toRomaji(value));
                      readingController.value = TextEditingValue(
                          text: convertedText,
                          selection: TextSelection.fromPosition(
                              TextPosition(offset: convertedText.length)));
                    },
                    onSaved: (value) {
                      responseReading = value as String;
                      readingController.clear();
                    },
                  )
                ],
              )),
          const SizedBox(height: 10),
          Container(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                mini: true,
                backgroundColor:
                    Theme.of(context).colorScheme.primary.withOpacity(0.9),
                onPressed: () {
                  _submitForm();
                  reviewData.setResponses(responseMeaning, responseReading);
                },
              )),
          const SizedBox(height: 10),
        ]));
  }
}
