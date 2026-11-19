import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../ui/catalog/catalog_view_model.dart';
import 'buggy_book_tile.dart';
import 'buggy_detail_screen.dart';
import 'buggy_search_screen.dart';

/// Halaman katalog versi 1.0. Hanya build() di BuggyCatalogScreen yang berbeda.
class BuggyCatalogPage extends StatefulWidget {
  const BuggyCatalogPage({super.key});

  @override
  State<BuggyCatalogPage> createState() => _BuggyCatalogPageState();
}

class _BuggyCatalogPageState extends State<BuggyCatalogPage> {
  late final CatalogViewModel _viewModel = CatalogViewModel(repository: context.read())..load();

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BuggyCatalogScreen(viewModel: _viewModel);
}

/// Salinan CatalogScreen versi 1.0 yang berisi BUG #3.
/// Bandingkan dengan lib/ui/catalog/catalog_screen.dart (PERBAIKAN #3).
class BuggyCatalogScreen extends StatelessWidget {
  const BuggyCatalogScreen({super.key, required this.viewModel});

  final CatalogViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NusaPustaka (bug)'),
        actions: [
          IconButton(
            tooltip: 'Cari',
            icon: const Icon(Icons.search),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => BuggySearchScreen(books: viewModel.books)),
            ),
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: viewModel,
        builder: (context, _) {
          if (viewModel.isLoading) return const Center(child: CircularProgressIndicator());

          // BUG #3a: mengurutkan 2.000 buku di dalam build(). Diulang setiap
          // kali layar dibangun ulang, misalnya setiap tombol favorit ditekan.
          final books = [...viewModel.books]
            ..sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));

          // BUG #3b: Column di dalam SingleChildScrollView membangun dan
          // mengatur letak SEMUA 2.000 baris, termasuk yang tidak terlihat.
          return SingleChildScrollView(
            child: Column(
              children: [
                for (final book in books)
                  BuggyBookTile(
                    book: book,
                    isFavorite: viewModel.isFavorite(book.id),
                    onFavorite: () => viewModel.toggleFavorite(book.id),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => BuggyDetailScreen(book: book)),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
