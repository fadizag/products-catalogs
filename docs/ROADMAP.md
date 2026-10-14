# Roadmap

## Initial Flutter scaffold
- Arabic RTL UI based on the supplied three-screen mockups.
- Independent named datasets stored locally.
- Product name, barcode, brand, category, front/back/ingredients photos.
- Barcode scanner screen and manual entry.
- Local SQLite persistence for Android/Windows desktop (SQLite FFI is initialized for desktop).
- Captured photos resized to a maximum 1600px and JPEG quality 88.
- CSV import/export and OS share flow.

## Remaining before production
1. Generate/verify all Flutter platform runner scaffolding with `flutter create .` if required.
2. Implement web storage; web currently reports unsupported.
3. Review end-to-end barcode hand-off and edit-existing-product flows on device.
4. Bundle CSV and photo assets into a ZIP archive so image files transfer with a dataset; CSV exports alone only include paths.
5. Add background removal via a selected offline segmentation model or optional online service, with preview and original-photo preservation.
6. Add dataset backup/restore, duplicate-barcode UX and bulk editing.
7. Test camera permissions, database persistence, CSV round-trips and package compatibility on Android and Windows.

No builds, tests or CI workflows were run during setup.
