import 'dart:async';

import 'package:flutter/material.dart';

import '../domain/book_sorter.dart';
import '../domain/models/book.dart';
import 'buggy_detail_screen.dart';

/// Salinan SearchScreen versi 1.0 yang berisi BUG #4.
/// Bandingkan dengan lib/ui/search/search_screen.dart (PERBAIKAN #4).
class BuggySearchScreen extends StatefulWidget {
  const BuggySearchScreen({super.key, required this.books});

  final List<Book> books;

  @override
  State<BuggySearchScreen> createState() => _BuggySearchScreenState();
}

class _BuggySearchScreenState extends State<BuggySearchScreen> {
  final _controller = TextEditingController();
  Timer? _debounce;
  List<Book> _results = const [];

  void _onChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      setState(() => _results = searchBooks(widget.books, query));
    });
  }

  // BUG #4: tidak ada dispose(). _controller tidak pernah dibuang dan
  // _debounce tetap berjalan setelah layar ditutup (kebocoran memori).

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
              MaterialPageRoute(builder: (_) => BuggyDetailScreen(book: book)),
            ),
          );
        },
      ),
    );
  }
}
