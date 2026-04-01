# StoryBloom (Story App)

Aplikasi Flutter untuk submission Story App Dicoding dengan fokus pada:

- Auth (register, login, logout) dengan session persistence.
- Daftar cerita, detail cerita, dan upload cerita baru (foto + deskripsi).
- Localization (Bahasa Indonesia dan English).
- Accessibility (semantics, tooltip aksesibel, tap target yang layak).
- UI modern dengan state loading/error/empty yang jelas.

## Fitur Utama

1. Autentikasi
- Register akun baru.
- Login akun existing.
- Session token disimpan lokal agar tetap login saat app dibuka ulang.
- Logout dengan konfirmasi.

2. Story Feed
- Menampilkan daftar cerita dari API (urut terbaru).
- Pull-to-refresh untuk memuat ulang.
- Status loading (shimmer), error, dan empty state.

3. Story Detail
- Menampilkan detail cerita berdasarkan ID.
- Hero transition dari list ke detail.
- Menampilkan deskripsi, waktu publikasi, serta lokasi (jika tersedia).

4. Add Story
- Pilih gambar dari kamera atau galeri.
- Validasi ukuran gambar maksimal 1MB.
- Upload multipart ke endpoint story.
- Setelah upload sukses, daftar cerita otomatis di-refresh.

5. Localization (l10n)
- Dukungan bahasa: `id` dan `en`.
- Pergantian bahasa dari UI (tersimpan di local storage).
- String dikelola via ARB dan generated localization.

6. Accessibility (a11y)
- Semantics pada komponen penting (kartu cerita, gambar, preview).
- Tooltip untuk aksi ikon termasuk show/hide password.
- Ukuran tap target tombol toolbar ditingkatkan agar lebih ramah akses.

## Teknologi dan Paket

- Flutter (Material 3)
- `go_router` (declarative routing)
- `provider` (state management)
- `http` (REST API + multipart)
- `shared_preferences` (session dan preferensi bahasa)
- `image_picker` (kamera/galeri)
- `cached_network_image` + `shimmer` (image loading UX)
- `intl` + `flutter_localizations` (lokalisasi)

## Struktur Ringkas

```text
lib/
	app/                 # App root, router, app-level viewmodel
	core/                # Constants, storage, theme, errors
	features/
		auth/              # Auth data + presentation
		story/             # Story data + presentation
	shared/widgets/      # Reusable UI widgets
	l10n/                # ARB dan generated localization
```

## API

- Base URL: `https://story-api.dicoding.dev/v1`
- Endpoint utama:
	- `POST /register`
	- `POST /login`
	- `GET /stories` (Bearer token)
	- `GET /stories/:id` (Bearer token)
	- `POST /stories` multipart (Bearer token)

Catatan:
- Tidak menggunakan endpoint guest.
- Token hasil login digunakan untuk endpoint protected.

## Persiapan Environment

Pastikan sudah terpasang:

- Flutter SDK (dengan Dart yang memenuhi constraint `^3.11.4`)
- Android Studio atau VS Code + Flutter extension
- Device fisik/emulator Android atau iOS simulator

Verifikasi instalasi:

```bash
flutter doctor
```

## Cara Setup dan Menjalankan

1. Clone repository dan masuk ke folder project.
2. Install dependencies:

```bash
flutter pub get
```

3. Generate localization (jika diperlukan setelah update ARB):

```bash
flutter gen-l10n
```

4. Jalankan aplikasi:

```bash
flutter run
```

## Quality Check

Jalankan analisis statis:

```bash
flutter analyze
```

Jalankan test:

```bash
flutter test
```

## Perizinan Platform

- Android: internet + camera permission sudah dikonfigurasi.
- iOS: camera dan photo library usage description sudah disiapkan.

## Submission Notes

Untuk kebutuhan submission Dicoding:

- Jalankan `flutter clean` sebelum kompres project.
- Jangan jalankan build lagi setelah proses clean jika mengikuti instruksi submission.
