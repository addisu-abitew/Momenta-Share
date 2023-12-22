import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:momenta_share/firebase_options.dart';
import 'package:momenta_share/pages/HomeScreen.dart';
import 'package:momenta_share/pages/LoginScreen.dart';
import 'package:momenta_share/providers/UserProvider.dart';
import 'package:momenta_share/services/AuthMethods.dart';
import 'package:momenta_share/utils/colors.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // AuthMethods.signOut(); 
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => UserProvider())],
      child: MaterialApp(
          title: 'MomentaShare',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              fontFamily: 'Kalnia',
              scaffoldBackgroundColor: mobileBackground,
              colorScheme: const ColorScheme(
                  brightness: Brightness.dark,
                  primary: Colors.orange,
                  onPrimary: Colors.orangeAccent,
                  secondary: Colors.yellow,
                  onSecondary: Colors.yellowAccent,
                  error: Colors.red,
                  onError: Colors.redAccent,
                  background: Colors.black,
                  onBackground: Colors.white,
                  surface: Colors.black,
                  onSurface: Colors.white),
              elevatedButtonTheme: ElevatedButtonThemeData(
                  style: ButtonStyle(
                elevation: const MaterialStatePropertyAll(5),
                backgroundColor:
                    MaterialStatePropertyAll(Colors.white.withOpacity(0.25)),
                foregroundColor: const MaterialStatePropertyAll(Colors.white),
              ),
            ),
          ),
          home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                    body: Center(child: CircularProgressIndicator()));
              } else if (snapshot.hasData) {
                return const HomeScreen();
              } else {
                return const LoginScreen();
              }
            },
          )),
    );
  }
}
