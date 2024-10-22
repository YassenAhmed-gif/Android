import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_app/shared/cubit/egyptian_cubit/Meal_cubit.dart';
import 'package:meal_app/shared/utils/meal_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Main Dish",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
              color: Colors.white
          ),
        ),
        backgroundColor: Colors.orange,
      ),
      body: BlocConsumer<Meals_cubit, Meals_state>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is GetHomeDataLoading){
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is GetHomeDataWithError){
            return const Center(
              child: Text(
                  "Error while getting home data"
              ),
            );
          } else {
            var cubit = Meals_cubit.get(context);
            return Padding(
              padding: const EdgeInsets.all(20),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                ),
                itemBuilder: (context, index) {
                  return MealCard(meal: cubit.homeData!.meals![index]);
                },
                itemCount: cubit.homeData!.meals!.length,
              ),
            );
          }
        },
      ),
    );
  }
}
