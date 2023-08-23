import 'package:flutter/material.dart';
import 'package:teatro_digital/screens/play_writer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: PlayWriter(),
    );
  }
}