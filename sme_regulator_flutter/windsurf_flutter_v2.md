# Windsurf Cascade Prompt v2 — SME Regulator Flutter: UI Overhaul + Bug Fixes

> Flutter app only. Do not touch the FastAPI backend or React frontend.
> Read the existing code structure before making any changes.

---

## CONTEXT FROM SCREENSHOTS

Current screens observed:
- Landing: Shield icon, "SME Compliance Navigator", Login + Register buttons
- Login: Email + Password fields, Forgot Password link
- Register: Full Name, Email, Phone, Password fields
- Forgot Password: Email field, "Send Reset OTP" button
- Dashboard: Welcome back, Compliance Score 0%, Active Permits 0 — **shows "Data type mismatch occurred" error**

---

## PART A — CRITICAL BUG FIXES (do these first)

### A1. Fix "Data type mismatch" on Dashboard, Document Vault, Permits, Profile

The backend returns `null` for some fields. Every `fromJson` method must use null-safe casting. Apply this pattern everywhere:

```dart
// WRONG — crashes on null
final score = json['compliance_score'] as int;
final name = json['first_name'] as String;

// CORRECT — null-safe with defaults
final score = (json['compliance_score'] as num?)?.toInt() ?? 0;
final name = (json['first_name'] as String?) ?? '';
```

Audit every model file (`dashboard_summary_model.dart`, `profile_model.dart`, `document_model.dart`, `reminder_model.dart`) and fix all unsafe casts.

For dashboard specifically, the summary response may return nested nulls:
```dart
class DashboardSummary {
  final int complianceScore;
  final int activePermits;
  final int missingExpired;
  final int requiredCategories;
  final List<dynamic> upcomingExpiries;

  DashboardSummary.fromJson(Map<String, dynamic> json)
      : complianceScore = (json['compliance_score'] as num?)?.toInt() ?? 0,
        activePermits = (json['total_active_documents'] as num?)?.toInt() ?? 0,
        missingExpired = (json['missing_expired'] as num?)?.toInt() ?? 0,
        requiredCategories = (json['required_categories'] as num?)?.toInt() ?? 0,
        upcomingExpiries = (json['upcoming_expiries'] as List?) ?? [];
}
```

### A2. Fix dark theme — apply consistently across entire app

In `lib/core/theme.dart` (or wherever ThemeData is defined), ensure:

```dart
MaterialApp(
  themeMode: ThemeMode.system, // or ThemeMode.dark based on user toggle
  theme: AppTheme.lightTheme,
  darkTheme: AppTheme.darkTheme,
  ...
)
```

Every custom widget must use `Theme.of(context)` colors — never hardcoded hex colors like `Color(0xFFFFFFFF)` or `Colors.white` directly. Replace all hardcoded colors with:
```dart
Theme.of(context).colorScheme.surface       // instead of Colors.white
Theme.of(context).colorScheme.onSurface     // instead of Colors.black
Theme.of(context).colorScheme.surfaceVariant // instead of Colors.grey[100]
```

Define a proper dark `ColorScheme` in `darkTheme`:
```dart
static final darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    primary: const Color(0xFF4F8EF7),
    secondary: const Color(0xFF6C63FF),
    surface: const Color(0xFF1E1E2E),
    background: const Color(0xFF12121A),
    onPrimary: Colors.white,
    onSurface: Colors.white,
  ),
  // carry through all other theme properties
);
```

### A3. Fix pixel overflow errors on Document Vault and Profile pages

Wrap all `Column` children that might overflow with:
```dart
// Wrap the Column in a SingleChildScrollView
SingleChildScrollView(
  child: Column(children: [...]),
)
```

Or use `Flexible` / `Expanded` correctly inside `Row`s to prevent horizontal overflow:
```dart
// WRONG
Row(children: [Text(longText), Icon(Icons.arrow)])

// CORRECT
Row(children: [Expanded(child: Text(longText)), Icon(Icons.arrow)])
```

---

## PART B — UI REDESIGN (apply after bug fixes)

The current UI is functional but plain. Apply these precise improvements:

### B1. Global design tokens

Add to `lib/core/theme.dart`:
```dart
// Consistent border radius
const kCardRadius = BorderRadius.all(Radius.circular(16));
const kButtonRadius = BorderRadius.all(Radius.circular(12));
const kInputRadius = BorderRadius.all(Radius.circular(10));

// Consistent spacing
const kSpacingS = 8.0;
const kSpacingM = 16.0;
const kSpacingL = 24.0;
const kSpacingXL = 32.0;

// Primary brand color
const kPrimaryColor = Color(0xFF2563EB);  // professional blue
const kAccentColor = Color(0xFF7C3AED);   // purple accent
```

### B2. Landing screen — redesign

Replace the two-button layout with a single "Get Started" flow:

