import 'package:dynamic_color/dynamic_color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'screens/auth_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/splash_screen.dart';
import 'styles/app_theme.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
	FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (
        ColorScheme? lightColorScheme,
        ColorScheme? darkColorScheme,
      ) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Gabba Gabba Hey',
          theme: AppTheme.lightTheme(lightColorScheme),
          darkTheme: AppTheme.darkTheme(darkColorScheme),
          home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, user) {
							if (user.connectionState == ConnectionState.waiting) {
								return const SplashScreen();
							}
              if (!user.hasData) {
                return const AuthScreen();
              }
              return const ChatScreen();
            },
          ),
        );
      },
    );
  }
}
