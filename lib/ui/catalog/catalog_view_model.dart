import 'package:flutter/foundation.dart';

import '../../data/repositories/book_repository.dart';
import '../../domain/book_sorter.dart';
import '../../domain/models/book.dart';

/// Logika layar katalog: memuat buku, mengurutkan, dan menyimpan favorit.
class CatalogViewModel extends ChangeNotifier {
  CatalogViewModel({required BookRepository repository}) : _repository = repository;

  final BookRepository _repository;

  bool isLoading = false;
  String? error;
  List<Book> _books = const [];
  final Set<String> _favorites = {};

  /// Sudah urut A-Z. Daftar yang sama dipakai di setiap build().
  List<Book> get books => _books;
  int get favoriteCount => _favorites.length;
  bool isFavorite(String id) => _favorites.contains(id);

  Future<void> load() async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      // PERBAIKAN #3 (bagian 1): urutkan SEKALI di sini, bukan di build().
      _books = sortByTitle(await _repository.loadCatalog());
    } catch (e) {
      error = 'Katalog gagal dimuat: $e';
    }
    isLoading = false;
    notifyListeners();
  }

  void toggleFavorite(String id) {
    if (!_favorites.remove(id)) _favorites.add(id);
    notifyListeners();
  }

  /// Untuk test dan layar pencarian: isi katalog tanpa memanggil repository.
  @visibleForTesting
  void setBooks(List<Book> books) {
    _books = sortByTitle(books);
    notifyListeners();
  }
}
