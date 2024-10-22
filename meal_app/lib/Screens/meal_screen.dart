import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_app/shared/constants/constants.dart';
import 'package:meal_app/shared/cubit/egyptian_cubit/Meal_cubit.dart';
import 'package:meal_app/models/meal_model.dart';
import 'package:url_launcher/url_launcher.dart';

class MealScreen extends StatelessWidget {
  const MealScreen({super.key});

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
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: double.infinity,
                      child: Text(cubit.mealData!.meals![0].strMeal??"UnKnown",
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.black
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 250,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.network(cubit.mealData!.meals![0].strMealThumb??PLACEHOLDERIMAGE,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Text(cubit.mealData!.meals![0].strInstructions??"NO Instruction",
                      style: TextStyle(
                          fontSize:20,
                          color: Colors.black
                      ),
                      // maxLines: 3,
                      // overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      children: [
                        Text("To know more information",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: ()async{
                            if (!await launchUrl(Uri.parse(cubit.mealData!.meals![0].strYoutube!))) {
                              throw Exception('Could not launch ${cubit.mealData!.meals![0].strYoutube!}');
                            }
                          },
                          child: Text("click here",
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w800,
                                color: Colors.blueAccent.shade700
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text("Ingredient&&Measure",
                      style: TextStyle(
                          fontSize:25,
                          color: Colors.black
                      ),
                    ),
                    ListView.separated(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap:true ,
                      itemBuilder: (context,index){
                        return RowIngredient(cubit.mealData!.meals![0].strIngredient1!, cubit.mealData!.meals![0].strMeasure1!);
                      },
                      separatorBuilder: (context,index){
                        return SizedBox(
                          height: 20,
                        );
                      },
                      itemCount: 2,
                    )
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
  Widget RowIngredient(String Ingredient,String Measure){

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(Ingredient,
          style: TextStyle(
              fontSize:15,
              color: Colors.black
          ),
        ),

        Text(Measure,
          style: TextStyle(
              fontSize:20,
              color: Colors.black
          ),
        ),
      ],
    );
  }

//             return SafeArea(
//               child: Padding(
//                 padding: const EdgeInsets.all(10.0),
//                 child: SingleChildScrollView(
//                   scrollDirection: Axis.vertical,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Container(
//                         width: double.infinity,
//                         child: Text(
//                           cubit.mealData!.meals![0].strMeal! ?? "UnKnown",
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                           textAlign: TextAlign.center,
//                         ),
//                       ),
//                       Container(
//                         width: double.infinity,
//                         height:  250,
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(12),
//                           child: Image.network(cubit.mealData!.meals![0].strMealThumb! ?? PLACEHOLDERIMAGE,
//                           fit: BoxFit.cover
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           }
//         },
//       ),
//     );
//   }
}
