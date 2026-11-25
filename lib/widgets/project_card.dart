import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/models/item_homepage.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:provider/provider.dart';

/// Kartu tombol menu portofolio. Teks, ikon, warna, dan halaman tujuannya
/// dibaca dari [item].
///
/// Saat ditekan, muncul SnackBar yang menyebut nama tombolnya. Kalau
/// [ItemHomepage.requiresLogin] true, pengguna diarahkan ke layar login dulu
/// bila belum login. Kalau [ItemHomepage.destination] terisi, halaman tujuan
/// dibuka dengan `Navigator.push`. Kalau [ItemHomepage.confirmMessage] terisi
/// (mis. Logout), dialog konfirmasi muncul; untuk tombol logout, konfirmasi
/// memanggil AuthState.logout().
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

  Future<void> _handleTap(BuildContext context) async {
    // Disimpan dulu karena dipakai lagi setelah await / dari dalam dialog.
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final auth = context.read<AuthState>();

    if (item.isLogout && !auth.isLoggedIn) {
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(content: Text('Kamu belum login.')));
      return;
    }

    if (item.requiresLogin) {
      final ok = await ensureLoggedIn(context);
      if (!ok || !context.mounted) return;
    }

    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text("Kamu telah menekan tombol ${item.name}!")),
      );

    // push menumpuk halaman tujuan di atas halaman menu, jadi tombol Back
    // (perangkat maupun browser) membawa pengguna kembali ke menu.
    final destination = item.destination;
    if (destination != null) {
      navigator.push(MaterialPageRoute(builder: destination));
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
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              if (item.isLogout) await auth.logout();
              messenger
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(content: Text('${item.name} berhasil.')),
                );
            },
            child: const Text('Ya, lanjutkan'),
          ),
        ],
      ),
    );
  }
}