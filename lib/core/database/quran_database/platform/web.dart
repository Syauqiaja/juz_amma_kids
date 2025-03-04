import 'package:drift/drift.dart';
import 'package:drift/wasm.dart';
import 'package:flutter/services.dart';

QueryExecutor createDatabaseConnection(String databaseName) {
    return DatabaseConnection.delayed(Future(() async {
      final database = await WasmDatabase.open(
        databaseName: databaseName,
        sqlite3Uri: Uri.parse('sqlite3.wasm'),
        driftWorkerUri: Uri.parse('drift_worker.js'),
        initializeDatabase: () async {
          final blob = await rootBundle.load('assets/quran-db.db');
          final buffer = blob.buffer;
          return buffer.asUint8List(blob.offsetInBytes, blob.lengthInBytes);
        },
      );
      if (database.missingFeatures.isNotEmpty) {
      // Depending how central local persistence is to your app, you may want
      // to show a warning to the user if only unrealiable implemetentations
      // are available.
      print('Using ${database.chosenImplementation} due to missing browser '
          'features: ${database.missingFeatures}');
    }
      return database.resolvedExecutor;
    }));
  }