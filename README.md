# Products Catalogs

An offline-first Flutter app for building reusable product datasets with barcode capture, product photos, dataset management, CSV import/export, and share support.

## Current status
The repository was initialized with the first Flutter scaffold. See `docs/ROADMAP.md` for what's implemented and what still needs validation. The UI is based on the supplied Arabic RTL mockups.

## Main features in scaffold
- Arabic RTL dataset screens
- Local SQLite storage for named datasets and products
- Barcode scanning screen and manual barcode entry
- Product name, barcode, brand, category, front/back/ingredients photos
- Camera/gallery image capture with resize and JPEG compression
- CSV import/export and share flow

## Setup
Requires Flutter SDK. Run `flutter pub get`, then create/verify platform runner files as needed with `flutter create .`, and launch the target platform.

**Important:** This first scaffold was not built or tested in this environment. ZIP export of images, background removal, complete web storage, and end-to-end barcode hand-off are still listed in the roadmap and should not be treated as completed.