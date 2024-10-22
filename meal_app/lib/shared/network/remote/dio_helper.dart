import 'package:dio/dio.dart';
import 'package:meal_app/shared/constants/constants.dart';

abstract class DioHelper{
  static Dio? _dio;

  static Future<void> initializeDio()async{
    _dio = Dio(
      BaseOptions(
        baseUrl: baseURL,
        receiveDataWhenStatusError: true,
        connectTimeout: const Duration(seconds: 20),
        validateStatus: (status) {
          return (status! < 506);
        },
      ),
    );
  }

//GET
  static Future<Response> getRequest({
    required String endPoint,
    Map<String,dynamic>? queryParameters,
  })async{
    return await _dio!.get(endPoint,queryParameters: queryParameters);
  }
}