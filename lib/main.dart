import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:tigrid_machine_test/pages/error_screen.dart';
import 'package:tigrid_machine_test/pages/home_page.dart';
import 'package:tigrid_machine_test/pages/loading_screen.dart';
import 'package:tigrid_machine_test/pages/login_screen.dart';
import 'package:tigrid_machine_test/services/api_service.dart';
import 'package:tigrid_machine_test/services/auth_service.dart';
import 'firebase_options.dart';

void main() async{
   WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData.dark(
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MultiProvider(
        providers: [
        ChangeNotifierProvider(
          create: (_) => ApiService(),
        ),
      ],
        child: StreamBuilder(
          stream: AuthService().authStateChangesFromFirebase,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return const HomePage();
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoadingScreen();
            } else if (snapshot.hasError) {
              return const ErrorScreen();
            } else {
              return const LoginScreen();
            }
          },
        ),
      )
    );
  }
}
