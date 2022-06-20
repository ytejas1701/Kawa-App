import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:kawa_app/models/customer.dart';
import 'package:provider/provider.dart';

import './screens/home_screen.dart';
import './screens/auth_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => Customer(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              colorScheme: const ColorScheme(
            primary: Color.fromARGB(255, 17, 224, 243),
            onPrimary: Colors.white,
            secondary: Color.fromARGB(255, 255, 167, 25),
            onSecondary: Colors.white,
            tertiary: Color.fromARGB(255, 42, 245, 6),
            onTertiary: Colors.white,
            surface: Color.fromARGB(255, 46, 43, 43),
            onSurface: Color.fromARGB(255, 170, 166, 166),
            background: Color.fromARGB(255, 20, 20, 20),
            onBackground: Colors.white,
            error: Color.fromARGB(255, 255, 255, 255),
            onError: Color.fromARGB(255, 170, 166, 166),
            brightness: Brightness.dark,
          )),
          home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (ctx, snapshot) {
              if (snapshot.hasData) return const HomeScreen();
              return AuthScreen();
            },
          ),
        ));
  }
}
