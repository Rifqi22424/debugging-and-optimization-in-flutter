import 'models/book.dart';

/// Mengurutkan buku berdasarkan judul (A-Z), tanpa membedakan huruf besar/kecil.
///
/// Untuk 2.000 buku, fungsi ini melakukan puluhan ribu perbandingan.
/// Panggil SEKALI saat data dimuat, jangan di dalam build() (lihat BUG #3).
List<Book> sortByTitle(List<Book> books) {
  return [...books]..sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
}

/// Mencari buku yang judul atau penulisnya memuat [query].
List<Book> searchBooks(List<Book> books, String query) {
  final q = query.trim().toLowerCase();
  if (q.isEmpty) return const [];
  return books
      .where((b) => b.title.toLowerCase().contains(q) || b.author.toLowerCase().contains(q))
      .toList();
}
