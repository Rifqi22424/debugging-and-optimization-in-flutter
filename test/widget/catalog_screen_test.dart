import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sesi14_optimalisasi_debugging/data/repositories/book_repository.dart';
import 'package:sesi14_optimalisasi_debugging/data/services/catalog_service.dart';
import 'package:sesi14_optimalisasi_debugging/domain/models/book.dart';
import 'package:sesi14_optimalisasi_debugging/ui/catalog/book_tile.dart';
import 'package:sesi14_optimalisasi_debugging/ui/catalog/catalog_screen.dart';
import 'package:sesi14_optimalisasi_debugging/ui/catalog/catalog_view_model.dart';

/// ViewModel berisi 2.000 buku. Dibuang otomatis di akhir test (addTearDown),
/// kalau tidak, leak tracker melaporkan CatalogViewModel yang tidak di-dispose.
CatalogViewModel vmBerisi2000Buku() {
  final vm = CatalogViewModel(repository: BookRepository(service: CatalogService()))
    ..setBooks(fakeCatalog(2000).map(Book.fromJson).toList());
  addTearDown(vm.dispose);
  return vm;
}

void main() {
  testWidgets('BUG #3: dari 2.000 buku, hanya baris yang terlihat yang dibangun', (tester) async {
    await tester.pumpWidget(MaterialApp(home: CatalogScreen(viewModel: vmBerisi2000Buku())));

    final dibangun = find.byType(BookTile).evaluate().length;
    expect(dibangun, lessThan(30)); // versi berbug: 2000
  });

  testWidgets('menekan favorit menambah jumlah favorit', (tester) async {
    await tester.pumpWidget(MaterialApp(home: CatalogScreen(viewModel: vmBerisi2000Buku())));
    expect(find.text('0 favorit'), findsOneWidget);

    await tester.tap(find.byTooltip('Favorit').first);
    await tester.pump();

    expect(find.text('1 favorit'), findsOneWidget);
    expect(find.byIcon(Icons.favorite), findsNWidgets(2)); // ringkasan + baris pertama
  });
}
