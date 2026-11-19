import 'dart:async';

import 'package:leak_tracker_flutter_testing/leak_tracker_flutter_testing.dart';

/// Dijalankan otomatis sebelum setiap file test.
/// Menyalakan leak tracker: objek yang lupa di-dispose membuat test gagal.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  LeakTesting.enable();
  await testMain();
}
