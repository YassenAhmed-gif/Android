import 'package:flutter/material.dart';
import 'package:meal_app/models/area_model.dart';

import 'package:meal_app/shared/constants/constants.dart';

class MealCard extends StatelessWidget {
  final Meals meal;
  const MealCard({super.key, required this.meal});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // 1- get the meal's data
        // 2- navigate to the meal's screen
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  meal.strMealThumb ?? PLACEHOLDERIMAGE,
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.7),
                      Colors.black.withOpacity(0.0),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: Text(
                    meal.strMeal ?? "[strMeal]",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: Colors.white
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
