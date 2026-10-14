# Roadmap

## In current scaffold
- Arabic RTL UI based on the supplied three-screen mockups.
- Multiple named datasets stored locally.
- Product details: name, barcode, brand, category, front/back/ingredients photos.
- Barcode scanning screen and manual barcode entry.
- Local SQLite persistence for Android/desktop.
- Photo resize to max 1600px and JPEG quality 88.
- CSV import/export and share action.

## Remaining before production
1. Generate/verify native Flutter runner scaffolding with `flutter create .` if required.
2. Implement a web-compatible database adapter; this scaffold targets Android/Windows first.
3. Pass the scanned/manual barcode into the product form automatically.
4. Bundle CSV and photo assets into ZIP for transferring a dataset with images.
5. Add background removal using a chosen offline segmentation model or optional online API, with preview and preservation of the original photo.
6. Add dataset backup/restore, duplicate barcode collision handling and bulk edits.
7. Exercise camera permissions and package compatibility locally on Android and Windows.

No build or tests were run while preparing this scaffold.
