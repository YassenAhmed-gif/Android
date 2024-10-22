import 'package:flutter/material.dart';
import 'package:meal_app/models/catigory_model.dart';
import 'package:meal_app/shared/constants/constants.dart';

class CategoryCard extends StatelessWidget {
  final Categories category;
  const CategoryCard({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {

      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  category.strCategoryThumb ?? PLACEHOLDERIMAGE,
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
                    category.strCategory ?? "[strCategory]",
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
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
