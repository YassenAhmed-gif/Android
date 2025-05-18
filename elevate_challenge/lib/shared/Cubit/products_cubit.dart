import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elevate_challenge/model/products_model.dart';
import 'package:elevate_challenge/shared/network/remote/dio_helper.dart';
import 'package:elevate_challenge/shared/network/remote/endpoints.dart';

part 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  ProductsCubit() : super(ProductsInitial());

  List<products_model> _products = [];
  List<products_model> get products => _products;

  // Fetch all products
  Future<void> getAllProducts() async {
    emit(ProductsLoading());
    try {
      final response = await DioHelper.getRequest(
        endPoint: PRODUCTS// Make sure PRODUCTS is defined in your endpoints
      );
      if (response.statusCode == 200) {
        _products = (response.data as List)
            .map((json) => products_model.fromJson(json))
            .toList();
        emit(ProductsLoaded(_products));
      } else {
        emit(ProductsError('Failed to load products: ${response.statusCode}'));
      }
    } on DioException catch (e) {
      emit(ProductsError(e.response?.data['message'] ?? e.message ?? 'Failed to fetch products'));
    } catch (e) {
      emit(ProductsError('An unexpected error occurred'));
    }
  }

  // Fetch single product by ID
  Future<void> getProductById(int id) async {
    emit(ProductDetailsLoading());
    try {
      final response = await DioHelper.getRequest(
        endPoint:  '$PRODUCTS/$id', // Endpoint for single product
      );
      if (response.statusCode == 200) {
        final product = products_model.fromJson(response.data);
        emit(ProductDetailsLoaded(product));
      } else {
        emit(ProductDetailsError('Failed to load product: ${response.statusCode}'));
      }
    } on DioException catch (e) {
      emit(ProductDetailsError(e.response?.data['message'] ?? e.message ?? 'Failed to fetch product'));
    } catch (e) {
      emit(ProductDetailsError('An unexpected error occurred'));
    }
  }
}
