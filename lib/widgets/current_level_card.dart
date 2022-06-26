import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/customer.dart';

class CurrentLevelCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.topLeft,
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: Provider.of<Customer>(context).getUserLevel(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(
                      '${(snapshot.data!.data() as Map<String, dynamic>)['level']}',
                      style: const TextStyle(fontSize: 30),
                    );
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(
                        child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.tertiary,
                    ));
                  } else {
                    return const Text(
                      '0',
                      style: TextStyle(fontSize: 30),
                    );
                  }
                }),
          ],
        ));
  }
}
