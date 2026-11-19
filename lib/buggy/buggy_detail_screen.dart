import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/repositories/book_repository.dart';
import '../domain/models/book.dart';

/// Salinan BookDetailScreen versi 1.0 yang berisi BUG #2 dan BUG #5.
/// Bandingkan dengan lib/ui/detail/book_detail_screen.dart.
class BuggyDetailScreen extends StatefulWidget {
  const BuggyDetailScreen({super.key, required this.book});

  final Book book;

  @override
  State<BuggyDetailScreen> createState() => _BuggyDetailScreenState();
}

class _BuggyDetailScreenState extends State<BuggyDetailScreen> {
  int? _copies;

  @override
  void initState() {
    super.initState();
    _loadCopies();
  }

  Future<void> _loadCopies() async {
    final copies = await context.read<BookRepository>().availableCopies(widget.book.id);
    // BUG #2: jika pengguna menekan Kembali sebelum 1 detik, layar ini sudah
    // dibuang (dispose), tetapi setState tetap dipanggil.
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
              trailing: Text(_copies == null ? '...' : '$_copies', style: text.titleLarge),
            ),
          ),
          const SizedBox(height: 20),
          Text('Sinopsis', style: text.titleMedium),
          const SizedBox(height: 6),
          // BUG #5: sepertiga buku tidak punya sinopsis (null). Tanda "!"
          // memaksa null dianggap String, lalu layar menjadi merah.
          Text(book.synopsis!),
        ],
      ),
    );
  }
}
