import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:meal_app/shared/cubit/egyptian_cubit/egyptian_cubit.dart';
import 'package:meal_app/shared/network/remote/dio_helper.dart';
import 'package:meal_app/shared/utils/meal_card.dart';

import 'package:meal_app/models/area_model.dart';
import 'package:meal_app/shared/constants/constants.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<EgyptianCubit, EgyptianState>(
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
            var cubit = EgyptianCubit.get(context);
            return Padding(
              padding: const EdgeInsets.all(20),
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
                    child: MealCard(meal: cubit.homeData!.meals![index]),
                  );
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
