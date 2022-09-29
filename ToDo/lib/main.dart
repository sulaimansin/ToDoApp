// @dart=2.9



import 'package:flutter/material.dart';

import 'layout/todo.dart';

void main() {
  runApp(FApp());
}

class FApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return   MaterialApp(
      debugShowCheckedModeBanner: false,
      home:  home_screen(),
    );
  }
}

