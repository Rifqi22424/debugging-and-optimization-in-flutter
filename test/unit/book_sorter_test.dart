import 'package:flutter_test/flutter_test.dart';
import 'package:sesi14_optimalisasi_debugging/domain/book_sorter.dart';
import 'package:sesi14_optimalisasi_debugging/domain/models/book.dart';

Book buku(String title, [String author = 'Siti Rahmawati']) =>
    Book(id: title, title: title, author: author, year: 2020, shelf: 'A-1');

void main() {
  group('sortByTitle', () {
    test('mengurutkan A-Z tanpa membedakan huruf besar dan kecil', () {
      final hasil = sortByTitle([buku('basis Data'), buku('Algoritma'), buku('Cloud')]);
      expect(hasil.map((b) => b.title), ['Algoritma', 'basis Data', 'Cloud']);
    });

    test('daftar asli tidak diubah', () {
      final asli = [buku('B'), buku('A')];
      sortByTitle(asli);
      expect(asli.first.title, 'B');
    });
  });

  group('searchBooks', () {
    final daftar = [buku('Pengantar Flutter', 'Budi Santoso'), buku('Basis Data', 'Dewi Lestari')];

    test('mencari di judul dan penulis, tanpa membedakan huruf besar', () {
      expect(searchBooks(daftar, 'FLUTTER'), hasLength(1));
      expect(searchBooks(daftar, 'dewi').single.title, 'Basis Data');
    });

    test('kata kunci kosong tidak mengembalikan apa pun', () {
      expect(searchBooks(daftar, '   '), isEmpty);
    });
  });
}
