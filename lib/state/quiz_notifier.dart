import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/verb_model.dart';
import 'question_engine.dart';

class DynamicQuizState {
  final int score;
  final int streak;
  final int highestStreak;
  final bool isDarkMode;
  final DynamicQuestion currentQuestion;
  final List<HistoryEntry> history;
  final String? revealCorrection;
  final Map<String, int> failedVerbsCount;

  DynamicQuizState({
    required this.score,
    required this.streak,
    required this.highestStreak,
    required this.isDarkMode,
    required this.currentQuestion,
    required this.history,
    required this.failedVerbsCount,
    this.revealCorrection,
  });
}

class DynamicQuizNotifier extends ValueNotifier<DynamicQuizState> {
  final List<Verb> _verbs;
  final SharedPreferences prefsInstance;

  DynamicQuizNotifier(this._verbs, this.prefsInstance)
      : super(DynamicQuizState(
          score: 0,
          streak: 0,
          highestStreak: prefsInstance.getInt('highest_streak_key') ?? 0,
          isDarkMode: prefsInstance.getBool('is_dark_mode_key') ?? false,
          currentQuestion: DynamicQuestion.generate(_pickVerbByWeight(_verbs), _verbs),
          history: [],
          failedVerbsCount: _loadFailedMap(prefsInstance, 'failed_verbs_key'),
        ));

  static Map<String, int> _loadFailedMap(SharedPreferences prefs, String key) {
    final String? jsonString = prefs.getString(key);
    if (jsonString == null) return {};
    final Map<String, dynamic> decoded = json.decode(jsonString);
    return decoded.map((k, v) => MapEntry(k, v as int));
  }

  static Verb _pickVerbByWeight(List<Verb> verbs) {
    int totalWeight = verbs.fold(0, (sum, item) => sum + item.weight);
    int randomValue = Random().nextInt(totalWeight);
    int currentSum = 0;
    for (var verb in verbs) {
      currentSum += verb.weight;
      if (randomValue < currentSum) return verb;
    }
    return verbs.first;
  }

  void toggleTheme() {
    final nextMode = !value.isDarkMode;
    prefsInstance.setBool('is_dark_mode_key', nextMode);
    value = DynamicQuizState(
      score: value.score,
      streak: value.streak,
      highestStreak: value.highestStreak,
      isDarkMode: nextMode,
      currentQuestion: value.currentQuestion,
      history: value.history,
      failedVerbsCount: value.failedVerbsCount,
    );
  }

  void submitAnswer(String typedAnswer) {
    final currentQuestion = value.currentQuestion;
    final activeVerb = currentQuestion.verb;
    
    final cleanInput = typedAnswer.trim().toLowerCase();
    final correctTarget = currentQuestion.correctAnswer.trim().toLowerCase();

    int newScore = value.score;
    int newStreak = value.streak;
    int newHighestStreak = value.highestStreak;
    bool isCorrect = cleanInput == correctTarget;
    String? correction;
    Map<String, int> updatedFailedCount = Map.from(value.failedVerbsCount);

    if (isCorrect) {
      newScore += 1;
      newStreak += 1;
      if (newStreak > newHighestStreak) {
        newHighestStreak = newStreak;
        prefsInstance.setInt('highest_streak_key', newHighestStreak);
      }
      if (activeVerb.weight > 1) activeVerb.weight -= 1;
    } else {
      correction = currentQuestion.correctAnswer;
      newScore -= 1;
      newStreak = 0;
      activeVerb.weight += 3;

      updatedFailedCount[activeVerb.infinitive] = (updatedFailedCount[activeVerb.infinitive] ?? 0) + 1;
      prefsInstance.setString('failed_verbs_key', json.encode(updatedFailedCount));
    }

    final newEntry = HistoryEntry(
      verbInfinitive: activeVerb.infinitive,
      questionText: currentQuestion.questionText,
      userAnswer: typedAnswer,
      correctAnswer: currentQuestion.correctAnswer,
      isCorrect: isCorrect,
    );

    List<HistoryEntry> updatedHistory = List.from(value.history);
    updatedHistory.insert(0, newEntry);
    if (updatedHistory.length > 5) updatedHistory.removeLast();

    Verb nextVerb = _pickVerbByWeight(_verbs);
    
    value = DynamicQuizState(
      score: newScore,
      streak: newStreak,
      highestStreak: newHighestStreak,
      isDarkMode: value.isDarkMode,
      currentQuestion: DynamicQuestion.generate(nextVerb, _verbs),
      history: updatedHistory,
      revealCorrection: correction,
      failedVerbsCount: updatedFailedCount,
    );
  }
}
