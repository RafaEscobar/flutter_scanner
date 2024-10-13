import 'package:flutter/material.dart';

class ProviderService extends ChangeNotifier{
  String _reference = '';

  String get reference => _reference;
  set reference(String newValue){
    _reference = newValue;
    notifyListeners();
  }
}