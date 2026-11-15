import 'package:flutter/material.dart';

/// Data satu tombol menu di halaman utama.
///
/// Semua yang membedakan satu tombol dari tombol lain (nama, ikon, warna, dan
/// perlu konfirmasi atau tidak) disimpan di sini. Jadi [ItemCard] cukup
/// membaca data ini, tanpa `if-else` untuk tiap tombol.
class ItemHomepage {
  /// Teks yang tampil di tombol dan di pesan SnackBar.
  final String name;

  /// Ikon di atas teks tombol.
  final IconData icon;

  /// Warna latar kartu tombol.
  final Color color;

  /// Kalau diisi, menekan tombol juga memunculkan dialog konfirmasi dengan
  /// pesan ini (dipakai tombol Logout). Kalau kosong, tombol langsung bereaksi.
  final String? confirmMessage;

  ItemHomepage(
    this.name,
    this.icon,
    this.color, {
    this.confirmMessage,
  });
}