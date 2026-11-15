import 'package:flutter/material.dart';

/// Kartu kecil untuk satu data identitas, misalnya NPM, nama, atau kelas.
///
/// Dibuat sebagai widget sendiri supaya tiga kartu di halaman utama cukup
/// memanggil widget yang sama dengan [title] dan [content] yang berbeda.
class InfoCard extends StatelessWidget {
  /// Judul kartu, mis. "NPM".
  final String title;

  /// Isi kartu, mis. nilai NPM-nya.
  final String content;

  const InfoCard({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Text(content, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}