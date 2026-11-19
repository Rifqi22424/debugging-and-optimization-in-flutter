import 'package:flutter/material.dart';

import 'ui/catalog/catalog_page.dart';

class NusaPustakaApp extends StatelessWidget {
  const NusaPustakaApp({super.key, this.home = const CatalogPage()});

  /// Layar pertama. main_buggy.dart mengganti layar ini dengan versi berbug.
  final Widget home;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NusaPustaka',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: const Color(0xFF2E6B5E)),
      home: home,
    );
  }
}
