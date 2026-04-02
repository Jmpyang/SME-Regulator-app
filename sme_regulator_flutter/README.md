# SME Compliance Navigator Mobile

This is the Flutter frontend mobile application for the SME Compliance Navigator, connecting to the existing FastAPI backend.

## Architecture

- **HTTP Client**: `dio` with interceptors for `Authorization: Bearer <token>`
- **Local Storage**: `flutter_secure_storage` for JWT, `shared_preferences` for non-sensitive data.
- **State Management**: `provider`
- **Models**: Built with `json_serializable`

## Commands

Before running the application, ensure you generate the JSON serialization files:

```bash
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

Then run the app using:

```bash
flutter run
```
