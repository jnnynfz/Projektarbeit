import 'package:flutter/material.dart';

class ErrorLog extends ChangeNotifier {
  static final ErrorLog _instance = ErrorLog._internal();

  factory ErrorLog() {
    return _instance;
  }

  ErrorLog._internal();

  List<String> _errors = [];

  List<String> get errors => _errors;

  void addError(String error) {
    _errors.add(error);
    notifyListeners();
  }
}