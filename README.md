# Rosewater Cafe

Rosewater Cafe is a Flutter mobile application for member authentication, profiles, memberships, usage tracking, event reservations, notifications, and door-access requests.

## Technology stack

- Flutter and Dart
- Firebase Authentication
- Cloud Firestore
- Firebase App Check

## Project configuration

- Android package: `com.rosewatercafe.app`
- Firebase project: `rosewater-cafe-app`

Firebase client configuration is generated in `lib/firebase_options.dart`. Do not add Firebase service-account credentials, signing material, or App Check debug tokens to this repository.

## Local setup and run

1. Install a compatible Flutter SDK and Android SDK.
2. From the project root, fetch dependencies:

   ```bash
   flutter pub get
   ```

3. Run on a connected device or emulator:

   ```bash
   flutter run
   ```

For local web App Check validation only, use the ignored `config/app_check_debug.json` as a private reference. Start from `config/app_check_debug.example.json`; never commit a real debug token. Normal web builds use reCAPTCHA Enterprise and Android release builds use Play Integrity.

## Validation and release build

Static analysis:

```bash
flutter analyze
```

Web build:

```bash
flutter build web
```

Android release APK:

```bash
flutter build apk --release
```

The generated APK is at `build/app/outputs/flutter-apk/app-release.apk`.

## Firestore security regression tests

The Firestore security test suite requires the Firebase CLI and Firestore Emulator. From the project root on Windows PowerShell:

```powershell
$env:JAVA_HOME = 'E:\Android\jbr'
$env:Path = "$env:JAVA_HOME\bin;$env:Path"
firebase --config .\firebase.json emulators:exec --only firestore "npm --prefix security_tests test"
```

## Current technical notes

- Some Firebase plugins currently emit Flutter's future Built-in Kotlin migration warning. The current Android release APK builds successfully; this is non-blocking technical debt, not a release-build failure.
- Notification **View Details** intentionally remains a placeholder; it does not yet open reservation detail content.
- Local release validation used an Android emulator for APK installation and launch. Production Android App Check uses Play Integrity, so protected Firebase calls must also be verified on a suitable physical device before live distribution.
- Door Access produces the application-side request/QR flow. Physical turnstile and hardware-backend integration are outside this repository.
