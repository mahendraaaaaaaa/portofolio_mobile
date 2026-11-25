/// Base URL of the Django REST Framework backend.
///
/// Defaults to `http://10.0.2.2:8000` (alamat mesin lokal dari emulator Android).
/// Override with `--dart-define=API_BASE_URL=http://localhost:8000` kalau
/// testing di Chrome/Web.
const String apiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://10.0.2.2:8000',
);