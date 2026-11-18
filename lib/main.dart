import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/menu.dart.';

void main() {
  runApp(const MyApp());
}

/// Widget akar aplikasi. MaterialApp menyiapkan tema, navigasi, dan halaman
/// awal, yang kemudian bisa dipakai semua widget di bawahnya lewat context.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyPortfolio',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      // Tema gelap dipakai otomatis kalau perangkat atau browser sedang di mode gelap.
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      home: MyHomePage(),
    );
  }
}