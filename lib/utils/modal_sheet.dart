import 'package:flutter/material.dart';
import 'package:new_scanner/main.dart';

class ModalSheet {
  static showModalSheet(Widget body, {bool totalHeight = false}){
    showModalBottomSheet(
      isScrollControlled: totalHeight,
      backgroundColor: Colors.white,
      context: Myapp.navigatorKey.currentContext!,
      builder: (context) {
        return body;
      },
    );
  }
}