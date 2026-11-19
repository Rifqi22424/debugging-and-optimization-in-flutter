import 'package:flutter_test/flutter_test.dart';
import 'package:sesi14_optimalisasi_debugging/data/repositories/book_repository.dart';
import 'package:sesi14_optimalisasi_debugging/domain/models/book.dart';

void main() {
  test('parseBooks membaca synopsis yang null', () {
    const body = '[{"id":"b1","title":"Basis Data","author":"Nur Aini",'
        '"year":2021,"shelf":"A-1","synopsis":null}]';
    final books = parseBooks(body);
    expect(books.single.title, 'Basis Data');
    expect(books.single.synopsis, isNull);
  });

  test('assert menolak tahun terbit yang tidak masuk akal (mode debug)', () {
    expect(
      () => Book(id: 'x', title: 'X', author: 'Y', year: 20, shelf: 'A-1'),
      throwsA(isA<AssertionError>()),
    );
  });
}
