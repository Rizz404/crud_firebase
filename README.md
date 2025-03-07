# 1. Penjelasan Sistem Kamera dengan Efek Filter pada Aplikasi Flutter

## Struktur Proyek

Proyek ini memiliki dua fitur utama:

1. **Fitur Biodata** - Untuk praktik Firebase
2. **Fitur Kamera** - Sistem kamera dengan efek filter

```
└── 📁features
    └── 📁biodata
        └── 📁model
            └── biodata_model.dart         # Model data untuk biodata
        └── 📁repositories
            └── biodata_repository.dart    # Repositori untuk interaksi dengan Firebase
        └── 📁screens
            └── biodata_screen.dart        # Screen untuk menampilkan biodata
            └── biodata_upsert_screen.dart # Screen untuk menambah/edit biodata
    └── 📁camera
        └── 📁screens
            └── camera_result_screen.dart  # Screen menampilkan hasil foto dengan filter
            └── camera_screen.dart         # Screen kamera utama
        └── 📁widgets
            └── carousel_flow_delegate.dart # Pengatur tata letak carousel filter
            └── filter_carousel.dart        # Widget carousel filter
            └── filter_item.dart            # Item filter individual
            └── filter_selector.dart        # Pemilih filter
```

## Komponen Utama Fitur Kamera

### 1. CameraScreen

File ini berisi implementasi layar kamera untuk mengambil foto dengan filter real-time. Init kamera perangkat, menampilkan preview, dan menerapkan filter yang dipilih secara langsung pada preview sebelum take foto.

### 2. FilterSelector

Widget ini menampilkan carousel untuk memilih filter warna. Menggunakan `PageController` untuk navigasi antar filter dan menangani efek visual.

### 3. CarouselFlowDelegate

Kelas ini mewarisi `FlowDelegate` dan bertanggung jawab untuk pengaturan tata letak animasi carousel. Menciptakan efek 3D dengan scaling dan opacity berdasarkan posisi item relatif terhadap pusat layar.

### 4. FilterItem

Widget sederhana yang menampilkan item filter individual sebagai lingkaran berwarna dengan border putih dan ikon kamera jika dipilih.

### 5. CameraResultScreen

Screen ini ditampilkan setelah pengguna mengambil foto. Pengguna dapat melihat hasil foto dengan filter yang dipilih, mengubah filter, dan menyimpan foto dengan efek filter ke perangkat menggunakan library pengolahan gambar (`image` package).

## Alur Kerja Aplikasi

1. Pengguna membuka layar kamera (`CameraScreen`)
2. Memilih filter dari carousel di bagian bawah layar
3. Filter diterapkan secara real-time pada preview kamera
4. Pengguna mengambil foto dengan menekan filter yang dipilih
5. Aplikasi mengarahkan ke layar hasil (`CameraResultScreen`)
6. Pengguna dapat mengubah filter atau menyimpan foto ke galeri
7. Saat menyimpan, aplikasi menerapkan filter secara permanen pada gambar menggunakan `image` package

## Fitur Teknis

- Penggunaan `ColorFiltered` untuk menerapkan filter warna pada preview kamera
- Animasi carousel dengan efek zoom menggunakan `Flow` widget dan custom `FlowDelegate`
- Penanganan lifecycle aplikasi untuk mengelola resource kamera dengan tepat
- Pengolahan gambar untuk menerapkan filter secara permanen saat penyimpanan
- Penyimpanan gambar ke penyimpanan eksternal perangkat

# 2. Gabungkan hasil praktikum 1 dengan hasil praktikum 2 sehingga setelah melakukan pengambilan foto, dapat dibuat filter carouselnya!

## Udah digabung

# 3. Jelaskan maksud void async pada praktikum 1?

void async pada praktikum 1 adalah cara nulisnya fungsi asinkron di Dart/Flutter. Fungsi asinkron ini memungkinkan aplikasi tetap jalan/responsif selagi nunggu proses yang makan waktu (kayak komunikasi dengan kamera). void berarti fungsinya gak return apa-apa, sedangkan async nandain kalau fungsi ini bakal punya operasi yang gak langsung kelar dan bisa pake await di dalamnya. Contohnya di \_initializeCamera(), dia nunggu kamera siap tanpa bikin UI freeze.

# 4. Jelaskan fungsi dari anotasi @immutable dan @override ?

@immutable: Ini dari package meta Flutter, yang nandain bahwa class yang dikasih anotasi ini harusnya gak berubah setelah dibuat (instance-nya). Semua field di dalamnya mestinya final. Flutter pake ini buat widget, karena widget di Flutter dirancang untuk immutable - daripada ngubah widget, kita bikin widget baru dengan rebuild. Ini bantuin performance dan bikin state management lebih gampang diprediksi.

@override: Ini nandain kalau method yang ada di bawahnya itu ngegantiin (override) method dari class parent/interface. Misalnya, method build() di widget override method yang sama dari StatelessWidget/StatefulWidget. Anotasi ini gak wajib tapi sangat disarankan karena bantu cegah error (misal salah ketik nama method) dan bikin kode lebih jelas buat dibaca.
