import 'package:flutter_test/flutter_test.dart';
import 'package:sesi14_optimalisasi_debugging/data/repositories/book_repository.dart';
import 'package:sesi14_optimalisasi_debugging/data/services/catalog_service.dart';
import 'package:sesi14_optimalisasi_debugging/ui/catalog/catalog_view_model.dart';

/// Server tiruan yang selalu gagal.
class OfflineService extends CatalogService {
  @override
  Future<String> fetchCatalogJson() async => throw Exception('tidak ada internet');
}

void main() {
  test('load() memuat 2.000 buku yang sudah urut A-Z', () async {
    final vm = CatalogViewModel(repository: BookRepository(service: CatalogService()));
    await vm.load();

    expect(vm.books, hasLength(2000));
    final titles = vm.books.map((b) => b.title.toLowerCase()).toList();
    expect(titles, orderedEquals([...titles]..sort()));
  });

  test('PERBAIKAN #3: books mengembalikan daftar yang sama, tidak diurutkan ulang', () async {
    final vm = CatalogViewModel(repository: BookRepository(service: CatalogService()));
    await vm.load();
    expect(identical(vm.books, vm.books), isTrue);
  });

  test('server gagal: error diisi dan loading berhenti', () async {
    final vm = CatalogViewModel(repository: BookRepository(service: OfflineService()));
    await vm.load();
    expect(vm.isLoading, isFalse);
    expect(vm.error, contains('tidak ada internet'));
  });

  test('toggleFavorite menambah lalu menghapus favorit', () {
    final vm = CatalogViewModel(repository: BookRepository(service: CatalogService()));
    vm.toggleFavorite('b1');
    expect(vm.isFavorite('b1'), isTrue);
    vm.toggleFavorite('b1');
    expect(vm.favoriteCount, 0);
  });
}
