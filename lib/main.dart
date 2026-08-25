import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data/verb_model.dart';
import 'data/vocab_model.dart';
import 'state/quiz_notifier.dart';
import 'ui/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<Map<String, dynamic>> _initAppData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    
    final String verbsResponse = await rootBundle.loadString('assets/verbs.json');
    final List<dynamic> verbsData = json.decode(verbsResponse);
    final List<Verb> loadedVerbs = verbsData.map((jsonItem) => Verb.fromJson(jsonItem)).toList();
    
    final String vocabResponse = await rootBundle.loadString('assets/vocabulary.json');
    final List<dynamic> vocabData = json.decode(vocabResponse);
    final List<VocabularyItem> loadedVocab = vocabData.map((jsonItem) => VocabularyItem.fromJson(jsonItem)).toList();
    
    return {
      'notifier': DynamicQuizNotifier(loadedVerbs, prefs),
      'vocabList': loadedVocab
    };
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _initAppData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(home: Scaffold(body: Center(child: CircularProgressIndicator())));
        }
        if (snapshot.hasError) {
          return const MaterialApp(home: Scaffold(body: Center(child: Text('Error initializing application.'))));
        }

        final DynamicQuizNotifier quizNotifier = snapshot.data!['notifier'];
        final List<VocabularyItem> vocabList = snapshot.data!['vocabList'];

        return ValueListenableBuilder<DynamicQuizState>(
          valueListenable: quizNotifier,
          builder: (context, state, child) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              themeMode: state.isDarkMode ? ThemeMode.dark : ThemeMode.light,
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo, brightness: Brightness.light),
                useMaterial3: true,
              ),
              darkTheme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo, brightness: Brightness.dark),
                useMaterial3: true,
              ),
              home: HomeScreen(quizNotifier: quizNotifier, vocabularyList: vocabList),
            );
          },
        );
      },
    );
  }
}
