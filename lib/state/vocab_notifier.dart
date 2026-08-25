import 'dart:convert';
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
  final String? revealCorrection;
  final Map<String, int> failedWordsCount;

  VocabQuizState({
    required this.score,
    required this.highestScore,
    required this.currentItem,
    required this.failedWordsCount,
    this.revealCorrection,
  });
}

class VocabQuizNotifier extends ValueNotifier<VocabQuizState> {
  final List<VocabularyItem> _vocabList;
  final SharedPreferences _prefs;
  final AudioPlayer _audioPlayer = AudioPlayer();

  VocabQuizNotifier(this._vocabList, this._prefs)
      : super(VocabQuizState(
          score: 0,
          highestScore: _prefs.getInt('vocab_highest_streak_key') ?? 0,
          failedWordsCount: _loadFailedMap(_prefs, 'failed_vocab_key'),
          currentItem: _pickItemByWeight(_vocabList, _loadFailedMap(_prefs, 'failed_vocab_key')),
        ));

  static Map<String, int> _loadFailedMap(SharedPreferences prefs, String key) {
    final String? jsonString = prefs.getString(key);
    if (jsonString == null) return {};
    final Map<String, dynamic> decoded = json.decode(jsonString);
    return decoded.map((k, v) => MapEntry(k, v as int));
  }

  // Algoritmo de Repetição Baseado em Erros: Itens mais falhados têm maior peso
  static VocabularyItem _pickItemByWeight(List<VocabularyItem> list, Map<String, int> failedMap) {
    int totalWeight = 0;
    List<int> weights = [];
    
    for (var item in list) {
      int misses = failedMap[item.word] ?? 0;
      int weight = 5 + (misses * 3); // Peso base 5 + 3 por cada erro histórico
      totalWeight += weight;
      weights.add(totalWeight);
    }

    int randomValue = Random().nextInt(totalWeight);
    for (int i = 0; i < list.length; i++) {
      if (randomValue < weights[i]) return list[i];
    }
    return list.first;
  }

  void checkAnswer(String typedAnswer) {
    final cleanInput = typedAnswer.trim().toLowerCase();
    final correctAnswer = value.currentItem.word.trim().toLowerCase();

    int newScore = value.score;
    int newHighest = value.highestScore;
    String? correction;
    Map<String, int> updatedFailedCount = Map.from(value.failedWordsCount);

    if (cleanInput == correctAnswer) {
      newScore += 1;
      if (newScore > newHighest) {
        newHighest = newScore;
        _prefs.setInt('vocab_highest_streak_key', newHighest);
      }
      _audioPlayer.play(UrlSource('https://mixkit.co'));
      HapticFeedback.lightImpact();
    } else {
      correction = value.currentItem.word;
      newScore = 0;
      _audioPlayer.play(UrlSource('https://mixkit.co'));
      HapticFeedback.vibrate();

      updatedFailedCount[value.currentItem.word] = (updatedFailedCount[value.currentItem.word] ?? 0) + 1;
      _prefs.setString('failed_vocab_key', json.encode(updatedFailedCount));
    }

    final nextItem = _pickItemByWeight(_vocabList, updatedFailedCount);

    value = VocabQuizState(
      score: newScore,
      highestScore: newHighest,
      currentItem: nextItem,
      revealCorrection: correction,
      failedWordsCount: updatedFailedCount,
    );
  }
}
