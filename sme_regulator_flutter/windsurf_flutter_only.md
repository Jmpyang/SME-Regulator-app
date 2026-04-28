# Windsurf Cascade Prompt — SME Regulator Flutter App Audit & Fix

> Flutter app only. The FastAPI backend and React web frontend are separate — do NOT touch them.
> Assume the backend APIs are already fixed and return correct responses.

---

## CONTEXT

**App:** SME Regulatory Compliance Navigator — Flutter mobile frontend
**Backend base URL:** configured in `lib/core/config.dart` (or equivalent)
**Packages already in use:** dio, provider, flutter_secure_storage, json_serializable
**Test device:** Infinix X6516

---

## KNOWN ISSUES (from screenshots)

1. Document Vault shows "The requested resource was not found" — API call fails or JWT not attached
2. Permits page shows same error + upload not working
3. Profile/Account Settings shows "Data type mismatch occurred" — null fields treated as wrong type

---

## TASK 1 — Dio interceptor: always attach JWT, handle errors cleanly

In `lib/services/api_service.dart`, ensure the interceptor is correctly applied:

```dart
_dio.interceptors.add(InterceptorsWrapper(
  onRequest: (options, handler) async {
    final token = await _storage.read(key: 'access_token');
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    return handler.next(options);
  },
  onError: (DioException err, handler) async {
    if (err.response?.statusCode == 401) {
      await _storage.deleteAll();
      // Navigate to login — use your app's navigator key or provider
    }
    return handler.next(err);
  },
));
```

---

## TASK 2 — Handle empty list from vault API (fixes "resource not found" error)

In your vault/document repository or provider:

```dart
Future<List<Document>> getDocuments() async {
  try {
    final res = await _dio.get('/api/vault/documents');
    final list = (res.data['documents'] as List?) ?? [];
    return list.map((e) => Document.fromJson(e)).toList();
  } on DioException catch (e) {
    // 404 just means empty — not a real error
    if (e.response?.statusCode == 404) return [];
    rethrow;
  }
}
```

Do the same for notifications:
```dart
Future<List<Notification>> getNotifications() async {
  try {
    final res = await _dio.get('/api/notifications/');
    final list = (res.data as List?) ?? [];
    return list.map((e) => AppNotification.fromJson(e)).toList();
  } on DioException catch (e) {
    if (e.response?.statusCode == 404) return [];
    rethrow;
  }
}
```

---

## TASK 3 — Fix Profile "Data type mismatch" — null-safe model

In `lib/models/user_profile.dart`, make all fields null-safe with defaults:

```dart
class UserProfile {
  final String email;
  final String firstName;
  final String lastName;
  final String phone;
  final String businessName;
  final String businessType;
  final String county;
  final String jobTitle;
  final bool isVerified;

  UserProfile.fromJson(Map<String, dynamic> json)
      : email = (json['email'] as String?) ?? '',
        firstName = (json['first_name'] as String?) ?? '',
        lastName = (json['last_name'] as String?) ?? '',
        phone = (json['phone'] as String?) ?? '',
        businessName = (json['business_name'] as String?) ?? '',
        businessType = (json['business_type'] as String?) ?? '',
        county = (json['county'] as String?) ?? '',
        jobTitle = (json['job_title'] as String?) ?? '',
        isVerified = (json['is_verified'] as bool?) ?? false;
}
```

Never use `json['field'] as String` — always use `(json['field'] as String?) ?? ''`.

---

## TASK 4 — Permit upload: file picker + multipart POST

Add to `pubspec.yaml`:
```yaml
dependencies:
  file_picker: ^8.0.0
```

In `lib/services/vault_service.dart`:

```dart
import 'package:file_picker/file_picker.dart';

Future<void> uploadDocument({
  required String title,
  required String documentType,
}) async {
  final result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['pdf', 'png', 'jpg', 'jpeg'],
  );
  if (result == null) return; // user cancelled

  final file = result.files.single;
  final formData = FormData.fromMap({
    'file': await MultipartFile.fromFile(
      file.path!,
      filename: file.name,
    ),
    'title': title,
    'document_type': documentType,
  });

  await _dio.post('/api/vault/documents', data: formData);
}
```

In the Permits page widget, add a bottom sheet or dialog that asks for title + document type before calling `uploadDocument()`. Trigger it from the "+ New Upload" button.

