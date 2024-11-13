import 'package:bloc/bloc.dart';
import 'package:meal_app/models/catigory_model.dart';
import 'package:meal_app/models/meal_model.dart';
import 'package:meta/meta.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_app/models/area_model.dart';
import 'package:meal_app/shared/network/remote/dio_helper.dart';
import 'package:meal_app/shared/network/remote/endPoints.dart';

part 'Meal_state.dart';

class Meals_cubit extends Cubit<Meals_state> {
  Meals_cubit() : super(EgyptianInitial());

  static Meals_cubit get(context) => BlocProvider.of(context);
  area_model? homeData;
  category_model? categoryData;
  meals_model? mealData;

  Future <void> getHomeData() async {
    emit(GetHomeDataLoading());
    try{
      Response response = await DioHelper.getRequest(
          endPoint: FILTER,
          queryParameters: {'a':'Egyptian'}
      );

      if (response.statusCode! == 200 && response.data['meals'] != null){
        homeData = area_model.fromJson(response.data);
        emit(GetHomeDataSuccessfully());
      } else {
        emit(GetHomeDataWithError('no result'));
      }
    }catch(e){
      emit(GetHomeDataWithError(e.toString()));
    }
  }

  Future <void> getCategoryData() async {
    emit(GetCategoryDataLoading());
    try{
      Response response = await DioHelper.getRequest(endPoint: CATEGORY);
      print(response.data);
      if (response.statusCode! == 200 || response.data['categories'] != null){
        categoryData = category_model.fromJson(response.data);
        emit(GetCategoryDataSuccessfully());
      } else {
        emit(GetCategoryDataWithError('no result'));
      }
    }catch(e){
      emit(GetCategoryDataWithError(e.toString()));
    }
  }
  
  Future <void> getMealDetails(String MealId) async {
    emit(GetMealLoading());
    try{
      Response response = await DioHelper.getRequest(
        endPoint: LOOKUP,
        queryParameters: {'i': MealId}
      );
      mealData = meals_model.fromJson(response.data);

      if(response.statusCode! == 200){
        emit(GetMealSuccessfully());
      } else {
        emit(GetMealWithError('no result'));
      }
    }catch(e){
      emit(GetMealWithError(e.toString()));
    }
  }
}
