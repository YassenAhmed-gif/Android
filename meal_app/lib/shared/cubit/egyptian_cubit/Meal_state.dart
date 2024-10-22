part of 'Meal_cubit.dart';

@immutable
sealed class Meals_state {}

final class EgyptianInitial extends Meals_state {}


//HomeData
class GetHomeDataLoading extends Meals_state{}
class GetHomeDataSuccessfully extends Meals_state{}
class GetHomeDataWithError extends Meals_state{
  String error;
  GetHomeDataWithError(this.error);
}

//CategoryData
class GetCategoryDataLoading extends Meals_state{}
class GetCategoryDataSuccessfully extends Meals_state{}
class GetCategoryDataWithError extends Meals_state{
  String error;
  GetCategoryDataWithError(this.error);
}

//RandomData
class GetRandomDataLoading extends Meals_state{}
class GetRandomDataSuccessfully extends Meals_state{}
class GetRandomDataWithError extends Meals_state{
  String error;
  GetRandomDataWithError(this.error);
}

//MealDetails
class GetMealLoading extends Meals_state {}
class GetMealSuccessfully extends Meals_state {}
class GetMealWithError extends Meals_state {
  String error;
  GetMealWithError(this.error);
}
