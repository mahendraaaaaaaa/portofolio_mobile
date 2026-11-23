import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';

/// Halaman formulir untuk menambah pengalaman (Experience) portofolio.
///
/// Field-nya mengikuti model `Experience` di backend Django: judul, kategori,
/// deskripsi, tanggal mulai, tanggal selesai (kosong kalau masih berlangsung),
/// dan URL thumbnail (opsional). Datanya belum disimpan ke mana-mana. Setelah
/// semua isian lolos validasi, isinya hanya ditampilkan dalam dialog.
class ExperienceFormPage extends StatefulWidget {
  const ExperienceFormPage({super.key});

  @override
  State<ExperienceFormPage> createState() => _ExperienceFormPageState();
}

class _ExperienceFormPageState extends State<ExperienceFormPage> {
  // Kunci untuk mengakses state Form dari luar: validate() dan reset().
  final _formKey = GlobalKey<FormState>();

  // Kolom tanggal memakai controller karena teksnya diisi dari date picker,
  // bukan diketik pengguna.
  final _startedController = TextEditingController();
  final _endedController = TextEditingController();

  static const _defaultCategory = 'Full-Time';
  static const _maxTitleLength = 255;
  static const _minDescriptionLength = 10;

  final List<String> _categories = const [
    'Internship',
    'Research',
    'Volunteer',
    'Part-Time',
    'Full-Time',
    'Freelance',
  ];

  // Nilai isian.
  String _title = "";
  String _description = "";
  String _category = _defaultCategory;
  String _thumbnail = "";
  DateTime? _startedAt;
  DateTime? _endedAt;
  bool _isOngoing = false;

  @override
  void dispose() {
    _startedController.dispose();
    _endedController.dispose();
    super.dispose();
  }

