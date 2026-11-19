import 'package:flutter/material.dart';

import '../detail/book_detail_screen.dart';
import '../search/search_screen.dart';
import 'book_tile.dart';
import 'catalog_view_model.dart';

/// Layar utama: daftar 2.000 buku di katalog.
class CatalogScreen extends StatelessWidget {
  const CatalogScreen({super.key, required this.viewModel});

  final CatalogViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NusaPustaka'),
        actions: [
          IconButton(
            tooltip: 'Cari',
            icon: const Icon(Icons.search),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => SearchScreen(books: viewModel.books)),
            ),
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: viewModel,
        builder: (context, _) {
          if (viewModel.isLoading) return const Center(child: CircularProgressIndicator());
          if (viewModel.error != null) return Center(child: Text(viewModel.error!));

          final books = viewModel.books; // sudah urut, tidak diurutkan lagi di sini
          return Column(
            children: [
              _Summary(total: books.length, favorites: viewModel.favoriteCount),
              Expanded(
                // PERBAIKAN #3 (bagian 2): ListView.builder hanya membangun
                // baris yang terlihat di layar, bukan 2.000 baris sekaligus.
                child: ListView.builder(
                  itemCount: books.length,
                  itemBuilder: (context, index) {
                    final book = books[index];
                    return BookTile(
                      book: book,
                      isFavorite: viewModel.isFavorite(book.id),
                      onFavorite: () => viewModel.toggleFavorite(book.id),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => BookDetailScreen(book: book)),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _Summary extends StatelessWidget {
  const _Summary({required this.total, required this.favorites});

  final int total;
  final int favorites;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(
        children: [
          Text('$total buku', style: Theme.of(context).textTheme.titleSmall),
          const Spacer(),
          const Icon(Icons.favorite, size: 18),
          const SizedBox(width: 4),
          Text('$favorites favorit'),
        ],
      ),
    );
  }
}
