import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/models/item_homepage.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';

/// Kartu tombol menu portofolio. Teks, ikon, dan warnanya dibaca dari [item].
///
/// Saat ditekan, muncul SnackBar yang menyebut nama tombolnya, misalnya
/// "Kamu telah menekan tombol Lihat Proyek!". Tombol "Tambah Proyek" juga
/// membuka halaman formulir. Kalau [ItemHomepage.confirmMessage] terisi
/// (mis. Logout), dialog konfirmasi ikut muncul supaya pengguna tidak menekan
/// tombol itu tanpa sengaja.
class ItemCard extends StatelessWidget {
  /// Data tombol yang ditampilkan kartu ini.
  final ItemHomepage item;

  const ItemCard(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: item.color,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        // Radius yang sama dengan Material, supaya efek ripple tidak keluar dari sudut kartu.
        borderRadius: BorderRadius.circular(12),
        onTap: () => _handleTap(context),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(item.icon, color: Colors.white, size: 30.0),
              const SizedBox(height: 6.0),
              Text(
                item.name,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleTap(BuildContext context) {
    // Disimpan dulu karena dipakai lagi dari dalam dialog di bawah.
    final messenger = ScaffoldMessenger.of(context);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text("Kamu telah menekan tombol ${item.name}!")),
      );

    // push menumpuk halaman form di atas halaman menu, jadi tombol Back
    // (perangkat maupun browser) membawa pengguna kembali ke menu.
    if (item.name == "Tambah Proyek") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ProjectFormPage(),
        ),
      );
    }

    final message = item.confirmMessage;
    if (message == null) return;

    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(item.name),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              messenger
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text(
                      "${item.name} berhasil (simulasi, belum terhubung ke Django).",
                    ),
                  ),
                );
            },
            child: const Text('Ya, lanjutkan'),
          ),
        ],
      ),
    );
  }
}