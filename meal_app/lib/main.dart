import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_app/shared/cubit/egyptian_cubit/egyptian_cubit.dart';
import 'package:meal_app/shared/network/remote/dio_helper.dart';
import 'package:meal_app/Screens/Categories_screen.dart';
import 'package:meal_app/Screens/home_screen.dart';
import 'package:meal_app/layout/main_layout.dart';
import 'package:meal_app/Screens/meal_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DioHelper.initializeDio();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EgyptianCubit()..getHomeData(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MealScreen(mealId: "52772"),
      ),
    );
  }
}

