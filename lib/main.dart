import 'package:flutter/material.dart';
import 'package:timber_guard/screens/estimator_screen.dart';
import 'package:timber_guard/theme/app_theme.dart';

void main() {
  runApp(const TimberGuardApp());
}

class TimberGuardApp extends StatelessWidget {
  const TimberGuardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TimberGuard | Premium Estimator',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const EstimatorScreen()
    );
  }
}