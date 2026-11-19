import 'package:flutter/material.dart';

import '../domain/models/book.dart';

/// Salinan BookTile versi 1.0 yang berisi BUG #1.
/// Bandingkan dengan lib/ui/catalog/book_tile.dart (PERBAIKAN #1).
class BuggyBookTile extends StatelessWidget {
  const BuggyBookTile({
    super.key,
    required this.book,
    required this.isFavorite,
    required this.onFavorite,
    required this.onTap,
  });

  final Book book;
  final bool isFavorite;
  final VoidCallback onFavorite;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 4, 10),
        child: Row(
          children: [
            Container(width: 44, height: 60, color: colors.primaryContainer, child: const Icon(Icons.menu_book)),
            const SizedBox(width: 14),
            // BUG #1: Column di dalam Row tanpa Expanded. Judul selebar teksnya
            // sendiri, sehingga di HP kecil Row lebih lebar dari layar (overflow).
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(book.title, style: const TextStyle(fontWeight: FontWeight.w600)),
                Text('${book.author} · ${book.year}', style: TextStyle(color: colors.onSurfaceVariant)),
              ],
            ),
            const SizedBox(width: 8),
            Chip(label: Text(book.shelf), visualDensity: VisualDensity.compact),
            IconButton(
              tooltip: 'Favorit',
              onPressed: onFavorite,
              icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border, color: colors.primary),
            ),
          ],
        ),
      ),
    );
  }
}