```dart
// Landing screen layout:
// - Full screen gradient background (top: kPrimaryColor, bottom: deep navy)
// - Centered shield/compliance icon (large, white, with subtle glow shadow)
// - App name in bold white, tagline in semi-transparent white below
// - Single "Get Started" ElevatedButton at the bottom (full width, white text on primary)
// - No Register button on landing — just one CTA

// On "Get Started" tap → navigate to LoginScreen
```

On the Login screen, add at the bottom:
```dart
Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    Text("Don't have an account? ", style: TextStyle(color: Colors.grey)),
    GestureDetector(
      onTap: () => Navigator.pushNamed(context, AppRoutes.register),
      child: Text("Create one", style: TextStyle(
        color: kPrimaryColor,
        fontWeight: FontWeight.w600,
        decoration: TextDecoration.underline,
      )),
    ),
  ],
)
```

### B3. Login screen improvements

```dart
// Add app logo/icon at top of login screen (same shield icon, smaller)
// Add welcoming heading: "Welcome back" bold, subtitle: "Sign in to continue"
// Input fields: rounded corners (kInputRadius), filled background, prefix icons
//   - Email: Icons.email_outlined
//   - Password: Icons.lock_outlined, suffix eye toggle (already exists — keep it)
// "Forgot Password?" — right-aligned, primary color
// Login button — full width, rounded (kButtonRadius), primary color
// "Continue with Google" button — outlined, full width, Google 'G' icon, below login button
// "Don't have an account? Create one" — centered at bottom
```

Input field style to apply globally:
```dart
InputDecoration(
  filled: true,
  fillColor: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
  border: OutlineInputBorder(
    borderRadius: kInputRadius,
    borderSide: BorderSide.none,
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: kInputRadius,
    borderSide: BorderSide(color: kPrimaryColor, width: 1.5),
  ),
  prefixIcon: Icon(Icons.email_outlined, color: Colors.grey),
  hintStyle: TextStyle(color: Colors.grey[400]),
)
```

### B4. Register screen improvements

Add placeholder hints and helper text:
```dart
// Full Name field:
//   hintText: 'e.g. John Doe'
//   prefixIcon: Icons.person_outlined

// Email field:
//   hintText: 'e.g. john@business.co.ke'
//   prefixIcon: Icons.email_outlined
//   helperText: 'Use your business email if possible'

// Phone Number field:
//   hintText: 'e.g. 0712 345 678'
//   prefixIcon: Icons.phone_outlined
//   helperText: 'Used for SMS compliance alerts'
//   Add +254 prefix selector or just show hint

// Password field:
//   hintText: 'Min. 8 characters'
//   prefixIcon: Icons.lock_outlined
//   obscureText: true with eye toggle
//   helperText: 'Use letters, numbers, and symbols'

// Add a "Confirm Password" field below Password
// Validate they match before allowing register tap

// Below Register button:
// "Already have an account? Sign in" link
```

### B5. Forgot Password — 3-step OTP flow

Replace the current single-step screen with a 3-step flow matching the backend:

**Step 1 — ForgotPasswordScreen:**
- Email input with hint "Enter your registered email"
- "Send OTP" button → `POST /api/auth/forgot-password`
- On success → navigate to VerifyOTPScreen, passing email

**Step 2 — VerifyOTPScreen (new screen):**
- Title: "Enter the 6-digit OTP"
- Subtitle: "Sent to your email. Valid for 15 minutes."
- 6 individual digit boxes (use a `Row` of 6 `SizedBox` TextFields, each width 40, maxLength 1, centered)
- Auto-focus next box on each digit entry
- "Verify OTP" button → `POST /api/auth/verify-reset-otp`
- On success → navigate to ResetPasswordScreen, passing email + OTP token

**Step 3 — ResetPasswordScreen (new screen):**
- New password + Confirm password fields
- Color-code validation:
  - Passwords don't match → red border + red helper text "Passwords do not match"
  - Passwords match → green border + green helper text "Passwords match ✓"
- "Reset Password" button → `POST /api/auth/reset-password`
- On success → navigate to LoginScreen with SnackBar "Password reset! Please log in."

### B6. Dashboard — fix error banner + improve cards

- Remove the error banner entirely once data type mismatch is fixed (A1)
- Stats cards: use rounded cards (kCardRadius) with subtle shadow
- Color code the compliance score:
  - 0–40%: red text
  - 41–70%: amber/orange text
  - 71–100%: green text
- Add a `LinearProgressIndicator` under compliance score showing the percentage visually

### B7. Profile page — Change Password at bottom

Move "Change Password" section to the very bottom of the profile page:

```dart
// At the bottom of profile ScrollView:
Divider(),
const SizedBox(height: kSpacingM),
Text('Security', style: Theme.of(context).textTheme.titleMedium),
const SizedBox(height: kSpacingM),

// Current Password field
// New Password field  
// Confirm New Password field
// Color coding:
//   - New == Current → red: "New password must differ from current password"
//   - Confirm != New → red: "Passwords do not match"
//   - All good → green: "Ready to update ✓"

ElevatedButton(
  onPressed: _handleChangePassword,
  child: const Text('Update Password'),
)
```

