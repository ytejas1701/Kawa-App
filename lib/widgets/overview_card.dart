import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/customer.dart';
import '../screens/lesson_screen.dart';
import '../screens/review_screen.dart';

class OverViewCard extends StatefulWidget {
  final String title;
  final Function _reloadHomeScreen;
  OverViewCard(this.title, this._reloadHomeScreen);

  @override
  State<OverViewCard> createState() => _OverViewCardState();
}

class _OverViewCardState extends State<OverViewCard> {
  @override
  Widget build(BuildContext context) {
    final Future<List<Map<String, dynamic>>> buildingList =
        widget.title == 'Reviews'
            ? Provider.of<Customer>(context).fetchReviewKanjiIds()
            : Provider.of<Customer>(context).fetchLessonKanjiIds();
    final deviceSize = MediaQuery.of(context).size;
    return Container(
        width: deviceSize.width / 2 - 16,
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(top: 16, bottom: 16, left: 8, right: 4),
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(10)),
        child: InkWell(
            onTap: () {
              buildingList.then((value) {
                if (value.isNotEmpty) {
                  widget.title == 'Reviews'
                      ? Navigator.of(context)
                          .push(MaterialPageRoute(
                              builder: ((context) => ReviewScreen(value))))
                          .then((_) {
                          widget._reloadHomeScreen();
                        })
                      : Navigator.of(context)
                          .push(MaterialPageRoute(
                              builder: ((context) => LessonScreen(value))))
                          .then((_) {
                          widget._reloadHomeScreen();
                        });
                }
              });
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.onBackground),
                ),
                const SizedBox(
                  height: 10,
                ),
                FutureBuilder(
                    future: buildingList,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        int len = (snapshot.data as List<dynamic>).length;
                        if (len == 0 && widget.title != 'Reviews') {
                          Provider.of<Customer>(context, listen: false)
                              .upgradeLevel()
                              .then((value) => ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                      content: Text(
                                          'Congratulations! You are now at level $value.'))));
                        }
                        return Text(
                          '$len ',
                          style: TextStyle(
                              fontSize: 50,
                              color: widget.title == 'Reviews'
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.secondary),
                        );
                      } else if (snapshot.hasError) {
                        return const Center(child: Text('an error ocurred'));
                      } else {
                        return Container(
                            margin: const EdgeInsets.only(top: 12, bottom: 11),
                            alignment: Alignment.bottomLeft,
                            child: CircularProgressIndicator(
                                color: widget.title == 'Reviews'
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context).colorScheme.secondary));
                      }
                    }),
              ],
            )));
  }
}
