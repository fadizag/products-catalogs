import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';

class ImageService {
  static Future<String?> captureAndOptimize(ImageSource source) async {
    final picked = await ImagePicker().pickImage(source: source, imageQuality: 95);
    if (picked == null) return null;
    return optimize(picked.path);
  }

  static Future<String> optimize(String sourcePath) async {
    final bytes = await File(sourcePath).readAsBytes();
    final decoded = img.decodeImage(bytes);
    if (decoded == null) throw const FormatException('تعذّر قراءة الصورة');
    final resized = (decoded.width > 1600 || decoded.height > 1600)
        ? img.copyResize(decoded, width: decoded.width >= decoded.height ? 1600 : null, height: decoded.height > decoded.width ? 1600 : null)
        : decoded;
    final jpg = img.encodeJpg(resized, quality: 88);
    final dir = await getApplicationDocumentsDirectory();
    final photosDir = Directory(p.join(dir.path, 'product_photos'));
    if (!await photosDir.exists()) await photosDir.create(recursive: true);
    final file = File(p.join(photosDir.path, '${DateTime.now().microsecondsSinceEpoch}.jpg'));
    await file.writeAsBytes(jpg, flush: true);
    return file.path;
  }
}
