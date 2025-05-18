import 'package:flutter/material.dart';
import 'package:meal_app/models/meal_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_app/shared/cubit/egyptian_cubit/Meal_cubit.dart';
import 'package:meal_app/shared/constants/constants.dart';

class MealScreen extends StatefulWidget {
  final String mealId;

  const MealScreen({super.key, required this.mealId});

  @override
  State<MealScreen> createState() => _MealScreenState();
}

class _MealScreenState extends State<MealScreen> {

  @override
  void initState() {
    super.initState();
    Meals_cubit.get(context).getMealDetails(widget.mealId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meal Details'),
      ),
      body: BlocConsumer<Meals_cubit, Meals_state>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is GetMealLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is GetMealWithError) {
            return Center(
              child: Text("Error while getting meal data: ${state.error}"),
            );
          } else {
            var cubit = Meals_cubit.get(context);
            var meal = cubit.mealData?.meals?.first;

            if (meal == null) {
              return const Center(child: Text("No meal found."));
            }

            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Meal Title
                      Text(
                        meal.strMeal ?? 'Unknown Meal',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Meal Image
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              meal.strMealThumb ?? PLACEHOLDERIMAGE,
                              fit: BoxFit.cover,
                              height: 200,
                              width: double.infinity,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  PLACEHOLDERIMAGE,
                                  height: 200,
                                  width: double.infinity,
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Only show Alternate Drink section if available
                      if (meal.strDrinkAlternate != null)
                        Text(
                          'Alternate Drink: ${meal.strDrinkAlternate}',
                          style: const TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      const SizedBox(height: 20),

                      // Meal Instructions or Description
                      Text(
                        meal.strInstructions ?? 'No instructions available.',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
