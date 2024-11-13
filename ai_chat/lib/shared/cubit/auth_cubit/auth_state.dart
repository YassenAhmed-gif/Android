part of 'auth_cubit.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

class RegisterLoading extends AuthState{}
class RegisterSuccess extends AuthState{}
class RegisterWithError extends AuthState{}

class LoginLoading extends AuthState{}
class LoginSuccess extends AuthState{}
class LoginWithError extends AuthState{}
