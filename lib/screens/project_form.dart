import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/models/project.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:provider/provider.dart';

/// Halaman formulir untuk menambah proyek portofolio. Setelah lolos validasi
/// dan pengguna login, data dikirim ke Django lewat POST terautentikasi.
class ProjectFormPage extends StatefulWidget {
  const ProjectFormPage({super.key});

  @override
  State<ProjectFormPage> createState() => _ProjectFormPageState();
}

class _ProjectFormPageState extends State<ProjectFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _description = TextEditingController();
  final _projectUrl = TextEditingController();
  final _thumbnail = TextEditingController();
  bool _isSubmitting = false;

  // PENTING: isi list ini dengan nilai `category` yang valid di model Django.
  String _category = 'Web Development';
  final List<String> _categories = [
    'Web Development',
    'Mobile Development',
    'Machine Learning',
    'Data Science',
    'Other',
  ];

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    _projectUrl.dispose();
    _thumbnail.dispose();
    super.dispose();
  }

  String? _validateUrl(String? v, {required bool required}) {
    final value = v?.trim() ?? '';
    if (value.isEmpty) return required ? 'URL tidak boleh kosong!' : null;
    final uri = Uri.tryParse(value);
    final ok = uri != null &&
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.host.isNotEmpty;
    return ok ? null : 'URL tidak valid (awali dengan http:// atau https://)';
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final api = context.read<ApiClient>();
    final auth = context.read<AuthState>();
    final messenger = ScaffoldMessenger.of(context);

    if (!await ensureLoggedIn(context)) return;
    if (!mounted) return;
    final token = auth.token;
    if (token == null) return;

    setState(() {
      _isSubmitting = true;
    });
    try {
      final created = await api.createProject(
        Project(
          title: _title.text.trim(),
          description: _description.text.trim(),
          category: _category,
          projectUrl: _projectUrl.text.trim(),
          thumbnail: _thumbnail.text.trim(),
        ),
        token: token,
      );
      if (!mounted) return;
      await showDialog<void>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Proyek berhasil ditambahkan!'),
          content: Text('${created.title} sudah tersimpan di server.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      _formKey.currentState?.reset();
      _title.clear();
      _description.clear();
      _projectUrl.clear();
      _thumbnail.clear();
    } on ApiException catch (e) {
      if (e.statusCode == 401) {
        // Token tidak valid/kedaluwarsa: keluar lalu minta login ulang.
        await auth.logout();
        messenger.showSnackBar(
          const SnackBar(content: Text('Sesi habis, silakan login lagi.')),
        );
        if (mounted) await ensureLoggedIn(context);
      } else {
        messenger.showSnackBar(
          SnackBar(content: Text('Gagal menyimpan proyek (${e.statusCode}).')),
        );
      }
    } catch (_) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Tidak bisa terhubung ke server.')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  InputDecoration _deco(String label, [String? hint]) => InputDecoration(
        labelText: label,
        hintText: hint ?? label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Add Project Form')),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: TextFormField(
                  controller: _title,
                  decoration: _deco('Title'),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Title tidak boleh kosong!'
                      : null,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: TextFormField(
                  controller: _description,
                  maxLines: 5,
                  decoration: _deco('Description'),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Description tidak boleh kosong!'
                      : null,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: DropdownButtonFormField<String>(
                  initialValue: _category,
                  decoration: _deco('Category'),
                  items: _categories
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (v) => setState(() => _category = v!),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: TextFormField(
                  controller: _projectUrl,
                  keyboardType: TextInputType.url,
                  decoration: _deco('Project URL', 'https://...'),
                  validator: (v) => _validateUrl(v, required: true),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: TextFormField(
                  controller: _thumbnail,
                  keyboardType: TextInputType.url,
                  decoration:
                      _deco('Project Image URL (Optional)', 'https://...'),
                  validator: (v) => _validateUrl(v, required: false),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(Colors.indigo),
                  ),
                  onPressed: _isSubmitting ? null : _submit,
                  child: _isSubmitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text(
                          'Save',
                          style: TextStyle(color: Colors.white),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}