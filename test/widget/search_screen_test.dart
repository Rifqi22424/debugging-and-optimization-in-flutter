import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sesi14_optimalisasi_debugging/data/services/catalog_service.dart';
import 'package:sesi14_optimalisasi_debugging/domain/models/book.dart';
import 'package:sesi14_optimalisasi_debugging/ui/search/search_screen.dart';

// Untuk melihat test ini gagal, ganti SearchScreen dengan BuggySearchScreen.

final books = fakeCatalog(100).map(Book.fromJson).toList();

void main() {
  testWidgets('hasil muncul 300 ms setelah berhenti mengetik', (tester) async {
    await tester.pumpWidget(MaterialApp(home: SearchScreen(books: books)));
    await tester.enterText(find.byKey(const Key('kolom-cari')), 'algoritma');
    expect(find.byType(ListTile), findsNothing);

    await tester.pump(const Duration(milliseconds: 300));
    expect(find.byType(ListTile), findsWidgets);
  });

  // Leak tracker (dinyalakan di test/flutter_test_config.dart) memeriksa
  // controller yang tidak di-dispose. flutter_test sendiri memeriksa timer.
  testWidgets('BUG #4: menutup layar membuang controller dan timer', (tester) async {
    await tester.pumpWidget(MaterialApp(home: SearchScreen(books: books)));
    await tester.enterText(find.byKey(const Key('kolom-cari')), 'algoritma');

    // Layar ditutup sebelum timer 300 ms selesai.
    await tester.pumpWidget(const SizedBox());
  });
}
