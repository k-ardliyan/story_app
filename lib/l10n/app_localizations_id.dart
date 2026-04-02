// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get appName => 'StoryBloom';

  @override
  String get loginTitle => 'Selamat Datang';

  @override
  String get loginSubtitle => 'Masuk untuk lanjut berbagi cerita belajar.';

  @override
  String get registerTitle => 'Buat Akun';

  @override
  String get registerSubtitle =>
      'Gabung StoryBloom dan mulai berbagi sekarang.';

  @override
  String get nameLabel => 'Nama';

  @override
  String get emailLabel => 'Email';

  @override
  String get passwordLabel => 'Kata Sandi';

  @override
  String get loginButton => 'Masuk';

  @override
  String get registerButton => 'Daftar';

  @override
  String get goToRegister => 'Belum punya akun? Daftar';

  @override
  String get goToLogin => 'Sudah punya akun? Masuk';

  @override
  String get homeTitle => 'Daftar Cerita';

  @override
  String get addStoryTitle => 'Tambah Cerita';

  @override
  String get storyDetailTitle => 'Detail Cerita';

  @override
  String get descriptionLabel => 'Deskripsi';

  @override
  String get descriptionHint => 'Ceritakan momen belajarmu...';

  @override
  String get photoLabel => 'Foto';

  @override
  String get photoPlaceholder => 'Belum ada foto dipilih';

  @override
  String get pickFromCamera => 'Kamera';

  @override
  String get pickFromGallery => 'Galeri';

  @override
  String get uploadStoryButton => 'Unggah Cerita';

  @override
  String get refreshTooltip => 'Muat Ulang';

  @override
  String get showPasswordTooltip => 'Tampilkan kata sandi';

  @override
  String get hidePasswordTooltip => 'Sembunyikan kata sandi';

  @override
  String get languageButton => 'Bahasa';

  @override
  String get languageSheetTitle => 'Pilih bahasa aplikasi';

  @override
  String get languageSheetMessage =>
      'Pilih bahasa yang ingin digunakan di StoryBloom.';

  @override
  String get languageEnglish => 'Inggris';

  @override
  String get languageIndonesian => 'Bahasa Indonesia';

  @override
  String get logoutButton => 'Keluar';

  @override
  String get logoutSheetTitle => 'Keluar dari sesi ini?';

  @override
  String get logoutSheetMessage =>
      'Anda bisa masuk kembali kapan saja untuk melanjutkan cerita.';

  @override
  String get stayLoggedInButton => 'Tetap Masuk';

  @override
  String get errorTitle => 'Terjadi kesalahan';

  @override
  String get retryButton => 'Coba Lagi';

  @override
  String get emptyStateTitle => 'Tidak ada data';

  @override
  String get emptyStoriesTitle => 'Belum ada cerita';

  @override
  String get emptyStoriesMessage =>
      'Jadilah yang pertama membagikan cerita belajarmu.';

  @override
  String get emailRequiredError => 'Email wajib diisi';

  @override
  String get invalidEmailError => 'Format email tidak valid';

  @override
  String get passwordRequiredError => 'Kata sandi wajib diisi';

  @override
  String get passwordMinError => 'Kata sandi minimal 8 karakter';

  @override
  String get nameRequiredError => 'Nama wajib diisi';

  @override
  String get descriptionRequiredError => 'Deskripsi wajib diisi';

  @override
  String get photoRequiredError => 'Foto wajib dipilih';

  @override
  String get photoTooLargeError => 'Ukuran foto harus kurang dari 1MB';

  @override
  String get photoPickFailedError => 'Gagal memilih foto';

  @override
  String get offlineError =>
      'Tidak ada koneksi internet. Periksa koneksi lalu coba lagi.';

  @override
  String get requestTimeoutError =>
      'Permintaan memakan waktu terlalu lama. Silakan coba lagi.';

  @override
  String get sessionExpiredError =>
      'Sesi Anda sudah berakhir. Silakan masuk kembali.';

  @override
  String get unauthorizedError => 'Email atau kata sandi belum sesuai.';

  @override
  String get forbiddenError =>
      'Anda tidak memiliki izin untuk melakukan tindakan ini.';

  @override
  String get notFoundError => 'Data yang Anda cari tidak ditemukan.';

  @override
  String get tooManyRequestsError =>
      'Terlalu banyak percobaan. Tunggu sebentar lalu coba lagi.';

  @override
  String get serverError =>
      'Layanan sedang bermasalah. Silakan coba beberapa saat lagi.';

  @override
  String get badRequestError =>
      'Data yang dikirim belum valid. Periksa kembali input Anda.';

  @override
  String get serviceUnavailableError =>
      'Layanan sedang tidak tersedia. Silakan coba lagi nanti.';

  @override
  String get genericError => 'Terjadi kesalahan yang tidak terduga.';

  @override
  String get registerSuccessMessage => 'Pendaftaran berhasil. Silakan masuk.';

  @override
  String get uploadSuccessMessage => 'Cerita berhasil diunggah.';

  @override
  String get locationLabel => 'Lokasi';

  @override
  String get locationPickerTitle => 'Pilih Lokasi';

  @override
  String get saveLocationButton => 'Simpan';

  @override
  String get mapTapInstruction => 'Ketuk peta atau gunakan lokasi GPS kamu.';

  @override
  String get locationNotSelectedMessage => 'Belum ada lokasi dipilih.';

  @override
  String selectedCoordinatesLabel(String latitude, String longitude) {
    return 'Koordinat: $latitude, $longitude';
  }

  @override
  String get unknownAddressLabel => 'Alamat tidak tersedia';

  @override
  String get pickLocationFromMapButton => 'Pilih Lokasi';

  @override
  String get changeLocationButton => 'Ubah Lokasi';

  @override
  String get clearLocationButton => 'Hapus Lokasi';

  @override
  String get locationDisabledInFreeMessage =>
      'Pin lokasi belum tersedia di mode FREE.';

  @override
  String get paidFlavorBadge => 'PAID';

  @override
  String get freeFlavorBadge => 'FREE';

  @override
  String get locationEnabledForPaidTitle => 'Mode PAID aktif';

  @override
  String get locationEnabledForPaidDescription =>
      'Kamu bisa menandai lokasi dari peta atau GPS untuk cerita ini.';

  @override
  String get locationLockedForFreeTitle => 'Mode FREE aktif';

  @override
  String get locationLockedForFreeDescription =>
      'Fitur pin lokasi masih terkunci di mode ini.';

  @override
  String get modeDifferenceSheetTitle => 'Apa beda mode FREE dan PAID?';

  @override
  String get modeDifferenceFreeTitle => 'FREE';

  @override
  String get modeDifferenceFreeDescription =>
      'Kamu bisa upload cerita dengan foto dan deskripsi.';

  @override
  String get modeDifferencePaidTitle => 'PAID';

  @override
  String get modeDifferencePaidDescription =>
      'Semua fitur FREE ditambah pin lokasi dari peta/GPS.';

  @override
  String get locationModeReadySummary => 'Fitur lokasi aktif';

  @override
  String get locationModeLockedSummary => 'Fitur lokasi terkunci';

  @override
  String get locationModeTapHint => 'Ketuk untuk melihat detail';

  @override
  String get seeModeDifferenceButton => 'Lihat perbedaan fitur';

  @override
  String get selectedLocationPreviewTitle => 'Pratinjau Lokasi Terpilih';

  @override
  String get useMyLocationButton => 'Gunakan Lokasi Saya';

  @override
  String get findingMyLocationLabel => 'Mencari lokasi kamu...';

  @override
  String get locationServiceDisabledMessage =>
      'Aktifkan layanan lokasi terlebih dahulu.';

  @override
  String get locationPermissionDeniedMessage =>
      'Izin lokasi diperlukan untuk menggunakan GPS.';

  @override
  String get locationPermissionDeniedForeverMessage =>
      'Izin lokasi diblokir. Aktifkan kembali lewat pengaturan aplikasi.';

  @override
  String get failedToGetCurrentLocationMessage =>
      'Gagal mengambil lokasi saat ini. Coba lagi.';

  @override
  String get retryLoadMoreStoriesButton => 'Coba muat lagi';

  @override
  String get noMoreStoriesMessage => 'Tidak ada cerita berikutnya.';

  @override
  String get markerInfoTitle => 'Detail Lokasi';

  @override
  String get detailLoadingMessage => 'Memuat detail cerita...';

  @override
  String get openStoryHint => 'Ketuk dua kali untuk membuka detail cerita';

  @override
  String get imageUnavailableLabel => 'Gambar tidak tersedia';

  @override
  String storyImageSemanticLabel(String authorName) {
    return 'Foto cerita oleh $authorName';
  }

  @override
  String storyCardSemanticLabel(String authorName, String createdAt) {
    return '$authorName, dipublikasikan pada $createdAt';
  }
}
