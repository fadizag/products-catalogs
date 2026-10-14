import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'dataset.dart';
import 'product.dart';

class AppDatabase {
  AppDatabase._();
  static final instance = AppDatabase._();
  Database? _db;

  Future<void> open() async {
    if (_db != null) return;
    if (kIsWeb) {
      throw UnsupportedError('نسخة الويب غير مدعومة بعد؛ استخدم Android أو Windows حاليًا.');
    }
    final path = p.join((await getApplicationDocumentsDirectory()).path, 'products_catalogs.db');
    _db = await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute('CREATE TABLE datasets (id TEXT PRIMARY KEY, name TEXT NOT NULL, description TEXT NOT NULL DEFAULT "", created_at TEXT NOT NULL)');
      await db.execute('CREATE TABLE products (id TEXT PRIMARY KEY, dataset_id TEXT NOT NULL, name TEXT NOT NULL, barcode TEXT NOT NULL DEFAULT "", brand TEXT NOT NULL DEFAULT "", category TEXT NOT NULL DEFAULT "", front_image TEXT NOT NULL DEFAULT "", back_image TEXT NOT NULL DEFAULT "", ingredients_image TEXT NOT NULL DEFAULT "", created_at TEXT NOT NULL, updated_at TEXT NOT NULL, UNIQUE(dataset_id, barcode))');
      await db.execute('CREATE INDEX idx_products_dataset ON products(dataset_id)');
      await db.execute('CREATE INDEX idx_products_name ON products(name)');
      await db.insert('datasets', {'id': 'default-supermarket', 'name': 'منتجات السوبرماركت', 'description': 'مجموعة البيانات الأولى', 'created_at': DateTime.now().toIso8601String()});
    });
  }

  Database get db => _db!;
  Future<List<Dataset>> datasets() async => (await db.query('datasets', orderBy: 'created_at DESC')).map(Dataset.fromMap).toList();
  Future<void> saveDataset(Dataset dataset) async => db.insert('datasets', dataset.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  Future<List<Product>> products(String id, {String query = ''}) async {
    final q = query.trim();
    final rows = q.isEmpty
        ? await db.query('products', where: 'dataset_id=?', whereArgs: [id], orderBy: 'updated_at DESC')
        : await db.query('products', where: 'dataset_id=? AND (name LIKE ? OR barcode LIKE ? OR brand LIKE ?)', whereArgs: [id, '%$q%', '%$q%', '%$q%'], orderBy: 'updated_at DESC');
    return rows.map(Product.fromMap).toList();
  }
  Future<int> productCount(String id) async => Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM products WHERE dataset_id=?', [id])) ?? 0;
  Future<int> photoCount(String id) async => Sqflite.firstIntValue(await db.rawQuery("SELECT COUNT(*) FROM products WHERE dataset_id=? AND (front_image<>'' OR back_image<>'' OR ingredients_image<>'')", [id])) ?? 0;
  Future<Product?> productByBarcode(String id, String barcode) async {
    final rows = await db.query('products', where: 'dataset_id=? AND barcode=?', whereArgs: [id, barcode], limit: 1);
    return rows.isEmpty ? null : Product.fromMap(rows.first);
  }
  Future<void> saveProduct(Product product) async => db.insert('products', product.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  Future<void> deleteProduct(String id) async => db.delete('products', where: 'id=?', whereArgs: [id]);
}
