import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import '../data/app_database.dart';
import '../data/product.dart';
import '../services/image_service.dart';

class ProductFormPage extends StatefulWidget {
  const ProductFormPage({super.key, required this.datasetId, required this.datasetName, required this.onSaved, this.initialBarcode = ''});
  final String datasetId, datasetName, initialBarcode;
  final VoidCallback onSaved;
  @override State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final form = GlobalKey<FormState>();
  final name = TextEditingController(), barcode = TextEditingController(), brand = TextEditingController(), category = TextEditingController();
  String front = '', back = '', ingredients = '';
  bool saving = false;
  @override void initState() { super.initState(); barcode.text = widget.initialBarcode; }
  @override void dispose() { name.dispose(); barcode.dispose(); brand.dispose(); category.dispose(); super.dispose(); }

  Future<void> photo(String slot, {bool camera = true}) async {
    try {
      final path = await ImageService.captureAndOptimize(camera ? ImageSource.camera : ImageSource.gallery);
      if (path == null) return;
      setState(() { if (slot == 'front') { front = path; } else if (slot == 'back') { back = path; } else { ingredients = path; } });
    } catch (e) { if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('تعذّر حفظ الصورة: $e'))); }
  }

  Widget slot(String label, String path, String key) => Expanded(child: InkWell(
    onTap: () => showModalBottomSheet(context: context, builder: (ctx) => SafeArea(child: Wrap(children: [
      ListTile(title: const Text('التصوير بالكاميرا'), leading: const Icon(Icons.camera_alt), onTap: () { Navigator.pop(ctx); photo(key); }),
      ListTile(title: const Text('اختيار من المعرض'), leading: const Icon(Icons.photo_library), onTap: () { Navigator.pop(ctx); photo(key, camera: false); }),
      if (path.isNotEmpty) ListTile(title: const Text('حذف الصورة'), leading: const Icon(Icons.delete_outline), onTap: () { Navigator.pop(ctx); setState(() { if (key == 'front') { front = ''; } else if (key == 'back') { back = ''; } else { ingredients = ''; } }); }),
    ]))),
    child: Container(height: 104, margin: const EdgeInsets.only(left: 4), decoration: BoxDecoration(color: Colors.white, border: Border.all(color: const Color(0xFFD5DBE3)), borderRadius: BorderRadius.circular(14)), clipBehavior: Clip.antiAlias,
      child: path.isNotEmpty && !kIsWeb ? Image.file(File(path), fit: BoxFit.cover, errorBuilder: (_, __, ___) => Column(mainAxisAlignment: MainAxisAlignment.center, children: [const Icon(Icons.broken_image_outlined), Text(label)])) : Column(mainAxisAlignment: MainAxisAlignment.center, children: [const Icon(Icons.add_a_photo_outlined), Text(label, style: const TextStyle(fontSize: 12))]))));

  Future<void> save() async {
    if (!form.currentState!.validate()) return;
    setState(() => saving = true);
    try {
      final now = DateTime.now().toIso8601String();
      final old = barcode.text.trim().isEmpty ? null : await AppDatabase.instance.productByBarcode(widget.datasetId, barcode.text.trim());
      await AppDatabase.instance.saveProduct(Product(id: old?.id ?? const Uuid().v4(), datasetId: widget.datasetId, name: name.text.trim(), barcode: barcode.text.trim(), brand: brand.text.trim(), category: category.text.trim(), frontImage: front, backImage: back, ingredientsImage: ingredients, createdAt: old?.createdAt ?? now, updatedAt: now));
      if (mounted) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم حفظ المنتج محليًا'))); widget.onSaved(); }
    } catch (e) { if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('تعذّر الحفظ: $e'))); }
    finally { if (mounted) setState(() => saving = false); }
  }

  @override Widget build(BuildContext context) => SingleChildScrollView(padding: const EdgeInsets.all(18), child: Form(key: form, child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
    Card(child: ListTile(title: const Text('مجموعة البيانات'), subtitle: Text(widget.datasetName))),
    const SizedBox(height: 10),
    TextFormField(controller: barcode, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'الباركود', prefixIcon: Icon(Icons.qr_code_2))),
    const SizedBox(height: 12),
    Row(children: [slot('صورة أمامية', front, 'front'), slot('صورة خلفية', back, 'back'), slot('المكونات', ingredients, 'ingredients')]),
    const SizedBox(height: 12),
    TextFormField(controller: name, decoration: const InputDecoration(labelText: 'اسم المنتج'), validator: (v) => v == null || v.trim().isEmpty ? 'اسم المنتج مطلوب' : null),
    const SizedBox(height: 12), TextFormField(controller: brand, decoration: const InputDecoration(labelText: 'العلامة التجارية')),
    const SizedBox(height: 12), TextFormField(controller: category, decoration: const InputDecoration(labelText: 'الفئة')),
    const SizedBox(height: 14),
    const Card(child: ListTile(leading: Icon(Icons.offline_pin, color: Color(0xFF0B7A55)), title: Text('حفظ محلي أولًا'), subtitle: Text('يعمل دون إنترنت'))),
    FilledButton.icon(onPressed: saving ? null : save, icon: const Icon(Icons.save_outlined), label: Text(saving ? 'جارٍ الحفظ...' : 'حفظ المنتج')),
  ])));
}
