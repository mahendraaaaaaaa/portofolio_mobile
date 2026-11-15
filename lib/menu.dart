import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/models/item_homepage.dart';
import 'package:myportofolio_mobile/widgets/info_card.dart';
import 'package:myportofolio_mobile/widgets/item_card.dart';

/// Halaman utama MyPortfolio Mobile: identitas pemilik di bagian atas, lalu
/// menu tombol untuk bagian-bagian portofolio.
///
/// Halaman ini [StatelessWidget] karena tidak ada data yang berubah selama
/// halaman tampil. Reaksi tombol (SnackBar dan dialog) ditangani [ItemCard],
/// bukan di sini.
class MyHomePage extends StatelessWidget {
  MyHomePage({super.key});

  // Identitas pemilik portofolio.
  final String npm = "2506656551";
  final String nama = "Bagas Mahendra Sri Kasta";
  final String kelas = "A";

  /// Daftar tombol menu. Warna tiap tombol diatur lewat data di sini, jadi
  /// menambah tombol baru cukup menambah satu baris, tanpa menyentuh [ItemCard].
  final List<ItemHomepage> items = [
    ItemHomepage("Lihat Proyek", Icons.folder, Colors.blue.shade700),
    ItemHomepage("Lihat Experience", Icons.work, Colors.green.shade700),
    ItemHomepage("Lihat Skills", Icons.code, Colors.purple.shade600),
    ItemHomepage("Tambah Proyek", Icons.add_circle, Colors.orange.shade800),
    ItemHomepage(
      "Logout",
      Icons.logout,
      Colors.red.shade700,
      confirmMessage: "Kamu yakin ingin keluar dari MyPortfolio?",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'MyPortfolio',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
      ),
      // SingleChildScrollView dan batas lebar 600 menjaga tampilan tetap rapi
      // dan tidak overflow, baik di layar HP maupun di jendela Chrome yang lebar.
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Tiga kartu identitas, lebarnya dibagi rata oleh Expanded.
                  // IntrinsicHeight menyamakan tinggi ketiganya walau panjang
                  // teksnya beda (nama biasanya jauh lebih panjang dari NPM).
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(child: InfoCard(title: 'NPM', content: npm)),
                        Expanded(child: InfoCard(title: 'Name', content: nama)),
                        Expanded(child: InfoCard(title: 'Class', content: kelas)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  const Text(
                    'Selamat datang di MyPortfolio Mobile!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                  ),
                  const SizedBox(height: 16.0),
                  GridView.count(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    // shrinkWrap: tinggi grid mengikuti isinya.
                    shrinkWrap: true,
                    // Scroll sudah ditangani SingleChildScrollView di atas,
                    // jadi grid tidak perlu scroll sendiri.
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      for (final item in items) ItemCard(item),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}