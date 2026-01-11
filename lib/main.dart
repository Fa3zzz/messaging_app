import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:messaging_app/views/login_view.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Messaging App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        appBarTheme: AppBarTheme(
          backgroundColor: ColorScheme.fromSeed(
            seedColor: Colors.indigo,
          ).secondary,
          foregroundColor: ColorScheme.fromSeed(
            seedColor: Colors.indigo,
          ).onSecondary,
        ),
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: TextStyle(
            color: ColorScheme.fromSeed(
              seedColor: Colors.indigo,
            ).onSecondary.withAlpha(150),
          ),
        ),
      ),
      home: const LoginView(),
    );
  }
}