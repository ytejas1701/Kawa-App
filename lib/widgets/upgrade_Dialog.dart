import 'package:flutter/material.dart';
import 'package:kawa_app/models/customer.dart';
import 'package:provider/provider.dart';

class UpgradeDialog extends StatelessWidget {
  final int newLevel;
  UpgradeDialog(this.newLevel);
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Theme.of(context).colorScheme.primary,
      child: Container(
          padding: const EdgeInsets.all(16),
          alignment: Alignment.center,
          height: 360,
          child: Column(
            children: [
              Text(
                newLevel.toString(),
                style: const TextStyle(fontSize: 150),
              ),
              const Text(
                'Congratulations!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const Text(
                'Your level has increased.',
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 40,
              ),
              FutureBuilder(
                  future: Provider.of<Customer>(context, listen: false)
                      .upgradeLevel(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      );
                    }
                    return TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'Continue',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary),
                        ));
                  })
            ],
          )),
    );
  }
}
