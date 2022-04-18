import 'package:flexone/data/models/dicussion_result.dart';
import 'package:flutter/material.dart';

class QuestionProvider extends ChangeNotifier {
  List<Question> _questions = [];
  bool _hasReachedMax = false;

  List<Question> get questions => _questions;
  bool get hasReachedMax => _hasReachedMax;

  QuestionProvider() {
    fetchQuestion();
  }

  Future fetchQuestion() async {
    final result = await Question.getQuestions(0, 5, "", 0, 0, null);
    _questions = result;
    notifyListeners();
  }

  void addQuestion(Question question) {
    _questions.add(question);
    notifyListeners();
  }

  void addQuestions(List<Question> questions) {
    _questions.addAll(questions);
    notifyListeners();
  }

  void removeQuestion(String questionId) {
    _questions.removeWhere((question) => question.questionId == questionId);
    notifyListeners();
  }

  void setReachedMax() {
    _hasReachedMax = true;
    notifyListeners();
  }
}