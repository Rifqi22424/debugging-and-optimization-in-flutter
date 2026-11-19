import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sesi14_optimalisasi_debugging/data/repositories/book_repository.dart';
import 'package:sesi14_optimalisasi_debugging/data/services/catalog_service.dart';
import 'package:sesi14_optimalisasi_debugging/domain/models/book.dart';
import 'package:sesi14_optimalisasi_debugging/ui/detail/book_detail_screen.dart';

// Untuk melihat test ini gagal, ganti BookDetailScreen dengan BuggyDetailScreen
// (import 'package:sesi14_optimalisasi_debugging/buggy/buggy_detail_screen.dart').

const denganSinopsis = Book(
  id: 'b2',
  title: 'Struktur Data',
  author: 'Budi Santoso',
  year: 2019,
  shelf: 'C-3',
  synopsis: 'Buku ini membahas struktur data untuk mahasiswa.',
);
const tanpaSinopsis = Book(id: 'b3', title: 'Basis Data', author: 'Nur Aini', year: 2020, shelf: 'A-3');

/// Layar detail dengan repository asli (data eksemplar datang setelah 1 detik).
Widget layarDetail(Book book) => Provider(
      create: (_) => BookRepository(service: CatalogService()),
      child: MaterialApp(home: BookDetailScreen(book: book)),
    );

void main() {
  testWidgets('jumlah eksemplar tampil setelah 1 detik', (tester) async {
    await tester.pumpWidget(layarDetail(denganSinopsis));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pump(const Duration(seconds: 1));
    expect(find.byKey(const Key('teks-eksemplar')), findsOneWidget);
    expect(find.text('2'), findsOneWidget); // b2 -> 2 % 4 = 2
  });

  testWidgets('BUG #2: layar ditutup sebelum data datang tidak memicu error', (tester) async {
    await tester.pumpWidget(layarDetail(denganSinopsis));

    // Pengguna menutup layar sebelum 1 detik selesai.
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1)); // data datang, layar sudah tidak ada

    expect(tester.takeException(), isNull);
  });

  testWidgets('BUG #5: buku tanpa sinopsis menampilkan teks pengganti', (tester) async {
    await tester.pumpWidget(layarDetail(tanpaSinopsis));

    expect(tester.takeException(), isNull);
    expect(find.text('Belum ada sinopsis untuk buku ini.'), findsOneWidget);
    await tester.pump(const Duration(seconds: 1)); // selesaikan pemuatan
  });
}
