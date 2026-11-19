import 'dart:convert';

/// Pengganti server perpustakaan. Mengembalikan data dengan jeda,
/// seperti panggilan HTTP di Sesi 6.
class CatalogService {
  /// Katalog lengkap dalam bentuk teks JSON (2.000 buku).
  Future<String> fetchCatalogJson() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return jsonEncode(fakeCatalog(2000));
  }

  /// Jumlah eksemplar yang sedang ada di rak. Butuh 1 detik.
  Future<int> fetchAvailableCopies(String bookId) async {
    await Future.delayed(const Duration(seconds: 1));
    return int.parse(bookId.substring(1)) % 4;
  }
}

const _openers = [
  'Analisis', 'Dasar-Dasar', 'Desain', 'Evaluasi', 'Implementasi', 'Konsep', 'Manajemen',
  'Metode', 'Optimasi', 'Panduan', 'Pemodelan', 'Penerapan', 'Pengantar', 'Perancangan',
  'Praktikum', 'Prinsip', 'Rekayasa', 'Studi Kasus', 'Teknik', 'Teori',
];
const _topics = [
  'Algoritma', 'Aplikasi Mobile', 'Basis Data', 'Data Mining', 'Grafika Komputer',
  'Internet of Things', 'Jaringan Komputer', 'Keamanan Siber', 'Kecerdasan Buatan',
  'Komputasi Awan', 'Antarmuka Pengguna', 'Pemrograman Flutter', 'Pemrograman Web',
  'Pengujian Perangkat Lunak', 'Sistem Informasi', 'Sistem Operasi', 'Statistika',
  'Struktur Data', 'Visi Komputer', 'Basis Data NoSQL',
];
const _endings = [
  'untuk Pemula', 'Tingkat Lanjut', 'dengan Studi Kasus Kampus', 'Edisi Revisi',
  'untuk Mahasiswa Teknik Informatika',
];
const _authors = [
  'Siti Rahmawati', 'Budi Santoso', 'Andi Pratama', 'Dewi Lestari', 'Rizky Maulana',
  'Nur Aini', 'Agus Setiawan', 'Maya Sari', 'Hendra Gunawan', 'Lina Marlina',
];

/// Membuat [count] data buku tiruan (maksimal 2.000) yang selalu sama.
List<Map<String, dynamic>> fakeCatalog(int count) => [for (var i = 0; i < count; i++) _fakeBook(i)];

Map<String, dynamic> _fakeBook(int i) {
  final r = (i * 7919 + 13) % 10007; // pengacak sederhana: penulis, tahun, dan rak bervariasi
  return {
    'id': 'b$i',
    'title': '${_openers[i % 20]} ${_topics[i ~/ 20 % 20]} ${_endings[i ~/ 400]}',
    'author': _authors[r % 10],
    'year': 2005 + r ~/ 10 % 20,
    'shelf': '${String.fromCharCode(65 + r ~/ 200 % 6)}-${r % 40 + 1}',
    'synopsis': i % 3 == 0 ? null : 'Buku ini membahas ${_topics[i ~/ 20 % 20]} untuk mahasiswa.',
  };
}
