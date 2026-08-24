import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import '../data/vocab_model.dart';

class VocabQuizState {
  final int score;
  final int highestScore;
  final VocabularyItem currentItem;

  VocabQuizState({
    required this.score,
    required this.highestScore,
    required this.currentItem,
  });
}

class VocabQuizNotifier extends ValueNotifier<VocabQuizState> {
  final List<VocabularyItem> _vocabList;
  final AudioPlayer _audioPlayer = AudioPlayer();

  VocabQuizNotifier(this._vocabList)
      : super(VocabQuizState(
          score: 0,
          highestScore: 0, // You can integrate SharedPreferences here later!
          currentItem: _vocabList[Random().nextInt(_vocabList.length)],
        ));

  void checkAnswer(String typedAnswer) {
    final cleanInput = typedAnswer.trim().toLowerCase();
    final correctAnswer = value.currentItem.word.trim().toLowerCase();

    int newScore = value.score;
    int newHighest = value.highestScore;

    if (cleanInput == correctAnswer) {
      newScore += 1;
      if (newScore > newHighest) newHighest = newScore;
      _audioPlayer.play(UrlSource('https://mixkit.co'));
      HapticFeedback.lightImpact();
    } else {
      newScore = 0; // Resets current streak on mistake
      _audioPlayer.play(UrlSource('https://mixkit.co'));
      HapticFeedback.vibrate();
    }

    // Pick a new unique random item
    final nextItem = _vocabList[Random().nextInt(_vocabList.length)];

    value = VocabQuizState(
      score: newScore,
      highestScore: newHighest,
      currentItem: nextItem,
    );
  }
}
