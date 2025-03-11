import 'package:flutter/material.dart';

extension ContextExt on BuildContext{
  bool isLargeScreen() => MediaQuery.of(this).size.height > 650;
  bool isTablet() => MediaQuery.of(this).size.shortestSide > 600;
}