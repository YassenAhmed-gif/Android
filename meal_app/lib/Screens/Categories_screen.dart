import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_app/shared/cubit/egyptian_cubit/Meal_cubit.dart';
import 'package:meal_app/shared/utils/category_card.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {

  @override
  void initState() {
    super.initState();
    Meals_cubit.get(context).getCategoryData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<Meals_cubit, Meals_state>(
        listener: (context, state) {},
        builder: (context, state) {
          if(state is GetCategoryDataLoading){
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is GetCategoryDataWithError){
            return Center(
              child: Text(
                  "Error while getting home data${state.error}"
              ),
            );
          } else if (state is GetCategoryDataSuccessfully && Meals_cubit.get(context).categoryData!.categories != null){
            var cubit = Meals_cubit.get(context);
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                ),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {

                    },
                    child: CategoryCard(category: cubit.categoryData!.categories![index]),
                  );
                },
                itemCount: cubit.categoryData!.categories!.length,
              ),
            );
          } else {
            return const Center(
              child: Text("No categories found"),
            );
          }
        },
      ),
    );
  }
}