---

## TASK 5 — Kenyan dropdowns in Profile & Upload forms

Create `lib/core/constants.dart`:

```dart
const List<String> kKenyanCounties = [
  'Baringo', 'Bomet', 'Bungoma', 'Busia', 'Elgeyo-Marakwet', 'Embu', 'Garissa',
  'Homa Bay', 'Isiolo', 'Kajiado', 'Kakamega', 'Kericho', 'Kiambu', 'Kilifi',
  'Kirinyaga', 'Kisii', 'Kisumu', 'Kitui', 'Kwale', 'Laikipia', 'Lamu',
  'Machakos', 'Makueni', 'Mandera', 'Marsabit', 'Meru', 'Migori', 'Mombasa',
  "Murang'a", 'Nairobi', 'Nakuru', 'Nandi', 'Narok', 'Nyamira', 'Nyandarua',
  'Nyeri', 'Samburu', 'Siaya', 'Taita-Taveta', 'Tana River', 'Tharaka-Nithi',
  'Trans Nzoia', 'Turkana', 'Uasin Gishu', 'Vihiga', 'Wajir', 'West Pokot'
];

const List<String> kBusinessTypes = [
  'General Retail (Duka / Boutique / Shop)',
  'Agribusiness & Produce Value Addition',
  'ICT, Cyber Cafes & Digital Services',
  'Small Scale Manufacturing (Jua Kali / Tailoring)',
  'Fast Food, Restaurants & Outside Catering',
  'Beauty, Salon & Barbershop Services',
  'Logistics, Delivery & Boda Boda Services',
  'Pharmacy & Private Health Clinics',
  'Professional Services (Consulting / Law / Accounting)',
  'Hardware, Construction & Real Estate',
  'Private Schools & Daycare Centers',
  'Artisan & Maintenance (Plumbing / Electrical / Auto)',
  'Other / Diversified SME'
];

const List<String> kJobTitles = [
  'Owner / Director',
  'Manager / Supervisor',
  'Money Manager / Accounts',
  'Office Assistant / Admin',
  'IT / Tech Support Person',
  'Sales / Marketing Person',
  'Other'
];
```

Use in profile form:
```dart
DropdownButtonFormField<String>(
  value: selectedCounty.isEmpty ? null : selectedCounty,
  hint: const Text('Select County'),
  items: kKenyanCounties
      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
      .toList(),
  onChanged: (v) => setState(() => selectedCounty = v ?? ''),
  decoration: const InputDecoration(labelText: 'County'),
)
```

Same pattern for `kBusinessTypes` and `kJobTitles`.

---

## TASK 6 — Friendly, specific error messages

Create `lib/utils/error_handler.dart`:

```dart
import 'package:dio/dio.dart';

String friendlyError(DioException e) {
  final status = e.response?.statusCode;
  final detail = e.response?.data?['detail']?.toString() ?? '';

  if (e.type == DioExceptionType.connectionError ||
      e.type == DioExceptionType.unknown) {
    return 'Check your internet connection and try again.';
  }
  if (e.type == DioExceptionType.connectionTimeout ||
      e.type == DioExceptionType.receiveTimeout) {
    return 'The server took too long to respond. Try again.';
  }
  if (status == 401) return 'Incorrect email or password. Please try again.';
  if (status == 404) return 'No account found with that email address.';
  if (status == 422) return 'Please fill in all required fields correctly.';
  if (status == 429) return 'Too many attempts. Please wait a moment.';
  if (detail.contains('Database') || detail.contains('connect')) {
    return 'Server issue — not your connection. Please try again shortly.';
  }
  return 'Something went wrong. Please try again.';
}
```

Use in all catch blocks:
```dart
} on DioException catch (e) {
  setState(() => errorMessage = friendlyError(e));
}
```

Show errors in UI with a `SnackBar` or inline red text — not a generic "An error occurred."

Add inline hints on login form fields:
```dart
TextFormField(
  decoration: const InputDecoration(
    labelText: 'Password',
    helperText: 'Minimum 8 characters',
  ),
  validator: (v) {
    if (v == null || v.isEmpty) return 'Password is required.';
    if (v.length < 8) return 'Password must be at least 8 characters.';
    return null;
  },
)
```

---

