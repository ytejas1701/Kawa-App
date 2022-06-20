import 'package:flutter/material.dart';
import 'package:kawa_app/screens/settings_screen.dart';
import 'package:kawa_app/widgets/current_level_card.dart';
import 'package:provider/provider.dart';

import '../models/customer.dart';
import '../widgets/overview_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _reload() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        toolbarHeight: 120,
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const SettingsScreen()));
              },
              icon: const Icon(Icons.settings))
        ],
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('こんにちは,',
                style: TextStyle(
                    fontSize: 30,
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontWeight: FontWeight.bold)),
            FutureBuilder(
              future: Provider.of<Customer>(context).getUsername(),
              builder: (context, snapshot) {
                String username = '';
                if (snapshot.hasData) {
                  username = '${snapshot.data as String}!';
                }
                return Text(username,
                    style: TextStyle(
                        fontSize: 30,
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontWeight: FontWeight.bold));
              },
            ),
          ],
        ),
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            // Container(
            //     margin: const EdgeInsets.only(left: 16, top: 8),
            //     child: Text(
            //       'Overview',
            //       style: TextStyle(
            //           fontSize: 20,
            //           color: Theme.of(context).colorScheme.onBackground),
            //     )),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              OverViewCard('Reviews', _reload),
              OverViewCard('Lessons', _reload),
            ]),
            // const SizedBox(
            //   height: 20,
            // ),
            Divider(
              indent: 16,
              endIndent: 16,
              color: Theme.of(context).colorScheme.onError,
            ),

            Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  'Current Level',
                  style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.onSurface),
                )),
            const SizedBox(
              height: 10,
            ),
            CurrentLevelCard(),
            // const SizedBox(
            //   height: 10,
            // ),
            // Divider(
            //   indent: 16,
            //   endIndent: 16,
            //   color: Theme.of(context).colorScheme.onError,
            // ),
            // Container(
            //     margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            //     child: Text(
            //       'Calendar',
            //       style: TextStyle(
            //           fontSize: 18,
            //           color: Theme.of(context).colorScheme.onSurface),
            //     )),
          ]),
    );
  }
}
