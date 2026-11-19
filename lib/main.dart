import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'config/dependencies.dart';

/// Versi yang SUDAH DIPERBAIKI. Versi berbug: flutter run -t lib/main_buggy.dart
void main() {
  runApp(MultiProvider(providers: providers, child: const NusaPustakaApp()));
}
