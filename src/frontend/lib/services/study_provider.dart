import 'package:flutter/material.dart';
import '../models/app_models.dart';
import 'data_loader.dart';

class StudyProvider with ChangeNotifier {
  List<Question> _allQuestions = [];
  bool _isLoaded = false;

  bool get isLoaded => _isLoaded;

  Future<void> loadData() async {
    if (_isLoaded) return;
    _allQuestions = await DataLoader.loadQuestions();
    _isLoaded = true;
    notifyListeners();
  }

  List<Question> getQuestionsBySubject(String subject) {
    return _allQuestions.where((q) => q.subject == subject).toList();
  }

  Question? getQuestionById(String id) {
    try {
      return _allQuestions.firstWhere((q) => q.id == id);
    } catch (e) {
      return null;
    }
  }

  int getSubjectCount(String subject) {
    return _allQuestions.where((q) => q.subject == subject).length;
  }

  // Quiz state
  int _currentQuestionIndex = 0;
  int _correctCount = 0;
  int get currentQuestionIndex => _currentQuestionIndex;
  int get correctCount => _correctCount;

  void recordAnswer(bool isCorrect) {
    if (isCorrect) _correctCount++;
  }

  void nextQuestion() {
    _currentQuestionIndex++;
    notifyListeners();
  }

  void resetQuiz() {
    _currentQuestionIndex = 0;
    _correctCount = 0;
    notifyListeners();
  }
}
