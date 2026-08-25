import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/vocab_model.dart';

class VocabQuizState {
  final int score;
  final int highestScore;
  final VocabularyItem currentItem;
  final String? revealCorrection; // New: Carries the right word if you make a typo

  VocabQuizState({
    required this.score,
    required this.highestScore,
    required this.currentItem,
    this.revealCorrection,
  });
}

class VocabQuizNotifier extends ValueNotifier<VocabQuizState> {
  final List<VocabularyItem> _vocabList;
  final SharedPreferences _prefs; // Standard storage bridge
  final AudioPlayer _audioPlayer = AudioPlayer();

  VocabQuizNotifier(this._vocabList, this._prefs)
      : super(VocabQuizState(
          score: 0,
          highestScore: _prefs.getInt('vocab_highest_streak_key') ?? 0, // Load saved vocab record
          currentItem: _vocabList[Random().nextInt(_vocabList.length)],
        ));

  void checkAnswer(String typedAnswer) {
    final cleanInput = typedAnswer.trim().toLowerCase();
    final correctAnswer = value.currentItem.word.trim().toLowerCase();

    int newScore = value.score;
    int newHighest = value.highestScore;
    String? correction;

    if (cleanInput == correctAnswer) {
      newScore += 1;
      if (newScore > newHighest) {
        newHighest = newScore;
        _prefs.setInt('vocab_highest_streak_key', newHighest); // Save new vocab record permanently
      }
      _audioPlayer.play(UrlSource('https://mixkit.co'));
      HapticFeedback.lightImpact();
    } else {
      // Capture the exact word you missed so the UI can display it
      correction = value.currentItem.word;
      newScore = 0; // Reset streak run
      _audioPlayer.play(UrlSource('https://mixkit.co'));
      HapticFeedback.vibrate();
    }

    final nextItem = _vocabList[Random().nextInt(_vocabList.length)];

    value = VocabQuizState(
      score: newScore,
      highestScore: newHighest,
      currentItem: nextItem,
      revealCorrection: correction,
    );
  }
}