  /// Format tanggal dd/mm/yyyy tanpa package tambahan.
  static String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  /// Membuka date picker lalu mengisi tanggal mulai ([isStart] true) atau
  /// tanggal selesai. Tanggal selesai sengaja tidak dibatasi oleh tanggal
  /// mulai di picker, urutannya diperiksa oleh validator.
  Future<void> _pickDate({required bool isStart}) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: isStart ? (_startedAt ?? now) : (_endedAt ?? _startedAt ?? now),
      firstDate: DateTime(1990),
      // Tanggal mulai tidak boleh di masa depan.
      lastDate: isStart ? now : DateTime(2100),
    );
    if (picked == null || !mounted) return;
    setState(() {
      if (isStart) {
        _startedAt = picked;
        _startedController.text = _formatDate(picked);
      } else {
        _endedAt = picked;
        _endedController.text = _formatDate(picked);
      }
    });
  }

  /// URL dianggap valid kalau memakai http/https dan punya host.
  bool _isValidUrl(String value) {
    final uri = Uri.tryParse(value);
    return uri != null &&
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.host.isNotEmpty;
  }

  /// Mengosongkan form dan semua variabelnya setelah dialog ditutup.
  void _resetForm() {
    _formKey.currentState!.reset();
    // reset() hanya mengosongkan kotaknya, jadi variabel dan switch ikut
    // dikembalikan supaya isian lama tidak terbawa ke dialog berikutnya.
    setState(() {
      _title = "";
      _description = "";
      _category = _defaultCategory;
      _thumbnail = "";
      _startedAt = null;
      _endedAt = null;
      _isOngoing = false;
      _startedController.clear();
      _endedController.clear();
    });
  }

  void _save() {
    // validate() menjalankan semua validator; dialog hanya muncul kalau
    // semuanya lolos.
    if (!_formKey.currentState!.validate()) return;

    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Pengalaman berhasil disimpan!'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Judul: ${_title.trim()}'),
              Text('Kategori: $_category'),
              Text('Deskripsi: ${_description.trim()}'),
              Text('Mulai: ${_startedAt == null ? '-' : _formatDate(_startedAt!)}'),
              Text(
                'Selesai: ${_isOngoing ? 'Masih berlangsung' : (_endedAt == null ? '-' : _formatDate(_endedAt!))}',
              ),
              Text('Thumbnail: ${_thumbnail.trim().isEmpty ? '-' : _thumbnail.trim()}'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              _resetForm();
            },
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  InputDecoration _decoration(String label, {String? hint, Widget? suffixIcon}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Add Experience Form')),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      body: Form(
        key: _formKey,
        // SingleChildScrollView menjaga semua kolom dan tombol Simpan tetap
        // terjangkau di layar sempit atau saat papan ketik tampil. Batas lebar
        // 600 menjaga tampilan di jendela Chrome yang lebar.
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // === Judul ===
                    TextFormField(
                      decoration: _decoration('Judul Pengalaman',
                          hint: 'Contoh: Backend Developer Intern'),
                      onChanged: (value) => _title = value,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Judul tidak boleh kosong!';
                        }
                        if (value.trim().length > _maxTitleLength) {
                          return 'Judul maksimal $_maxTitleLength karakter!';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),

                    // === Kategori ===
                    DropdownButtonFormField<String>(
                      decoration: _decoration('Kategori'),
                      initialValue: _defaultCategory,
                      items: _categories
                          .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                          .toList(),
                      onChanged: (value) => _category = value ?? _defaultCategory,
                    ),
                    const SizedBox(height: 16.0),

                    // === Deskripsi ===
                    TextFormField(
                      maxLines: 5,
                      decoration: _decoration('Deskripsi',
                          hint: 'Ceritakan apa yang kamu kerjakan'),
                      onChanged: (value) => _description = value,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Deskripsi tidak boleh kosong!';
                        }
                        if (value.trim().length < _minDescriptionLength) {
                          return 'Deskripsi minimal $_minDescriptionLength karakter!';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),

                    // === Tanggal mulai ===
                    TextFormField(
                      controller: _startedController,
                      readOnly: true,
                      onTap: () => _pickDate(isStart: true),
                      decoration: _decoration(
                        'Tanggal Mulai',
                        suffixIcon: const Icon(Icons.calendar_today),
                      ),
                      validator: (_) =>
                          _startedAt == null ? 'Tanggal mulai wajib dipilih!' : null,
                    ),
                    const SizedBox(height: 8.0),

                    // === Masih berlangsung ===
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Masih berlangsung'),
                      value: _isOngoing,
                      onChanged: (value) {
                        setState(() {
                          _isOngoing = value;
                          if (value) {
                            _endedAt = null;
                            _endedController.clear();
                          }
                        });
                      },
                    ),
                    const SizedBox(height: 8.0),

                    // === Tanggal selesai ===
                    TextFormField(
                      controller: _endedController,
                      readOnly: true,
                      enabled: !_isOngoing,
                      onTap: () => _pickDate(isStart: false),
                      decoration: _decoration(
                        'Tanggal Selesai',
                        suffixIcon: const Icon(Icons.calendar_today),
                      ),
                      validator: (_) {
                        if (_isOngoing) return null;
                        if (_endedAt == null) {
                          return "Pilih tanggal selesai atau aktifkan 'Masih berlangsung'!";
                        }
                        if (_startedAt != null && _endedAt!.isBefore(_startedAt!)) {
                          return 'Tanggal selesai tidak boleh sebelum tanggal mulai!';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),

                    // === Thumbnail (opsional) ===
                    TextFormField(
                      keyboardType: TextInputType.url,
                      decoration: _decoration('URL Thumbnail (opsional)',
                          hint: 'https://contoh.com/gambar.png'),
                      onChanged: (value) => _thumbnail = value,
                      validator: (value) {
                        final text = value?.trim() ?? '';
                        if (text.isEmpty) return null;
                        if (!_isValidUrl(text)) {
                          return 'URL tidak valid, awali dengan http:// atau https://';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24.0),

                    // === Tombol Simpan ===
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(Colors.indigo),
                        ),
                        onPressed: _save,
                        child: const Text(
                          'Save',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}