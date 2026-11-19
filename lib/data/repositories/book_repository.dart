import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';

import '../../domain/models/book.dart';
import '../services/catalog_service.dart';

/// Mengubah teks JSON menjadi daftar Book.
/// Fungsi top-level supaya bisa dijalankan di isolate lain dengan compute().
List<Book> parseBooks(String body) {
  final list = jsonDecode(body) as List<dynamic>;
  return list.map((item) => Book.fromJson(item as Map<String, dynamic>)).toList();
}

class BookRepository {
  BookRepository({required CatalogService service}) : _service = service;

  final CatalogService _service;

  Future<List<Book>> loadCatalog() async {
    final stopwatch = Stopwatch()..start();
    final body = await _service.fetchCatalogJson();
    // Parsing 2.000 data di isolate terpisah, supaya UI tidak tersendat.
    final books = await compute(parseBooks, body);
    // log() tampil di console dan di tab Logging DevTools, dengan nama sumbernya.
    log('Katalog dimuat: ${books.length} buku, ${stopwatch.elapsedMilliseconds} ms', name: 'NusaPustaka');
    return books;
  }

  Future<int> availableCopies(String bookId) => _service.fetchAvailableCopies(bookId);
}