## TASK 7 — Persistent login: never log out unless user chooses

In `lib/main.dart` or your root provider, before showing the home screen:

```dart
Future<void> tryAutoLogin(AuthProvider auth) async {
  final token = await FlutterSecureStorage().read(key: 'access_token');
  if (token == null) return; // show login screen

  try {
    // Validate token by hitting a lightweight endpoint
    await DioClient().get('/api/profile/');
    auth.setLoggedIn(true);
  } catch (_) {
    // Token expired or invalid — send to login
    await FlutterSecureStorage().deleteAll();
  }
}
```

In `main.dart`:
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final authProvider = AuthProvider();
  await tryAutoLogin(authProvider);
  runApp(
    ChangeNotifierProvider.value(value: authProvider, child: const MyApp()),
  );
}
```

User should only reach login screen if token is missing or expired — not on every app open.

---

## TASK 8 — Forgot password + change password screens

### Forgot Password screen (`lib/screens/auth/forgot_password_screen.dart`):
- Email input field
- "Send Reset Link" button → `POST /api/auth/forgot-password` with `{ "email": email }`
- On success: show "Check your email/SMS for a reset link."
- On error: use `friendlyError()`

### Change Password screen (`lib/screens/settings/change_password_screen.dart`):
- Current password field
- New password field (with helper text: "Min 8 characters")
- Confirm new password field (validate they match before sending)
- On submit → `POST /api/auth/change-password`
- On success: clear secure storage, navigate to login with message "Password changed. Please log in again."

Add "Forgot password?" link on the login screen pointing to ForgotPasswordScreen.
Add "Change Password" tile in Account Settings pointing to ChangePasswordScreen.

---

## TASK 9 — Real-time sync: poll as fallback (simple & reliable)

Since SSE requires an extra package and backend setup, use periodic polling as the sync mechanism — simple, reliable, no extra dependencies.

In your vault and notification providers, add a periodic refresh:

```dart
class VaultProvider extends ChangeNotifier {
  Timer? _syncTimer;

  void startSync() {
    _syncTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      fetchDocuments(); // re-fetch silently in background
    });
  }

  void stopSync() => _syncTimer?.cancel();

  @override
  void dispose() {
    stopSync();
    super.dispose();
  }
}
```

Call `startSync()` after login, `stopSync()` on logout. 30 seconds is a good interval — not too aggressive on battery, fast enough to feel live.

If you later want true real-time push, upgrade to SSE with `flutter_client_sse` package — the provider structure stays the same, just replace the Timer with an SSE listener.

---

## TASK 10 — Fast load times

1. **Show cached data while fetching** — store last API response in provider, display it immediately on screen open, then refresh in background:

```dart
List<Document> _documents = [];
bool _isLoading = false;

Future<void> fetchDocuments() async {
  _isLoading = true;
  notifyListeners(); // show existing data + loading indicator
  try {
    _documents = await _vaultService.getDocuments();
  } catch (e) {
    // keep showing old data, show snackbar error
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}
```

2. **Use `const` constructors** on all stateless widgets — Flutter skips rebuilding them.

3. **Lazy-load images** — use `cached_network_image` package for any document thumbnails.

4. **Avoid `setState` in parent when only child needs update** — use provider's `Consumer` or `Selector` to rebuild only the widget that changed.

---

## SUMMARY

| # | Fix | File(s) to change |
|---|-----|-------------------|
| 1 | Attach JWT in every request | `lib/services/api_service.dart` |
| 2 | Empty vault/notifications return `[]` not error | `lib/services/vault_service.dart`, `notification_service.dart` |
| 3 | Profile model null-safe with defaults | `lib/models/user_profile.dart` |
| 4 | File picker + multipart upload for permits | `lib/services/vault_service.dart`, permits screen |
| 5 | Kenyan county/business/job dropdowns | `lib/core/constants.dart`, profile screen, upload dialog |
| 6 | Specific error messages per status code | `lib/utils/error_handler.dart`, all screens |
| 7 | Auto-login on app start, logout only on user action | `lib/main.dart`, auth provider |
| 8 | Forgot password + change password screens | `lib/screens/auth/`, `lib/screens/settings/` |
| 9 | Background polling every 30s for live sync | All providers |
| 10 | Fast loads: cached data, const widgets, lazy images | App-wide |
