import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/repositories/book_repository.dart';
import '../../domain/models/book.dart';

/// Detail satu buku. Jumlah eksemplar di rak dimuat dari server (1 detik).
class BookDetailScreen extends StatefulWidget {
  const BookDetailScreen({super.key, required this.book});

  final Book book;

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  int? _copies; // null = masih dimuat

  @override
  void initState() {
    super.initState();
    _loadCopies();
  }

  Future<void> _loadCopies() async {
    final copies = await context.read<BookRepository>().availableCopies(widget.book.id);
    // PERBAIKAN #2: pengguna mungkin sudah menekan Kembali selama 1 detik itu.
    // Jika layar sudah ditutup (tidak mounted), jangan panggil setState.
    if (!mounted) return;
    setState(() => _copies = copies);
  }

  @override
  Widget build(BuildContext context) {
    final book = widget.book;
    final text = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Buku')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(book.title, style: text.headlineSmall),
          const SizedBox(height: 8),
          Text('${book.author} · ${book.year} · Rak ${book.shelf}', style: text.titleSmall),
          const SizedBox(height: 20),
          Card(
            child: ListTile(
              leading: const Icon(Icons.inventory_2_outlined),
              title: const Text('Eksemplar di rak'),
              trailing: _copies == null
                  ? const SizedBox.square(dimension: 24, child: CircularProgressIndicator(strokeWidth: 3))
                  : Text('$_copies', key: const Key('teks-eksemplar'), style: text.titleLarge),
            ),
          ),
          const SizedBox(height: 20),
          Text('Sinopsis', style: text.titleMedium),
          const SizedBox(height: 6),
          // PERBAIKAN #5: synopsis boleh null. Beri teks pengganti, jangan pakai "!".
          Text(book.synopsis ?? 'Belum ada sinopsis untuk buku ini.'),
        ],
      ),
    );
  }
}
