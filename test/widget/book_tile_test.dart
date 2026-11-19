import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sesi14_optimalisasi_debugging/domain/models/book.dart';
import 'package:sesi14_optimalisasi_debugging/ui/catalog/book_tile.dart';

// Untuk melihat test ini gagal, ganti BookTile dengan BuggyBookTile
// (import 'package:sesi14_optimalisasi_debugging/buggy/buggy_book_tile.dart').

const judulPanjang = Book(
  id: 'b1',
  title: 'Teori dan Praktik Desain Antarmuka Aplikasi Mobile Jilid 3',
  author: 'Hendra Gunawan',
  year: 2021,
  shelf: 'C-12',
);

void main() {
  testWidgets('BUG #1: judul panjang tidak overflow di HP kecil (320 px)', (tester) async {
    // 1. Reproduksi: layar selebar HP kecil
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    // 2. Jalankan
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: BookTile(book: judulPanjang, isFavorite: false, onFavorite: () {}, onTap: () {}),
      ),
    ));

    // 3. Periksa: tidak ada error overflow, judul tetap tampil
    expect(tester.takeException(), isNull);
    expect(find.textContaining('Teori dan Praktik'), findsOneWidget);
  });
}
