import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../data/app_database.dart';
import '../data/product.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key, required this.datasetId, required this.onBarcode, required this.onManual});
  final String datasetId;
  final ValueChanged<String> onBarcode;
  final VoidCallback onManual;
  @override State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  final controller = MobileScannerController(detectionSpeed: DetectionSpeed.noDuplicates);
  bool scanned = false;
  Product? last;
  @override void dispose() { controller.dispose(); super.dispose(); }

  Future<void> detect(BarcodeCapture capture) async {
    if (scanned) return;
    final value = capture.barcodes.firstOrNull?.rawValue?.trim();
    if (value == null || value.isEmpty) return;
    scanned = true;
    await controller.stop();
    last = await AppDatabase.instance.productByBarcode(widget.datasetId, value);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(last == null ? 'تم التقاط الباركود: $value' : 'المنتج موجود: ${last!.name}')));
    widget.onBarcode(value);
  }

  Future<void> manual() async {
    final input = TextEditingController();
    final value = await showDialog<String>(context: context, builder: (ctx) => AlertDialog(
      title: const Text('إدخال الباركود يدويًا'),
      content: TextField(controller: input, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'الباركود')),
      actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')), FilledButton(onPressed: () => Navigator.pop(ctx, input.text.trim()), child: const Text('متابعة'))],
    ));
    if (value != null && value.isNotEmpty) widget.onBarcode(value);
  }

  @override Widget build(BuildContext context) => Padding(padding: const EdgeInsets.all(16), child: Column(children: [
    Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(28), child: Stack(fit: StackFit.expand, children: [
      MobileScanner(controller: controller, onDetect: detect),
      IgnorePointer(child: Center(child: Container(width: 260, height: 170, decoration: BoxDecoration(border: Border.all(color: const Color(0xFF2DD4A7), width: 3), borderRadius: BorderRadius.circular(18))))),
      const Positioned(bottom: 20, left: 0, right: 0, child: Text('وجّه الكاميرا نحو الباركود', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700))),
    ]))),
    const SizedBox(height: 12),
    Row(children: [Expanded(child: OutlinedButton.icon(onPressed: () => controller.toggleTorch(), icon: const Icon(Icons.flash_on), label: const Text('الفلاش'))), const SizedBox(width: 8), Expanded(child: OutlinedButton.icon(onPressed: manual, icon: const Icon(Icons.keyboard), label: const Text('إدخال يدوي')))]),
    const SizedBox(height: 10),
    Card(child: ListTile(leading: const Icon(Icons.qr_code_2), title: Text(last?.name ?? 'آخر منتج ممسوح'), subtitle: Text(last?.barcode ?? 'امسح باركودًا للبدء'), trailing: IconButton(onPressed: () { setState(() => scanned = false); controller.start(); }, icon: const Icon(Icons.refresh), tooltip: 'مسح منتج آخر'))),
  ]));
}