### B8. Continue with Google

Add to Login screen and Register screen:

```dart
// Add google_sign_in package to pubspec.yaml:
// google_sign_in: ^6.2.1

OutlinedButton.icon(
  onPressed: _handleGoogleSignIn,
  icon: Image.asset('assets/icons/google_logo.png', width: 20),
  // or use a simple 'G' text if no asset
  label: const Text('Continue with Google'),
  style: OutlinedButton.styleFrom(
    minimumSize: const Size(double.infinity, 50),
    shape: RoundedRectangleBorder(borderRadius: kButtonRadius),
    side: BorderSide(color: Colors.grey[300]!),
  ),
)

// Google Sign-In flow:
Future<void> _handleGoogleSignIn() async {
  final googleUser = await GoogleSignIn().signIn();
  if (googleUser == null) return; // user cancelled
  final googleAuth = await googleUser.authentication;
  // Send ID token to backend
  await _authService.loginWithGoogle(googleAuth.idToken!);
  // POST /api/auth/google with { "token": idToken }
}
```

Add `assets/icons/google_logo.png` — download the official Google 'G' icon or use a text fallback.

---

## PART C — API ENDPOINTS AUDIT

Verify every endpoint below is correctly called in the Flutter app. If any are missing, create the service method.

### Auth (`lib/services/auth_service.dart`)
```dart
Future<void> register(Map body)          // POST /api/auth/register
Future<Map> login(String email, String password)  // POST /api/auth/login
Future<void> loginWithGoogle(String idToken)      // POST /api/auth/google
Future<void> verifyOtp(String otp)               // POST /api/auth/verify-otp
Future<void> requestOtp()                         // POST /api/auth/request-otp
Future<void> forgotPassword(String email)         // POST /api/auth/forgot-password
Future<void> verifyResetOtp(String email, String otp)  // POST /api/auth/verify-reset-otp
Future<void> resetPassword(String email, String otp, String newPassword) // POST /api/auth/reset-password
Future<void> changePassword(String current, String newPass) // POST /api/auth/change-password
```

### Vault (`lib/services/vault_service.dart`)
```dart
Future<List<Document>> getDocuments()            // GET /api/vault/documents
Future<Document> getDocument(int id)             // GET /api/vault/documents/{id}
Future<void> uploadDocument(File file, String title, String type) // POST /api/vault/documents (multipart)
```

### Dashboard (`lib/services/dashboard_service.dart`)
```dart
Future<DashboardSummary> getSummary()            // GET /api/dashboard/summary
```

### Notifications (`lib/services/notification_service.dart`)
```dart
Future<List<AppNotification>> getNotifications() // GET /api/notifications/
Future<void> markAsRead(int id)                  // PUT /api/notifications/{id}/read
```

### Profile (`lib/services/profile_service.dart`)
```dart
Future<UserProfile> getProfile()                 // GET /api/profile/
Future<void> updateProfile(Map body)             // PUT /api/profile/
```

### Knowledge Base (`lib/services/knowledge_service.dart`)
```dart
Future<List> getIndustries()    // GET /api/knowledge/industries
Future<List> getCounties()      // GET /api/knowledge/counties
Future<List> getItems()         // GET /api/knowledge/items
Future<Map> getItem(int id)     // GET /api/knowledge/item/{id}
Future<List> search(String q)   // GET /api/knowledge/search?q=...
Future<Map> checkCompliance(Map body) // POST /api/knowledge/compliance/check
```

---

## PART D — GENERAL POLISH

1. Add `CircularProgressIndicator` on every button while an API call is in progress — disable the button to prevent double-taps.
2. All SnackBars should use `ScaffoldMessenger.of(context).showSnackBar(...)` — never `showDialog` for simple messages.
3. Error SnackBars: red background. Success SnackBars: green background.
4. Every screen that fetches data should show a `Shimmer` loading skeleton or `CircularProgressIndicator` centered while loading — never a blank screen.
5. Add `RefreshIndicator` (pull-to-refresh) on Dashboard, Vault, Permits, and Notifications screens.

---

## SUMMARY — ORDER OF EXECUTION

1. Fix all `fromJson` null-safety issues (A1) — **highest priority, unblocks everything**
2. Fix dark theme consistency (A2)
3. Fix pixel overflow (A3)
4. Redesign Landing → single "Get Started" (B2)
5. Improve Login with Google + hints (B3, B8)
6. Improve Register with hints + confirm password (B4)
7. Implement 3-step Forgot Password flow (B5)
8. Dashboard card styling + compliance color coding (B6)
9. Change Password at bottom of Profile (B7)
10. Audit and fill missing API endpoints (C)
11. Loading states, SnackBars, pull-to-refresh (D)
