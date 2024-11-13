import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'screens/Login_screen.dart';
import 'screens/Home_screen.dart';
import 'shared/cubit/auth_cubit/auth_cubit.dart';
import 'shared/cubit/app_cubit/app_cubit.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // initialize some code natively
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAuth.instance.signOut();
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider( create: (context) => AuthCubit(),),
        BlocProvider( create: (context) => AppCubit(),),
      ],

      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const LoginScreen(),
        // home: FirebaseAuth.instance.currentUser != null ? const HomeScreen():const LoginScreen(),
      ),
    );
  }
}