import 'package:ai_chat/screens/home_screen.dart';

import 'screens/Login_screen.dart';
import 'screens/home_screen.dart';
import 'shared/cubit/auth_cubit/auth_cubit.dart';
import 'shared/cubit/app_cubit/app_cubit.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'index.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // initialize some code natively
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider( create: (context) => AuthCubit(),),
        BlocProvider( create: (context) => AppCubit()),
      ],

      child: ScreenUtilInit(
        designSize: const Size(390, 844),
        builder: (context, child) {
          if (FirebaseAuth.instance.currentUser != null){
            return const MaterialApp(
              home: ChatBotApp(),
            );
          } else {
            return const MaterialApp(
              home: LoginScreen(),
            );
          }
        }
      )
    );
  }
}