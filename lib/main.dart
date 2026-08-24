import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data/verb_model.dart';
import 'state/quiz_notifier.dart';
import 'ui/quiz_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<DynamicQuizNotifier> _initQuizNotifier() async {
    // Initialize standard instances natively
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String response = await rootBundle.loadString('assets/verbs.json');
    final List<dynamic> data = json.decode(response);
    final List<Verb> loadedVerbs = data.map((jsonItem) => Verb.fromJson(jsonItem)).toList();
    
    return DynamicQuizNotifier(loadedVerbs, prefs);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: FutureBuilder<DynamicQuizNotifier>(
        future: _initQuizNotifier(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (snapshot.hasError) {
            return const Scaffold(
              body: Center(child: Text('Error loading verb dataset.')),
            );
          }
          return QuizScreen(quizNotifier: snapshot.data!);
        },
      ),
    );
  }
}
