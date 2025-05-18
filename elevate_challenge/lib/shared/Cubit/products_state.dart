part of 'products_cubit.dart';

abstract class ProductsState {}

class ProductsInitial extends ProductsState {}

class ProductsLoading extends ProductsState {}
class ProductsLoaded extends ProductsState {
  final List<products_model> products;
  ProductsLoaded(this.products);
}
class ProductsError extends ProductsState {
  final String message;
  ProductsError(this.message);
}

class ProductDetailsLoading extends ProductsState {}
class ProductDetailsLoaded extends ProductsState {
  final products_model product;
  ProductDetailsLoaded(this.product);
}
class ProductDetailsError extends ProductsState {
  final String message;
  ProductDetailsError(this.message);
}