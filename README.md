# StoryBloom (Story App)

Aplikasi Flutter untuk submission Story App Dicoding.

README ini sudah diperbarui untuk mendukung **Build Variant / Flavor** supaya aman untuk yang baru pertama kali menjalankan project.

## Ringkasan Fitur

- Auth: register, login, logout, session persistence.
- Story feed: list cerita dengan infinite scrolling pagination.
- Story detail: detail cerita + peta Leaflet jika ada lokasi.
- Add story: upload foto + deskripsi, dengan behavior berbeda per flavor.
- Localization: Bahasa Indonesia (`id`) dan English (`en`).
- Accessibility: semantics, tooltip, dan tap target yang layak.

## Build Variant (Free vs Paid)

Project ini punya 2 flavor:

- **free**
  - Add Story **tidak bisa memilih lokasi**.
  - Section lokasi tampil dalam mode locked + info upgrade.
  - AppBar menampilkan badge `FREE`.
- **paid**
  - Add Story bisa memilih lokasi lewat peta Leaflet.
  - Ada info lokasi aktif + kontrol pilih/ubah/hapus lokasi.
  - AppBar menampilkan badge `PAID`.
  - Payload upload bisa menyertakan `lat` dan `lon`.

### Mapping Entry Point

- `lib/main_free.dart` -> flavor **free**
- `lib/main_paid.dart` -> flavor **paid**
- `lib/main.dart` -> auto-detect dari `--flavor` (`FLUTTER_APP_FLAVOR`), fallback ke **paid**

Artinya, `flutter run --flavor free -t lib/main.dart` tetap terbaca sebagai free.
Kalau hanya menjalankan `flutter run` tanpa argumen, aplikasi akan jalan sebagai paid.

## Teknologi dan Paket

- Flutter (Material 3)
- `go_router` (routing)
- `provider` (state management)
- `http` (REST + multipart)
- `shared_preferences` (session + preferensi)
- `image_picker` (kamera/galeri)
- `cached_network_image` + `shimmer` (image loading UX)
- `flutter_map` + `latlong2` (Leaflet map)
- `geocoding` (reverse geocoding)
- `freezed` + `json_serializable` + `build_runner` (code generation)
- `intl` + `flutter_localizations` (lokalisasi)

## Persiapan Environment

Pastikan sudah terpasang:

- Flutter SDK (Dart constraint project: `^3.11.4`)
- Android Studio atau VS Code + Flutter extension
- Device fisik/emulator Android
- iOS simulator (khusus macOS)

Verifikasi:

```bash
flutter doctor -v
```

## Setup Project (Wajib Sebelum Run)

Jalankan dari root project:

```bash
flutter pub get
```

Generate object classes (code generation):

```bash
dart run build_runner build --delete-conflicting-outputs
```

Generate localization (jika ARB berubah):

```bash
flutter gen-l10n
```

## Menjalankan Aplikasi (Debug)

### Android - Free

```bash
flutter run --flavor free -t lib/main_free.dart
```

### Android - Paid

```bash
flutter run --flavor paid -t lib/main_paid.dart
```

### iOS (macOS) - Free

```bash
flutter run -d ios --flavor free -t lib/main_free.dart
```

### iOS (macOS) - Paid

```bash
flutter run -d ios --flavor paid -t lib/main_paid.dart
```

### Default Run (tanpa flavor)

```bash
flutter run
```

Default run ini akan memakai `lib/main.dart` (mode paid).

## Konfigurasi IDE untuk Build Variant

### VS Code

Project sudah menyertakan konfigurasi Run and Debug di file `.vscode/launch.json` untuk:

- `free_debug`, `free_profile`, `free_release`
- `paid_debug`, `paid_profile`, `paid_release`

Cara pakai:

1. Buka tab **Run and Debug**.
2. Pilih konfigurasi yang diinginkan (misalnya `free_debug`).
3. Klik **Start Debugging**.

### Android Studio

Jika menggunakan Android Studio, buat konfigurasi Flutter per flavor dari menu **Run > Edit Configurations**:

1. Tambah konfigurasi baru tipe **Flutter**.
2. Isi **Dart entrypoint** dengan salah satu berikut:
  - `lib/main_free.dart`
  - `lib/main_paid.dart`
3. Isi **Additional run args** sesuai flavor:
  - `--flavor free`
  - `--flavor paid`
4. Pilih mode build sesuai kebutuhan (debug/profile/release), lalu simpan.

## Build APK Debug per Flavor

Free:

```bash
flutter build apk --debug --flavor free -t lib/main_free.dart
```

Paid:

```bash
flutter build apk --debug --flavor paid -t lib/main_paid.dart
```

## Quality Check

```bash
flutter analyze
flutter test
```

## Perizinan Platform

- Android: internet, camera, dan location permission sudah dikonfigurasi.
- iOS: camera, photo library, dan location usage description sudah disiapkan.

## Troubleshooting Singkat

1. Flavor tidak sesuai (harusnya free tapi yang jalan paid)
- Paling aman: sertakan **keduanya** `--flavor` dan `-t`.
- Contoh aman: `flutter run --flavor free -t lib/main_free.dart`.
- Alternatif valid: `flutter run --flavor free -t lib/main.dart` (auto-detect flavor).

2. Error class generated tidak ditemukan
- Jalankan ulang:

```bash
dart run build_runner build --delete-conflicting-outputs
```

3. String localization baru belum muncul
- Jalankan ulang:

```bash
flutter gen-l10n
```

4. Build gagal setelah pull terbaru
- Jalankan urutan aman:

```bash
flutter clean
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter gen-l10n
flutter analyze
```

## Submission Notes

Untuk kebutuhan submission Dicoding:

- Jalankan `flutter clean` sebelum kompres project.
- Jangan jalankan build lagi setelah proses clean jika mengikuti instruksi submission.
