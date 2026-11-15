import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/main.dart';

void main() {
  testWidgets('halaman utama menampilkan identitas dan SnackBar saat tombol ditekan',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Tiga kartu identitas ada di halaman.
    expect(find.text('NPM'), findsOneWidget);
    expect(find.text('Name'), findsOneWidget);
    expect(find.text('Class'), findsOneWidget);

    // Menekan tombol memunculkan SnackBar dengan nama tombol yang ditekan.
    await tester.tap(find.text('Lihat Proyek'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 750));

    expect(find.text('Kamu telah menekan tombol Lihat Proyek!'), findsOneWidget);
  });
}