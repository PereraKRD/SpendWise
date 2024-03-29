import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:spendwise/common/color_extension.dart';
import 'package:spendwise/firebase_options.dart';
import 'package:spendwise/widgets/AuthGate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SpendWise',
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: child!,
        );
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: TColor.primary),
        useMaterial3: true,
      ),
      home: const AuthGate(),
    );
  }
}
