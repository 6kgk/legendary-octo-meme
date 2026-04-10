import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/app_models.dart';

class DataLoader {
  static Future<List<Question>> loadQuestions() async {
    final jsonStr = await rootBundle.loadString('assets/data/questions.json');
    final List<dynamic> jsonList = json.decode(jsonStr);
    return jsonList.map((e) => Question.fromJson(e)).toList();
  }

  static Future<List<School>> loadSchools() async {
    final jsonStr = await rootBundle.loadString('assets/data/schools.json');
    final List<dynamic> jsonList = json.decode(jsonStr);
    return jsonList.map((e) => School.fromJson(e)).toList();
  }
}
