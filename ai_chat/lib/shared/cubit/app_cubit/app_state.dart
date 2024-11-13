part of 'app_cubit.dart';

@immutable
sealed class AppState {}

final class AppInitial extends AppState {}
// giminai text
final class ResponceLoading extends AppState{}
final class ResponceSuccess extends AppState{}
final class ResponceWithError extends AppState{}
// user text
final class SendLoading extends AppState{}
final class SendSuccess extends AppState{}
final class SendWithError extends AppState{}
// pick & crop PIC
final class PickedImageSuccessfully extends AppState {}
final class PickedImageWithError extends AppState {}
final class CroppedSuccesfully extends AppState {}
// upload PIC to cloudinary
final class UploadLoading extends AppState {}
final class UploadSuccess extends AppState {}
final class UploadWithError extends AppState {}
// getAllChats
final class getChatsLoading extends AppState{}
final class getChatssuccess extends AppState{}
final class getChatsWithError extends AppState{}
// getAllMassages
final class getMassagesLoading extends AppState{}
final class getMassagesSuccess extends AppState{}
final class getMassagesWithError extends AppState{}
