# MyPortfolio Mobile — Bagas Mahendra

Aplikasi mobile (Flutter) untuk portofolio pribadiku. Ini pasangan dari website portofolio Django-ku di [myportofolio](https://github.com/mahendraaaaaaaa/myportofolio): repo ini cuma berisi sisi aplikasi Flutter-nya, backend Django-nya ada di repo terpisah.

Untuk saat ini halamannya masih statis: menampilkan identitasku dan menu tombol ke bagian-bagian portofolio. Menyambungkannya ke API Django dikerjakan di tahap berikutnya.

---

## Fitur

- **Tiga kartu identitas** di bagian atas halaman: NPM, nama lengkap, dan kelas. Lebarnya dibagi rata dan tingginya disamakan, jadi tetap rapi walau nama jauh lebih panjang dari NPM.
- **Lima tombol menu** (Lihat Proyek, Lihat Experience, Lihat Skills, Tambah Proyek, Logout) dalam grid tiga kolom. Tiap tombol punya ikon dan warna sendiri yang diatur lewat data (`ItemHomepage`), bukan lewat `if-else` di widget.
- **SnackBar** dengan tulisan "Kamu telah menekan tombol [nama tombol]!" setiap kali tombol ditekan.
- **Dialog konfirmasi untuk Logout**, supaya tombol itu tidak kepencet tanpa sengaja. Untuk sekarang aksinya masih simulasi karena belum ada login yang terhubung ke Django.
- **Layout aman dari overflow**: halaman bisa di-scroll dan lebarnya dibatasi 600 px, jadi tampilannya tetap wajar di layar HP maupun di jendela Chrome yang lebar.
- **Mode gelap otomatis** yang mengikuti pengaturan perangkat atau browser.
- **Widget test** untuk memastikan kartu identitas tampil dan SnackBar muncul saat tombol ditekan.
- **Formulir Tambah Experience** (lib/screens/experience_form.dart) dengan field mengikuti model Experience di Django: judul, kategori (dropdown), deskripsi, tanggal mulai dan selesai (date picker), switch "Masih berlangsung", dan URL thumbnail opsional. Validasi menolak isian kosong atau hanya spasi, judul lebih dari 255 karakter, deskripsi kurang dari 10 karakter, URL yang bukan http/https, dan tanggal selesai yang lebih awal dari tanggal mulai.
- **Dialog ringkasan** yang hanya muncul setelah semua input lolos validasi.
- **Kartu aksi "Tambah Experience"** di halaman utama dan opsi Add Experience di drawer. Drawer yang sama dipakai di halaman utama, form proyek, dan form experience.

## Tech Stack

- Flutter (Dart) dengan Material 3
- Tanpa package tambahan, hanya yang sudah ada di Flutter SDK

## Struktur Proyek

```
myportofolio_mobile/
├── lib/
│   ├── main.dart                   # titik masuk + MaterialApp (tema terang dan gelap)
│   ├── models/
│   │   └── item_homepage.dart      # data satu tombol: nama, ikon, warna, tujuan, konfirmasi
│   ├── screens/
│   │   ├── menu.dart               # MyHomePage, halaman utama
│   │   ├── project_form.dart       # formulir Tambah Proyek (Tutorial 09)
│   │   └── experience_form.dart    # formulir Tambah Experience (Tugas 8)
│   └── widgets/
│       ├── info_card.dart          # kartu identitas
│       ├── project_card.dart       # ItemCard: kartu tombol menu
│       └── left_drawer.dart        # drawer yang dipakai semua halaman
├── test/
│   └── widget_test.dart
└── ...

## Cara Menjalankan

1. Pasang Flutter SDK (channel stable) dan Google Chrome, lalu cek lingkungannya:
   ```bash
   flutter doctor
   ```
   Proyek ini dikembangkan dengan Flutter 3.47.9.
2. Clone repo ini:
   ```bash
   git clone https://github.com/mahendraaaaaaaa/myportofolio_mobile.git
   cd myportofolio_mobile
   ```
3. Ambil dependensi:
   ```bash
   flutter pub get
   ```
4. Jalankan di Chrome (atau jalankan `flutter run` tanpa `-d` kalau mau pakai emulator Android):
   ```bash
   flutter run -d chrome
   ```
   Saat aplikasi berjalan, tekan `r` di terminal untuk *hot reload*, `R` untuk *hot restart*, dan `q` untuk berhenti.
5. Cek kualitas kode dan jalankan test:
   ```bash
   flutter analyze
   flutter test
   ```

---

## Progress Pengerjaan

### Tutorial 08

Memasang Flutter SDK dan menambahkan `flutter/bin` ke `PATH`, memasang Android Studio beserta Android SDK Command-line Tools, lalu menjalankan `flutter doctor` untuk memeriksa kelengkapan toolchain-nya. Setelah itu membuat proyek dengan `flutter create myportofolio_mobile` dan menjalankannya di Chrome lewat `flutter run -d chrome`.

Dari aplikasi counter bawaan, aku mengikuti langkah tutorial: memindahkan `MyHomePage` ke `lib/menu.dart` supaya terpisah dari `main.dart`, mengubah tema warna, mengubah `MyHomePage` dari `StatefulWidget` jadi `StatelessWidget`, lalu membuat `InfoCard` dan `ItemCard` beserta model `ItemHomepage` dan SnackBar. Ditutup dengan `flutter analyze` dan push ke repo ini.

### Tugas 7

Mengganti data contoh Burhan dengan identitasku sendiri (NPM, nama lengkap, dan kelas) di `menu.dart`.

Memecah isi `menu.dart` jadi beberapa file: `ItemHomepage` pindah ke `lib/models/`, `InfoCard` dan `ItemCard` pindah ke `lib/widgets/`. `menu.dart` sekarang cuma berisi `MyHomePage`. Di tahap ini `ItemHomepage` juga mendapat atribut `color` supaya warna tiap tombol datang dari data, plus `confirmMessage` opsional untuk tombol yang butuh konfirmasi.

Menyesuaikan menu dengan bagian-bagian website Django-ku: Lihat Proyek, Lihat Experience, Lihat Skills, Tambah Proyek, dan Logout, masing-masing dengan warna berbeda (biru, hijau, ungu, oranye, merah). Warnanya kupilih versi yang lebih gelap dari warna dasarnya supaya tulisan putih di atasnya tetap terbaca.

Merapikan layout. Sel grid berbentuk kotak, jadi di jendela Chrome yang lebar kartu ikut membesar dan dua baris tombol berpotensi melewati tinggi layar (muncul garis kuning-hitam "overflow"). Halaman kubungkus `SingleChildScrollView`, lebarnya dibatasi `ConstrainedBox` 600 px, dan tiga kartu identitas memakai `Expanded` supaya tidak bergantung pada lebar layar.

Menambahkan hal-hal di luar checklist: dialog konfirmasi untuk Logout, tema gelap yang mengikuti sistem, dan satu widget test. Terakhir menjalankan `flutter analyze` dan `flutter test`, lalu menulis jawaban pertanyaan reflektif dan AI disclosure di README ini.

### Tugas 8

Membuat ExperienceFormPage di lib/screens/experience_form.dart memakai StatefulWidget, Form, dan GlobalKey<FormState>. Field-nya kusesuaikan dengan model Experience di Django. Tanggal dipilih lewat showDatePicker(), dan tanggal selesai bisa dikosongkan lewat switch "Masih berlangsung". Isi form dibungkus SingleChildScrollView dan ConstrainedBox 600 px supaya tombol Save tetap terjangkau di layar sempit dan saat papan ketik tampil.

Menambahkan opsi Add Experience di LeftDrawer (opsi Home dan Add Project tetap ada) dan kartu aksi "Tambah Experience" di halaman utama. Supaya ItemCard tidak memakai if-else per tombol, ItemHomepage kuberi atribut destination: kartu yang punya tujuan dibuka dengan Navigator.push. Opsi Home di drawer kuubah dari pushReplacement ke pushAndRemoveUntil karena kalau form dibuka dari kartu, tumpukan halamannya sudah berisi halaman utama, dan pushReplacement akan membuat dua halaman utama bertumpuk.

Menguji: buka form dari kartu dan drawer, simpan dengan isian kosong, hanya spasi, tanggal selesai sebelum tanggal mulai, dan URL salah, lalu simpan dengan isian valid. Terakhir flutter analyze dan flutter test.

---

## Pertanyaan Reflektif

### Tugas 7

1. **Widget tree dan hubungan parent-child.** Di Flutter semua yang tampil di layar adalah widget: teks, tombol, padding, bahkan layout-nya. Widget disusun bersarang, satu widget membungkus widget lain, jadi bentuknya seperti pohon. Widget yang membungkus disebut *parent*, yang dibungkus disebut *child*. Di proyekku pohonnya begini:
   ```
   MyApp
   └─ MaterialApp
      └─ MyHomePage
         └─ Scaffold
            ├─ AppBar
            └─ SingleChildScrollView → Center → ConstrainedBox → Padding → Column
               ├─ IntrinsicHeight → Row → Expanded → InfoCard (x3)
               ├─ Text
               └─ GridView → ItemCard (x5)
   ```
   Hubungan parent dan child bekerja di tiga hal. Pertama, ukuran: parent memberi *constraints* (batas minimum dan maksimum lebar-tinggi) ke child, child memilih ukurannya di dalam batas itu lalu melapor balik, dan parent yang menentukan posisinya. Contohnya `ConstrainedBox` membatasi lebar halamanku maksimal 600 px, dan `Expanded` di dalam `Row` membagi lebar jadi tiga untuk `InfoCard`. Kedua, data: data mengalir ke bawah lewat constructor, misalnya `MyHomePage` mengirim `item` ke `ItemCard` dan `title` serta `content` ke `InfoCard`. Ketiga, child bisa mencari ke atas lewat `context` untuk mengambil sesuatu dari ancestor-nya, misalnya `Theme.of(context)`. Kalau ada widget yang perlu digambar ulang, Flutter hanya membangun ulang bagian pohon dari widget itu ke bawah, bukan seluruh aplikasi.

2. **Widget yang kupakai dan fungsinya.**
   - `MaterialApp`: pembungkus aplikasi (tema, tema gelap, halaman awal, navigasi).
   - `Scaffold`: kerangka halaman (area `appBar` dan `body`).
   - `AppBar`: bar judul di atas halaman.
   - `SingleChildScrollView`: membuat isi halaman bisa di-scroll sehingga tidak overflow.
   - `Center`: menaruh child di tengah.
   - `ConstrainedBox`: membatasi lebar maksimal isi halaman (600 px).
   - `Padding`: memberi jarak di sekeliling child.
   - `Column`: menyusun child ke bawah.
   - `Row`: menyusun child ke samping (tiga kartu identitas).
   - `IntrinsicHeight`: menyamakan tinggi kartu-kartu di dalam `Row`.
   - `Expanded`: membuat child mengambil bagian lebar yang sama di dalam `Row`.
   - `Card`: kotak dengan bayangan untuk `InfoCard`.
   - `SizedBox`: jarak kosong antar-elemen.
   - `Text`: menampilkan tulisan.
   - `GridView.count`: menyusun tombol menu dalam grid tiga kolom.
   - `Material`: permukaan berwarna dengan sudut membulat untuk `ItemCard`, tempat efek ripple digambar.
   - `InkWell`: membuat area bisa ditekan dan memberi efek ripple.
   - `Icon`: ikon di atas teks tombol.
   - `SnackBar`: pesan singkat di bawah layar (ditampilkan lewat `ScaffoldMessenger`).
   - `AlertDialog`, `TextButton`, `FilledButton`: dialog konfirmasi Logout beserta tombol Batal dan Ya.
   - Widget buatanku sendiri: `MyApp`, `MyHomePage`, `InfoCard`, dan `ItemCard`.

3. **Fungsi `MaterialApp` dan kenapa jadi root widget.** `MaterialApp` adalah widget pembungkus untuk aplikasi bergaya Material Design. Di dalamnya diatur hal-hal yang berlaku untuk seluruh aplikasi: `title`, tema (`theme`, `darkTheme`, `themeMode`), halaman awal (`home`), dan `Navigator` untuk pindah halaman. `MaterialApp` juga menyediakan hal-hal yang dibutuhkan widget di bawahnya, seperti `MediaQuery` untuk ukuran layar dan `ScaffoldMessenger` untuk menampilkan SnackBar. Itu sebabnya ia dipasang paling atas: `Scaffold` butuh `MediaQuery` dan SnackBar butuh `ScaffoldMessenger`, dan keduanya dicari ke atas pohon. Tanpa `MaterialApp` (atau pembungkus yang setara) di atasnya, keduanya error, dan tema yang kupilih juga tidak akan berlaku. Selain itu, dengan menaruh konfigurasi global di satu tempat, semua halaman otomatis konsisten tanpa perlu mengatur ulang satu per satu.

4. **`StatelessWidget` vs `StatefulWidget`.** `StatelessWidget` tidak menyimpan data yang berubah: tampilannya hanya ditentukan oleh data dari constructor (dan `context`), jadi dengan input yang sama hasilnya selalu sama. `StatefulWidget` punya objek `State` terpisah yang tetap hidup walau widget dibangun ulang, dan ketika isinya diubah lewat `setState()`, Flutter menjalankan `build` lagi. Aku memilih `StatelessWidget` untuk tampilan yang tidak berubah sendiri, seperti `MyHomePage`, `InfoCard`, dan `ItemCard` di proyekku (identitas dan daftar tombolnya tetap). `StatefulWidget` dibutuhkan kalau ada data yang berubah dan memengaruhi tampilan, misalnya angka counter di aplikasi bawaan Flutter, isi form, saklar atau checkbox, animasi, atau status loading saat mengambil data dari API (nanti dari Django). Aturan praktisnya: mulai dari `StatelessWidget`, baru naikkan jadi `StatefulWidget` kalau memang ada state yang harus diingat.

5. **`BuildContext` dan kenapa penting.** `BuildContext` adalah penanda lokasi sebuah widget di dalam widget tree (secara teknis ia mewakili `Element`-nya). Di method `build(BuildContext context)`, `context` itu adalah lokasi widget tersebut. Gunanya untuk mencari ancestor ke atas pohon: `Theme.of(context)` mengambil tema dari `MaterialApp`, `MediaQuery.of(context)` mengambil ukuran layar, `ScaffoldMessenger.of(context)` mengambil messenger untuk SnackBar, dan `Navigator.of(context)` untuk navigasi. Karena pencariannya hanya ke atas dari lokasi itu, context yang dipakai harus yang benar. Kesalahan klasiknya adalah memanggil `Scaffold.of(context)` memakai context dari widget yang membuat `Scaffold` itu sendiri, sehingga tidak ketemu. Di `ItemCard` aku memakai `context` kartu untuk mengambil `ScaffoldMessenger`, tapi di dalam dialog aku memakai `dialogContext` (context milik dialog) untuk menutupnya. Aku juga menyimpan `messenger` ke variabel sebelum dialog dibuka, supaya SnackBar kedua tidak bergantung pada `context` kartu yang sudah lewat.

6. **Hot reload, hot restart, dan full restart.** *Hot reload* memasukkan kode yang baru kusimpan ke aplikasi yang sedang berjalan dan membangun ulang widget tree, tanpa menjalankan ulang `main()` dan tanpa menghapus state. Ini yang paling cepat dan cocok untuk mengubah tampilan di method `build`, misalnya mengganti warna tombol atau teks. *Hot restart* menjalankan ulang aplikasi dari `main()` dan menghapus semua state (kembali ke kondisi awal), tapi tidak perlu membangun ulang bagian native sehingga masih lebih cepat daripada mulai dari nol. Hot restart dibutuhkan kalau perubahannya tidak ikut ter-hot-reload, misalnya mengubah isi `main()`, nilai awal variabel global atau `static`, atau `initState`. *Full restart* (hentikan aplikasi lalu `flutter run` lagi) dibutuhkan kalau yang berubah ada di luar kode Dart: menambah package atau aset di `pubspec.yaml` (setelah `flutter pub get`), mengubah konfigurasi native seperti `AndroidManifest.xml`, Gradle, atau iOS, menambah permission, mengganti ikon aplikasi, dan memasang plugin yang punya kode native. Di Chrome, tombolnya `r` untuk hot reload, `R` untuk hot restart, dan `q` untuk berhenti.

### Tugas 8

1. push(), pushReplacement(), dan pop(). Navigator mengelola tumpukan halaman (stack). push() menaruh halaman baru di atas halaman sekarang, jadi halaman lama tetap ada di bawahnya dan tombol Back membawa pengguna kembali ke sana. pushReplacement() mengganti halaman paling atas dengan halaman baru, jadi halaman lama dibuang dan tidak bisa dikembalikan dengan Back. pop() membuang halaman paling atas dan kembali ke halaman di bawahnya, misalnya menutup dialog atau halaman form. Untuk membuka formulir dari kartu aksi aku memakai Navigator.push() (di ItemCard), supaya pengguna bisa kembali ke halaman utama dengan tombol Back. Opsi Home di drawer memakai Navigator.pushAndRemoveUntil() dengan syarat (route) => false: halaman utama baru dipasang dan seluruh tumpukan sebelumnya dibuang. Aku tidak memakai pushReplacement() untuk Home karena kalau form dibuka dari kartu, tumpukannya sudah [Home, Form]. Hasil pushReplacement() adalah [Home, Home], sehingga Back dari halaman utama yang baru malah membawa ke halaman utama yang lama.

2. Scaffold, AppBar, dan Drawer. Scaffold menyediakan slot tetap (appBar, drawer, body), jadi tiap halaman punya kerangka yang sama dan aku cukup mengisi slot-nya. Tombol hamburger muncul otomatis di AppBar begitu drawer terisi. LeftDrawer adalah satu widget yang kupakai di halaman utama, form proyek, dan form experience, jadi menu navigasinya tidak perlu ditulis ulang dan selalu sama. Contoh warna tema: indigo dipakai sebagai warna AppBar di halaman form proyek dan form experience, sebagai warna DrawerHeader di drawer, dan sebagai seedColor tema di main.dart (yang jadi dasar warna AppBar halaman utama).

3. Tata letak formulir. Form-nya Form → SingleChildScrollView → Center → ConstrainedBox (maks. 600 px) → Padding → Column. Kolom disusun ke bawah karena field formulir dibaca dan diisi berurutan. Widget pengatur jarak (Padding dan SizedBox) memberi ruang antarfield supaya pesan error dan area sentuh tidak berdempetan. Widget penggulir (SingleChildScrollView) penting karena ruang layar terbatas: saat papan ketik muncul, area body menyusut, dan tanpa scroll isi form bisa overflow atau tombol Save tertutup. Dengan scroll, semua field dan tombol tetap bisa dijangkau. ConstrainedBox menjaga lebar form tetap wajar di jendela Chrome yang lebar.

4. GlobalKey<FormState>, validator, dan validate(). GlobalKey<FormState> dipasang di Form supaya tombol Save, yang ada di luar field, bisa mengakses state form-nya. validator adalah fungsi di tiap field yang mengembalikan teks error kalau isiannya salah, atau null kalau benar. Saat Save ditekan, validate() menjalankan semua validator, menampilkan pesan error di kolom yang bermasalah, dan mengembalikan true hanya kalau semuanya lolos. Dialog ringkasan baru muncul kalau hasilnya true. Contoh nilai yang ditolak: judul berisi spasi saja ("   "), yang ditolak karena trim() membuatnya kosong. Jenis input atau papan ketik saja tidak cukup karena itu hanya membantu tampilan: TextInputType.url tidak mencegah pengguna mengetik foto saya sebagai URL, dan date picker tidak bisa memastikan tanggal selesai tidak lebih awal dari tanggal mulai. Aturan seperti itu hanya bisa ditegakkan oleh validator.

---

## AI Disclosure

Aku pakai AI sebagai *pair programmer* untuk membaca tugas, menyusun struktur, dan drafting kode. Hasilnya tetap aku jalankan dan cek sendiri.

### Tugas 7

Tool: Claude (Anthropic). Strategi prompting-nya: aku kirim PDF tugas dan screenshot VS Code berisi `menu.dart`-ku, lalu minta AI membaca rubrik dulu dan menjelaskan apa saja yang harus dikerjakan untuk nilai maksimal di tiap aspek. Setelah itu aku minta kodenya per file, lengkap dengan penjelasan yang bisa kupahami, bukan sekadar hasil jadi.


**Bagian yang dibantu AI:**
- Membaca PDF tugas dan rubrik, lalu memetakan apa yang dibutuhkan untuk nilai maksimal di tiap aspek.
- Draft struktur file (`models/` dan `widgets/`), `ItemHomepage` berwarna dengan `confirmMessage`, `ItemCard` dengan SnackBar dan dialog Logout, layout yang aman dari overflow, tema gelap, dan satu widget test.
- AI memeriksa sintaks semua file Dart dengan parser Dart dan mencoba urutan perintah Git (branch, commit, merge) di repo tiruan sebelum diberikan padaku.
- Draft jawaban pertanyaan reflektif, draft blok Tugas 7 di README ini, dan panduan Git (branch per fitur, conventional commits, `merge --no-ff`).

**Bagian yang aku kerjain/perbaiki manual:**
- Mengganti data contoh Burhan dengan identitasku sendiri (NPM, nama lengkap, dan kelas) di `menu.dart`.
- Menjalankan `flutter analyze` dan `flutter test` di laptopku sendiri, bukan cuma percaya hasil dari AI.
- Menjalankan aplikasi di Chrome lalu menekan kelima tombol satu per satu untuk memastikan teks SnackBar-nya sesuai nama tombol, dan mencoba tombol Batal dan Ya di dialog Logout.
- Mengubah lebar jendela Chrome (sempit dan lebar) dan berganti antara mode terang dan gelap, karena AI tidak bisa melihat hasil render sehingga overflow, kontras warna, dan tata letak cuma bisa kupastikan dengan mata sendiri.
- Membaca ulang jawaban pertanyaan reflektif dan menyesuaikan kalimatnya dengan pemahamanku sendiri.

**Keterbatasan AI yang aku sadari selama proses ini:**
AI tidak bisa menjalankan Flutter di lingkungannya (SDK-nya tidak bisa diunduh di sana), jadi `flutter analyze`, `flutter run`, dan `flutter test` tidak pernah dijalankan oleh AI. Yang bisa dicek AI cuma sintaks lewat parser dan logika lewat membaca kode. Apakah kodenya benar-benar lolos analisis, tampil rapi, dan tidak overflow harus kubuktikan sendiri di laptopku. AI juga tidak bisa melihat hasil render, jadi soal warna, kontras, dan tata letak ia hanya memperkirakan dari angka dan aturan umum. Terakhir, AI cenderung menambah fitur kalau rubriknya menyebut "fitur ekstra", jadi hasilnya perlu dibatasi dan dipahami dulu: dialog Logout sengaja masih simulasi karena belum ada login yang terhubung ke Django.

### Tugas 8

Tool: Claude (Anthropic). Strategi prompting: aku kirim PDF tugas lalu minta AI membaca rubrik dan menjelaskan apa yang harus dikerjakan untuk nilai maksimal.

**Bagian yang dibantu AI:**
- Membaca PDF tugas dan memetakan rubrik.
- Draft experience_form.dart, penambahan opsi di LeftDrawer, atribut destination di ItemHomepage, kartu "Tambah Experience", dan draft jawaban refleksi serta blok README ini.

**Bagian yang aku kerjain/perbaiki manual:**
- Menjalankan flutter analyze dan flutter test di laptopku dan memperbaiki temuannya.
- Menguji form dari kartu dan drawer, simpan dengan isian kosong dan valid, tanggal terbalik, URL salah, serta tombol Home, di Chrome dengan lebar jendela sempit dan lebar.
- Membaca ulang jawaban refleksi dan menyesuaikannya dengan pemahamanku.

**Keterbatasan AI:** AI tidak bisa menjalankan Flutter, jadi flutter analyze, flutter run, dan flutter test tidak pernah dijalankan oleh AI, dan tampilan hasil render tidak bisa dilihatnya. AI juga perlu dikoreksi soal detail proyek, misalnya nama file project_card.dart yang ternyata berisi ItemCard, dan perilaku pushReplacement untuk Home yang membuat halaman utama bertumpuk, yang kuperbaiki dengan pushAndRemoveUntil.