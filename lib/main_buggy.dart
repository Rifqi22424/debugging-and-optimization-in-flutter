import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'buggy/buggy_catalog_page.dart';
import 'config/dependencies.dart';

/// NusaPustaka versi 1.0 yang masih berisi 5 bug (folder lib/buggy/).
/// Jalankan dengan: flutter run -t lib/main_buggy.dart
void main() {
  runApp(MultiProvider(
    providers: providers,
    child: const NusaPustakaApp(home: BuggyCatalogPage()),
  ));
}
