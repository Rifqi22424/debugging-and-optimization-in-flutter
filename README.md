# NusaPustaka — Sesi 14: Optimalisasi dan Debugging

Contoh aplikasi untuk mata kuliah **Pemrograman Perangkat Mobile (IF31033)**, Universitas Nusa Putra.

NusaPustaka adalah katalog perpustakaan kampus: 2.000 buku, detail buku dengan jumlah eksemplar di rak, favorit, dan pencarian. Aplikasi ini punya **dua versi**:

- `lib/main.dart` — versi yang sudah diperbaiki.
- `lib/main_buggy.dart` — versi 1.0 yang masih berisi **5 bug** (file di folder `lib/buggy/`).

Yang dipelajari adalah **cara menemukan dan memperbaiki bug**, lalu **mengunci perbaikannya dengan test**.

| Bug | Gejala | Kode berbug | Perbaikan | Test |
|---|---|---|---|---|
| **#1** | Garis kuning-hitam, judul terpotong | `buggy/buggy_book_tile.dart` | `Expanded` + `TextOverflow.ellipsis` | `test/widget/book_tile_test.dart` |
| **#2** | `setState() called after dispose()` | `buggy/buggy_detail_screen.dart` | `if (!mounted) return;` | `test/widget/book_detail_screen_test.dart` |
| **#3** | Daftar tersendat saat favorit ditekan | `buggy/buggy_catalog_page.dart` | Urutkan sekali di ViewModel + `ListView.builder` | `test/widget/catalog_screen_test.dart` |
| **#4** | Controller dan timer tidak dibuang | `buggy/buggy_search_screen.dart` | `dispose()` | `test/widget/search_screen_test.dart` |
| **#5** | Layar merah `Null check operator` | `buggy/buggy_detail_screen.dart` | `book.synopsis ?? '...'` | `test/widget/book_detail_screen_test.dart` |

Di kode, setiap bug ditandai komentar `BUG #n`, dan perbaikannya ditandai `PERBAIKAN #n`.

## Menjalankan

```bash
flutter pub get
flutter run                          # versi perbaikan
flutter run -t lib/main_buggy.dart   # versi berbug
flutter test                         # 20 test
```

Mengukur kinerja harus di **profile mode**, di **HP sungguhan** (profile mode tidak berjalan di emulator):

```bash
flutter run --profile -t lib/main_buggy.dart
```

## Struktur folder

```
lib/
├── main.dart                     # versi perbaikan
├── main_buggy.dart               # versi berbug
├── app.dart
├── config/dependencies.dart
├── domain/
│   ├── book_sorter.dart          # sortByTitle, searchBooks
│   └── models/book.dart          # + assert tahun terbit
├── data/
│   ├── services/catalog_service.dart       # server tiruan, 2.000 buku
│   └── repositories/book_repository.dart   # compute() + log()
├── ui/
│   ├── catalog/                  # PERBAIKAN #1 dan #3
│   │   ├── catalog_page.dart
│   │   ├── catalog_view_model.dart
│   │   ├── catalog_screen.dart
│   │   └── book_tile.dart
│   ├── detail/book_detail_screen.dart      # PERBAIKAN #2 dan #5
│   └── search/search_screen.dart           # PERBAIKAN #4
└── buggy/                        # BUG #1 sampai #5
test/
├── flutter_test_config.dart      # menyalakan leak tracker
├── unit/                         # 10 test
├── widget/                       # 8 test, minimal satu per bug
└── performance/                  # 2 test: versi berbug vs perbaikan
.github/workflows/flutter.yml     # CI: analyze + test di setiap push
```

## Resep: 6 langkah debugging

Setiap bug di proyek ini diselesaikan dengan langkah yang sama.

| Langkah | Pertanyaan | Alat |
|---|---|---|
| 1. Reproduksi | Bagaimana cara memunculkan bug setiap kali? | Catat langkahnya, ukuran layar, datanya |
| 2. Isolasi | Bagian kode mana yang terlibat? | Versi berbug vs perbaikan, test kecil |
| 3. Baca error | Apa kata pesan error dan stack trace? | Console, layar merah, baris pertama dari kode kita |
| 4. Hipotesis | Kenapa ini terjadi? | `debugPrint`, `log()`, breakpoint, DevTools |
| 5. Perbaiki | Perubahan terkecil apa yang membuatnya benar? | Editor, hot reload |
| 6. Kunci dengan test | Bagaimana agar bug ini tidak kembali? | Test yang merah di kode lama, hijau di kode baru |

## Hasil pengukuran BUG #3

`flutter test test/performance` (mode debug, laptop dosen; angka berubah setiap kali dijalankan, yang penting perbandingannya):

```
$ flutter test test/performance
Sortir 2.000 buku: 1.9 ms per kali
                 baris dibangun  build pertama  setelah favorit
Versi berbug               2000        4592 ms          1257 ms
Versi perbaikan              13          93 ms            21 ms
00:08 +2: All tests passed!
```

