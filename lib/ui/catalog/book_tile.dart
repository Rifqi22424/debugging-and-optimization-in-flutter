import 'package:flutter/material.dart';

import '../../domain/models/book.dart';

/// Satu baris buku di katalog: sampul, judul, penulis, rak, tombol favorit.
class BookTile extends StatelessWidget {
  const BookTile({
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
            const _Cover(),
            const SizedBox(width: 14),
            // PERBAIKAN #1: Expanded memberi judul sisa lebar yang ada,
            // lalu judul yang terlalu panjang dipotong dengan "...".
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(book.title, maxLines: 2, overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  Text('${book.author} · ${book.year}', style: TextStyle(color: colors.onSurfaceVariant)),
                ],
              ),
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

/// Sampul sederhana. const: dibuat sekali, tidak ikut dibangun ulang.
class _Cover extends StatelessWidget {
  const _Cover();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 60,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(6),
      ),
      child: const Icon(Icons.menu_book),
    );
  }
}
