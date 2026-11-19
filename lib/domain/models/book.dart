/// Satu judul buku di katalog perpustakaan kampus.
class Book {
  final String id;
  final String title;
  final String author;
  final int year;
  final String shelf; // lokasi rak, misalnya "B-12"
  final String? synopsis; // boleh kosong: tidak semua buku punya sinopsis

  const Book({
    required this.id,
    required this.title,
    required this.author,
    required this.year,
    required this.shelf,
    this.synopsis,
  }) : assert(year > 1900, 'Tahun terbit tidak masuk akal'); // assert hanya aktif di mode debug

  factory Book.fromJson(Map<String, dynamic> json) => Book(
        id: json['id'] as String,
        title: json['title'] as String,
        author: json['author'] as String,
        year: json['year'] as int,
        shelf: json['shelf'] as String,
        synopsis: json['synopsis'] as String?,
      );
}
