import 'dart:async';

import 'package:flutter/material.dart';

import '../../domain/book_sorter.dart';
import '../../domain/models/book.dart';
import '../detail/book_detail_screen.dart';

/// Pencarian judul atau penulis. Hasil dicari 300 ms setelah berhenti mengetik.
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key, required this.books});

  final List<Book> books;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  Timer? _debounce;
  List<Book> _results = const [];

  void _onChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      setState(() => _results = searchBooks(widget.books, query));
    });
  }

  // PERBAIKAN #4: semua yang dibuat di State dan punya dispose()/cancel()
  // harus dibersihkan di sini. Kalau lupa, memori dan timer tetap hidup.
  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          key: const Key('kolom-cari'),
          controller: _controller,
          autofocus: true,
          onChanged: _onChanged,
          decoration: const InputDecoration(hintText: 'Judul atau penulis', border: InputBorder.none),
        ),
      ),
      body: ListView.builder(
        itemCount: _results.length,
        itemBuilder: (context, index) {
          final book = _results[index];
          return ListTile(
            title: Text(book.title),
            subtitle: Text(book.author),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => BookDetailScreen(book: book)),
            ),
          );
        },
      ),
    );
  }
}
