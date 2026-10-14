# Products Catalogs

Public Arabic RTL product dataset builder for supermarket and retail products.

## Use without local development
The browser PWA lives in `docs/` and is intended for GitHub Pages:

- Expected app URL: https://fadizag.github.io/products-catalogs/
- Repository: https://github.com/fadizag/products-catalogs
- Source: `docs/index.html`, `docs/app.js`, `docs/sw.js`

The PWA stores datasets, product fields and image blobs in browser IndexedDB. It supports product creation/edit/delete, multiple datasets, camera photo capture or gallery selection, JPEG resizing/compression, barcode scanning where the browser supports `BarcodeDetector`, manual barcode entry, CSV import/export, native share where supported, JSON backup/restore including images, and service-worker caching for repeat/offline access after the first successful load.

## Deployment
A GitHub Actions workflow in `.github/workflows/deploy-pages.yml` deploys the `docs/` directory to GitHub Pages after changes to `main`. If Pages has not yet been enabled for this repository, open **Settings → Pages** and select **GitHub Actions** as the build and deployment source. Then open the workflow's run page to see deployment status.

## Known limitations
- Background removal is not implemented yet; product photos are resized and compressed with a white canvas.
- CSV cannot carry image files. Use **JSON backup** to transfer images and product data between browser installations.
- Barcode auto-detection depends on browser support; manual entry remains available.
- Browser data belongs to that browser/device. Export backups before clearing browser storage or switching devices.
- The Flutter Android/Windows scaffold is separate and has not been built or tested here.

No local build or test was run during repository editing.
