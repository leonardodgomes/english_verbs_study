import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/data_eng_model.dart';

class DataEngQuizState {
  final int score;
  final int highestScore; // Novo: Recorde persistente de engenharia
  final DataEngItem currentItem;
  final List<String> currentOptions;
  final bool? lastAnswerWasCorrect;
  final String? lastExplanation;
  final Map<String, int> failedScenariosCount;

  DataEngQuizState({
    required this.score,
    required this.highestScore,
    required this.currentItem,
    required this.currentOptions,
    required this.failedScenariosCount,
    this.lastAnswerWasCorrect,
    this.lastExplanation,
  });
}

class DataEngQuizNotifier extends ValueNotifier<DataEngQuizState> {
  final List<DataEngItem> _items;
  final SharedPreferences _prefs;
  final AudioPlayer _audioPlayer = AudioPlayer();

  DataEngQuizNotifier(this._items, this._prefs) : super(_createInitialState(_items, _prefs));

  static Map<String, int> _loadFailedMap(SharedPreferences prefs, String key) {
    final String? jsonString = prefs.getString(key);
    if (jsonString == null) return {};
    final Map<String, dynamic> decoded = json.decode(jsonString);
    return decoded.map((k, v) => MapEntry(k, v as int));
  }

  static DataEngQuizState _createInitialState(List<DataEngItem> items, SharedPreferences prefs) {
    final Map<String, int> failedMap = _loadFailedMap(prefs, 'failed_data_eng_key');
    final firstItem = _pickItemByWeight(items, failedMap);
    return DataEngQuizState(
      score: 0,
      highestScore: prefs.getInt('data_eng_highest_key') ?? 0,
      currentItem: firstItem,
      currentOptions: firstItem.getShuffledOptions(),
      failedScenariosCount: failedMap,
    );
  }

  static DataEngItem _pickItemByWeight(List<DataEngItem> list, Map<String, int> failedMap) {
    int totalWeight = 0;
    List<int> weights = [];
    
    for (var item in list) {
      String shortName = item.scenario.length > 30 ? '${item.scenario.substring(0, 30)}...' : item.scenario;
      int misses = failedMap[shortName] ?? 0;
      int weight = 5 + (misses * 3);
      totalWeight += weight;
      weights.add(totalWeight);
    }

    int randomValue = Random().nextInt(totalWeight);
    for (int i = 0; i < list.length; i++) {
      if (randomValue < weights[i]) return list[i];
    }
    return list.first;
  }

  void submitChoice(String selectedAnswer) {
    final previousItem = value.currentItem;
    bool isCorrect = selectedAnswer == previousItem.correctAnswer;
    
    int newScore = value.score;
    int newHighest = value.highestScore;
    Map<String, int> updatedFailedCount = Map.from(value.failedScenariosCount);

    String shortName = previousItem.scenario.length > 30 
        ? '${previousItem.scenario.substring(0, 30)}...' 
        : previousItem.scenario;

    if (isCorrect) {
      newScore += 1;
      if (newScore > newHighest) {
        newHighest = newScore;
        _prefs.setInt('data_eng_highest_key', newHighest);
      }
      _audioPlayer.play(UrlSource('https://mixkit.co'));
      HapticFeedback.lightImpact();
    } else {
      newScore = 0; // Reset de streak de arquitetura
      _audioPlayer.play(UrlSource('https://mixkit.co'));
      HapticFeedback.vibrate();

      updatedFailedCount[shortName] = (updatedFailedCount[shortName] ?? 0) + 1;
      _prefs.setString('failed_data_eng_key', json.encode(updatedFailedCount));
    }

    final nextItem = _pickItemByWeight(_items, updatedFailedCount);

    value = DataEngQuizState(
      score: newScore,
      highestScore: newHighest,
      currentItem: nextItem,
      currentOptions: nextItem.getShuffledOptions(),
      lastAnswerWasCorrect: isCorrect,
      lastExplanation: previousItem.explanation,
      failedScenariosCount: updatedFailedCount,
    );
  }
}
