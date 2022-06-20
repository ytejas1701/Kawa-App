import 'package:flutter/material.dart';
import 'package:kawa_app/models/customer.dart';
import 'package:kawa_app/widgets/current_level_card.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var customer = Provider.of<Customer>(context, listen: false);
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).colorScheme.background,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CurrentLevelCard(),
                  const SizedBox(
                    width: 20,
                  ),
                  Flexible(
                    child: FutureBuilder(
                      future: customer.getUsername(),
                      builder: (context, snapshot) {
                        String username = '';
                        if (snapshot.hasData) {
                          username = snapshot.data as String;
                        }
                        return Text(username,
                            style: TextStyle(
                                fontSize: 30,
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontWeight: FontWeight.bold));
                      },
                    ),
                  )
                ],
              ),
            ),
            const Divider(
              thickness: 3,
            ),
            ListTile(
              leading: const Icon(Icons.upgrade),
              title: const Text(
                'Upgrade',
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                customer.upgradeLevel().then((value) =>
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            'Congratulations! You are now at level $value.'))));
              },
            ),
            ListTile(
                leading: const Icon(Icons.logout),
                title: const Text(
                  'Logout',
                  style: TextStyle(fontSize: 20),
                ),
                onTap: () async {
                  Navigator.of(context).pop();
                  customer.logOut();
                })
          ],
        ));
  }
}
