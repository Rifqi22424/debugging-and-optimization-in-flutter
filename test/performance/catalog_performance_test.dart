import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sesi14_optimalisasi_debugging/buggy/buggy_book_tile.dart';
import 'package:sesi14_optimalisasi_debugging/buggy/buggy_catalog_page.dart';
import 'package:sesi14_optimalisasi_debugging/data/repositories/book_repository.dart';
import 'package:sesi14_optimalisasi_debugging/data/services/catalog_service.dart';
import 'package:sesi14_optimalisasi_debugging/domain/book_sorter.dart';
import 'package:sesi14_optimalisasi_debugging/domain/models/book.dart';
import 'package:sesi14_optimalisasi_debugging/ui/catalog/book_tile.dart';
import 'package:sesi14_optimalisasi_debugging/ui/catalog/catalog_screen.dart';
import 'package:sesi14_optimalisasi_debugging/ui/catalog/catalog_view_model.dart';

// UKUR DULU, BARU OPTIMALKAN.
// Membandingkan katalog versi berbug (BUG #3) dengan versi perbaikan.
// Angka dari flutter test (mode debug, di laptop), bukan dari HP dalam
// profile mode. Pakai untuk MEMBANDINGKAN, bukan sebagai angka mutlak.

final books = fakeCatalog(2000).map(Book.fromJson).toList();

CatalogViewModel vmBerisi2000Buku() {
  final vm = CatalogViewModel(repository: BookRepository(service: CatalogService()))..setBooks(books);
  addTearDown(vm.dispose);
  return vm;
}

/// Menampilkan [screen], menekan favorit sekali, dan mengukur waktunya.
Future<({int tiles, int firstMs, int rebuildMs})> ukur(
  WidgetTester tester,
  CatalogViewModel vm,
  Widget screen,
  Type tileType,
) async {
  // Tinggi seperti HP (844), tetapi lebar 1400 supaya judul panjang tidak
  // overflow (BUG #1). Jadi yang terukur hanya BUG #3.
  tester.view.physicalSize = const Size(1400, 844);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final first = Stopwatch()..start();
  await tester.pumpWidget(MaterialApp(home: screen));
  first.stop();

  final rebuild = Stopwatch()..start();
  vm.toggleFavorite(vm.books.first.id); // memicu build() ulang
  await tester.pump();
  rebuild.stop();

  return (
    tiles: find.byType(tileType, skipOffstage: false).evaluate().length,
    firstMs: first.elapsedMilliseconds,
    rebuildMs: rebuild.elapsedMilliseconds,
  );
}

void main() {
  test('mengurutkan 2.000 buku', () {
    sortByTitle(books); // pemanasan
    final sw = Stopwatch()..start();
    for (var i = 0; i < 10; i++) {
      sortByTitle(books);
    }
    debugPrint('Sortir 2.000 buku: ${(sw.elapsedMicroseconds / 10 / 1000).toStringAsFixed(1)} ms per kali');
  });

  testWidgets('katalog berbug vs katalog perbaikan', (tester) async {
    final vmBug = vmBerisi2000Buku();
    final bug = await ukur(tester, vmBug, BuggyCatalogScreen(viewModel: vmBug), BuggyBookTile);

    await tester.pumpWidget(const SizedBox());
    final vmOk = vmBerisi2000Buku();
    final ok = await ukur(tester, vmOk, CatalogScreen(viewModel: vmOk), BookTile);

    debugPrint('                 baris dibangun  build pertama  setelah favorit');
    debugPrint('Versi berbug     ${bug.tiles.toString().padLeft(14)}  ${'${bug.firstMs} ms'.padLeft(13)}  ${'${bug.rebuildMs} ms'.padLeft(15)}');
    debugPrint('Versi perbaikan  ${ok.tiles.toString().padLeft(14)}  ${'${ok.firstMs} ms'.padLeft(13)}  ${'${ok.rebuildMs} ms'.padLeft(15)}');

    expect(bug.tiles, 2000);
    expect(ok.tiles, lessThan(30));
    expect(ok.rebuildMs, lessThan(bug.rebuildMs));
  });
}
