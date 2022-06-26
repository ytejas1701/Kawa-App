import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

import 'package:kawa_app/models/kanji.dart';

class Customer with ChangeNotifier {
  String userid = FirebaseAuth.instance.currentUser == null
      ? ''
      : FirebaseAuth.instance.currentUser!.uid;

  Future<int> upgradeLevel() async {
    CollectionReference user = FirebaseFirestore.instance.collection(userid);
    try {
      var stats = await user.doc('statistics').get();
      int newLevel = (stats.get('level') as int) + 1;
      final url = Uri.parse(
          'https://kanji-database-b3cee-default-rtdb.firebaseio.com/kanji-level-${newLevel.toString()}.json');
      final response = await http.get(url);

      var kanjiData = json.decode(response.body) as Map<String, Object>;
      kanjiData.forEach((key, value) async {
        await user.doc(key).set({
          'level': newLevel,
          'stage': 0,
          'ispromoted': false,
          'kanji': (value as Map<String, dynamic>)['kanji']
        });
      });
      user.doc('statistics').update({
        'level': newLevel,
        'promotionsLeft': kanjiData.length,
      });
      notifyListeners();
      return newLevel;
    } catch (error) {
      rethrow;
    }
  }

  Future<int> checkForUpgrade() async {
    CollectionReference user = FirebaseFirestore.instance.collection(userid);
    try {
      var stats = await user.doc('statistics').get();
      int promotionsLeft = stats.get('promotionsLeft') as int;
      int currentLevel = stats.get('level') as int;
      if (promotionsLeft == 0) {
        return currentLevel + 1;
      }
      return 0;
    } catch (error) {
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> fetchLessonKanjiIds() async {
    List<Map<String, dynamic>> kanjiIds = [];

    CollectionReference user = FirebaseFirestore.instance.collection(userid);
    try {
      var queryData = await user
          .where(
            'stage',
            isEqualTo: 0,
          )
          .limit(6)
          .get();
      for (var element in queryData.docs) {
        var data = element.data() as Map<String, dynamic>;
        kanjiIds.add({'id': element.id, 'level': data['level']});
      }
      return kanjiIds;
    } catch (error) {
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> fetchReviewKanjiIds() async {
    DateTime now = DateTime.now();
    DateTime start = DateTime(now.year, now.month, now.day, now.hour);
    List<Map<String, dynamic>> kanjiIds = [];

    CollectionReference user = FirebaseFirestore.instance.collection(userid);
    try {
      var queryData =
          await user.where('nextReview', isLessThanOrEqualTo: start).get();
      for (var element in queryData.docs) {
        var data = element.data() as Map<String, dynamic>;
        kanjiIds.add({
          'id': element.id,
          'level': data['level'],
          'stage': data['stage'],
          'nextReview': data['nextReview'],
          'isPromoted': data['isPromoted'],
          'kanji': data['kanji']
        });
      }
      return kanjiIds;
    } catch (error) {
      rethrow;
    }
  }

  Future<Kanji> fetchKanji(int kanjiLevel, String kanjiId) async {
    final url = Uri.parse(
        'https://kanji-database-b3cee-default-rtdb.firebaseio.com/kanji-level-${kanjiLevel.toString()}/$kanjiId.json');
    try {
      final response = await http.get(url);

      var kanjiData = json.decode(response.body) as Map<String, dynamic>;
      String kanji = kanjiData['kanji'];
      String reading = kanjiData['reading'];
      List<dynamic> meanings = kanjiData['meaning'];
      List<dynamic> onyomis = kanjiData['onyomi'];
      List<dynamic> kunyomis = kanjiData['kunyomi'];

      return Kanji(
        id: kanjiId,
        kanji: kanji,
        meaning: (meanings[0] as String).toLowerCase(),
        reading: reading,
        synonyms: (meanings..removeAt(0))
            .map((e) => e.toString().toLowerCase())
            .toList(),
        onyomi: onyomis.map((e) => e.toString()).toList(),
        kunyomi: kunyomis.map((e) => e.toString()).toList(),
      );
    } catch (error) {
      rethrow;
    }
  }

  void updateReviewKanji(
      {required String kanjiId,
      required int attempts,
      required int curStage,
      required bool isPromoted,
      required String kanji}) async {
    CollectionReference user = FirebaseFirestore.instance.collection(userid);
    int newStage;
    if (attempts == 0) {
      newStage = min(curStage + 1, 9);
    } else {
      int penalty = curStage >= 5 ? 2 : 1;
      newStage = max(1, curStage - ((attempts / 2).ceil()) * penalty);
    }
    DateTime now = DateTime.now();
    DateTime curTime = DateTime(now.year, now.month, now.day, now.hour);
    Duration interval = const Duration();
    switch (newStage) {
      case 1:
        interval = const Duration(hours: 4);
        break;
      case 2:
        interval = const Duration(hours: 8);
        break;
      case 3:
        interval = const Duration(days: 1);
        break;
      case 4:
        interval = const Duration(days: 2);
        break;
      case 5:
        interval = const Duration(days: 7);
        break;
      case 6:
        interval = const Duration(days: 14);
        break;
      case 7:
        interval = const Duration(days: 28);
        break;
      case 8:
        interval = const Duration(hours: 112);
        break;
      case 9:
        interval = const Duration(hours: 1000);
        break;
    }
    Timestamp newNextReview = Timestamp.fromMicrosecondsSinceEpoch(
        (curTime.add(interval)).microsecondsSinceEpoch);

    user.doc(kanjiId).update({
      'stage': newStage,
      'nextReview': newNextReview,
    });
    if (newStage == 5 && !isPromoted) {
      promoteKanji(kanjiId, kanji);
    }
  }

  void updateLessonKanji(String kanjiId) async {
    CollectionReference user = FirebaseFirestore.instance.collection(userid);
    DateTime now = DateTime.now();
    DateTime curTime = DateTime(now.year, now.month, now.day, now.hour);
    user.doc(kanjiId).update({
      'stage': 1,
      'nextReview':
          Timestamp.fromMicrosecondsSinceEpoch(curTime.microsecondsSinceEpoch),
    });
  }

  void promoteKanji(String kanjiId, String kanji) async {
    CollectionReference user = FirebaseFirestore.instance.collection(userid);
    await user.doc(kanjiId).update({
      'isPromoted': true,
    });
    var stats = await user.doc('statistics').get();
    int promotionsLeft = min(0, (stats.get('promotionsLeft') as int) - 1);
    await user.doc('statistics').update({'promotionsLeft': promotionsLeft});
    var vocabs = await user.where(kanji, isEqualTo: false).get();
    var writeBatch = FirebaseFirestore.instance.batch();
    for (var vocab in vocabs.docs) {
      writeBatch.update(user.doc(vocab.id), {
        'stage': FieldValue.increment(1),
        kanji: true,
      });
    }
    writeBatch.commit();
  }

  Future<String> getUsername() async {
    CollectionReference user = FirebaseFirestore.instance.collection(userid);
    try {
      var stats = await user.doc('statistics').get();
      return stats.get('username') as String;
    } catch (error) {
      rethrow;
    }
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getUserLevel() {
    return FirebaseFirestore.instance
        .collection(userid)
        .doc('statistics')
        .snapshots();
  }

  Future<void> login(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      userid = FirebaseAuth.instance.currentUser!.uid;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> signup(String email, String password, String username) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      userid = FirebaseAuth.instance.currentUser!.uid;
      CollectionReference user = FirebaseFirestore.instance.collection(userid);
      await user.doc('statistics').set({
        'username': username,
        'email': email,
        'level': 0,
        'promotionsLeft': -1,
      });
      await upgradeLevel();
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  void logOut() async {
    await FirebaseAuth.instance.signOut();
    notifyListeners();
  }
}
