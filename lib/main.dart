import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/foundation.dart';
import 'firebase_options.dart';
import 'screens/splash_screen.dart';

const bool _useWebAppCheckDebug = bool.fromEnvironment(
  'APP_CHECK_WEB_DEBUG',
  defaultValue: false,
);

const String _webAppCheckDebugToken = String.fromEnvironment(
  'APP_CHECK_DEBUG_TOKEN',
  defaultValue: '',
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  if (kIsWeb && _useWebAppCheckDebug && _webAppCheckDebugToken.isEmpty) {
    throw StateError(
      'APP_CHECK_DEBUG_TOKEN is required when APP_CHECK_WEB_DEBUG=true.',
    );
  }

  await FirebaseAppCheck.instance.activate(
    providerAndroid: const AndroidPlayIntegrityProvider(),
    providerWeb: _useWebAppCheckDebug
        ? WebDebugProvider(debugToken: _webAppCheckDebugToken)
        : ReCaptchaEnterpriseProvider(
            '6LfW66YtAAAAAKlUVxt6KiAqOWK5lHW8dw2ES-v4',
          ),
  );
  runApp(const RosewaterApp());
}

class RosewaterApp extends StatelessWidget {
  const RosewaterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(textTheme: GoogleFonts.interTextTheme()),
      title: 'Rosewater Cafe',
      home: const SplashScreen(),
    );
  }
}
