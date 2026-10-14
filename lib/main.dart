import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'data/app_database.dart';
import 'ui/app_shell.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb && (defaultTargetPlatform == TargetPlatform.windows || defaultTargetPlatform == TargetPlatform.linux || defaultTargetPlatform == TargetPlatform.macOS)) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
  await AppDatabase.instance.open();
  runApp(const ProductsCatalogsApp());
}

class ProductsCatalogsApp extends StatelessWidget {
  const ProductsCatalogsApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'قاعدة بيانات المنتجات', debugShowCheckedModeBanner: false,
    theme: ThemeData(useMaterial3: true, colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0B7A55)), scaffoldBackgroundColor: const Color(0xFFF3F5F8)),
    home: const Directionality(textDirection: TextDirection.rtl, child: AppShell()),
  );
}