## Langkah praktik

### Langkah 1 — Siapkan proyek

```bash
git clone https://github.com/Rifqi22424/debugging-and-optimization-in-flutter.git
cd debugging-and-optimization-in-flutter
flutter pub get
flutter test
```

**Cek:** `flutter test` menampilkan `All tests passed!`, dan `flutter analyze` menampilkan `No issues found!` (padahal versi berbug punya 5 bug: analyzer tidak menemukan semua bug).

### Langkah 2 — BUG #1: membaca error overflow

Jalankan `flutter run -t lib/main_buggy.dart`. Baris katalog menampilkan garis kuning-hitam. Baca console: cari `A RenderFlex overflowed by ... pixels` dan baris `The relevant error-causing widget was: Row`, lalu klik nama file di bawahnya. Di `lib/buggy/buggy_book_tile.dart`, bungkus `Column` dengan `Expanded` dan beri `maxLines: 2, overflow: TextOverflow.ellipsis` pada judul.

**Cek:** setelah hot reload, garis kuning-hitam hilang dan judul panjang berakhir dengan `...`.

### Langkah 3 — BUG #5: membaca stack trace layar merah

Di versi berbug, buka buku yang belum punya sinopsis, misalnya **Analisis Algoritma untuk Pemula**. Layar menjadi merah. Di console, cari baris pertama stack trace yang menunjuk ke kode kita (`buggy_detail_screen.dart`). Ganti `book.synopsis!` dengan `book.synopsis ?? 'Belum ada sinopsis untuk buku ini.'`.

**Cek:** buku yang sama menampilkan teks pengganti, tidak ada layar merah.

### Langkah 4 — BUG #2: breakpoint dan `mounted`

Pasang breakpoint di baris `setState` dalam `_loadCopies()` (`buggy_detail_screen.dart`). Jalankan dengan debug (F5 di VS Code). Buka detail buku, lalu **segera** tekan Kembali. Saat program berhenti di breakpoint, lihat panel Variables: `mounted` bernilai `false`. Tambahkan `if (!mounted) return;` sebelum `setState`.

**Cek:** console tidak lagi menampilkan `setState() called after dispose()`.

### Langkah 5 — BUG #3: ukur dulu, baru optimalkan

```bash
flutter test test/performance
```

Bandingkan jumlah baris yang dibangun dan waktunya. Jika punya HP Android, jalankan `flutter run --profile -t lib/main_buggy.dart`, buka DevTools (tautannya tampil di terminal), tab **Performance**, lalu tekan favorit beberapa kali.

**Cek:** tabel menunjukkan versi berbug membangun 2000 baris, versi perbaikan di bawah 30 baris. Di DevTools, frame versi berbug ditandai merah (lebih dari 16 ms).

### Langkah 6 — BUG #4: test yang mengunci perbaikan

Di `test/widget/search_screen_test.dart`, ganti sementara `SearchScreen` dengan `BuggySearchScreen` (import `package:sesi14_optimalisasi_debugging/buggy/buggy_search_screen.dart`), lalu jalankan test-nya.

**Cek:** test merah dengan pesan `A Timer is still pending even after the widget tree was disposed`. Tambahkan `dispose()` yang memanggil `_debounce?.cancel()` dan `_controller.dispose()` di `BuggySearchScreen`, test hijau lagi. Kembalikan test ke `SearchScreen`.

## CI dengan GitHub Actions

File `.github/workflows/flutter.yml` menjalankan `flutter analyze` dan `flutter test` setiap kali ada push ke `main` atau pull request. Hasilnya terlihat di tab **Actions** repository: centang hijau jika semua lulus, silang merah jika ada yang gagal.

## Troubleshooting

| Masalah | Penyebab | Solusi |
|---|---|---|
| `A RenderFlex overflowed by N pixels` | Isi `Row`/`Column` lebih besar dari layar | `Expanded`/`Flexible`, `maxLines`, `TextOverflow.ellipsis` |
| `setState() called after dispose()` | `setState` setelah `await`, layar sudah ditutup | `if (!mounted) return;` sebelum `setState` |
| `Null check operator used on a null value` | `!` pada nilai yang ternyata null | Pakai `??` atau periksa null dulu |
| `A Timer is still pending even after the widget tree was disposed` | Timer tidak dibatalkan di `dispose()` | `_timer?.cancel()` di `dispose()` |
| `notDisposed: TextEditingController` (leak tracker) | Controller tidak di-dispose | `_controller.dispose()` di `dispose()` |
| Aplikasi tersendat, tetapi hanya di mode debug | Mode debug memang lambat | Ukur dengan `flutter run --profile` di HP sungguhan |
| Profile mode tidak bisa di emulator | Profile mode butuh perangkat fisik | Pakai HP Android dengan USB debugging |
