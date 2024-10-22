part of 'egyptian_cubit.dart';

@immutable
sealed class EgyptianState {}

final class EgyptianInitial extends EgyptianState {}


//HomeData
class GetHomeDataLoading extends EgyptianState{}
class GetHomeDataSuccessfully extends EgyptianState{}
class GetHomeDataWithError extends EgyptianState{
  String error;
  GetHomeDataWithError(this.error);
}

//CategoryData
class GetCategoryDataLoading extends EgyptianState{}
class GetCategoryDataSuccessfully extends EgyptianState{}
class GetCategoryDataWithError extends EgyptianState{
  String error;
  GetCategoryDataWithError(this.error);
}

//RandomData
class GetRandomDataLoading extends EgyptianState{}
class GetRandomDataSuccessfully extends EgyptianState{}
class GetRandomDataWithError extends EgyptianState{
  String error;
  GetRandomDataWithError(this.error);
}

//MealDetails
class GetMealLoading extends EgyptianState {}
class GetMealSuccessfully extends EgyptianState {}
class GetMealWithError extends EgyptianState {
  String error;
  GetMealWithError(this.error);
}
