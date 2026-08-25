import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import '../data/data_eng_model.dart';

class DataEngQuizState {
  final int score;
  final DataEngItem currentItem;
  final List<String> currentOptions;
  final bool? lastAnswerWasCorrect;
  final String? lastExplanation; // Guarda a explicação técnica para exibir à posteriori

  DataEngQuizState({
    required this.score,
    required this.currentItem,
    required this.currentOptions,
    this.lastAnswerWasCorrect,
    this.lastExplanation,
  });
}

class DataEngQuizNotifier extends ValueNotifier<DataEngQuizState> {
  final List<DataEngItem> _items;
  final AudioPlayer _audioPlayer = AudioPlayer();

  DataEngQuizNotifier(this._items) : super(_createInitialState(_items));

  static DataEngQuizState _createInitialState(List<DataEngItem> items) {
    final firstItem = items[Random().nextInt(items.length)];
    return DataEngQuizState(
      score: 0,
      currentItem: firstItem,
      currentOptions: firstItem.getShuffledOptions(),
    );
  }

  void submitChoice(String selectedAnswer) {
    final previousItem = value.currentItem;
    bool isCorrect = selectedAnswer == previousItem.correctAnswer;
    int newScore = value.score;

    if (isCorrect) {
      newScore += 1;
      _audioPlayer.play(UrlSource('https://mixkit.co'));
      HapticFeedback.lightImpact();
    } else {
      _audioPlayer.play(UrlSource('https://mixkit.co'));
      HapticFeedback.vibrate();
    }

    // Sorteia o próximo item
    final nextItem = _items[Random().nextInt(_items.length)];

    value = DataEngQuizState(
      score: newScore,
      currentItem: nextItem,
      currentOptions: nextItem.getShuffledOptions(),
      lastAnswerWasCorrect: isCorrect,
      lastExplanation: previousItem.explanation, // Passa a explicação do cenário acabado de responder
    );
  }
}
