part of 'app_cubit.dart';

@immutable
sealed class AppState {}

final class AppInitial extends AppState {}

// Chat id
final class getChatIdSuccess extends AppState{}
final class getChatIdError extends AppState{
  String? error;
  getChatIdError({required this.error});
}
// new chat
final class newChatSuccess extends AppState{}
final class newChatError extends AppState{
  String? error;
  newChatError({required this.error});
}
// get all chats
final class getAllChatsLoading extends AppState{}
final class getAllChatsSuccess extends AppState{}
final class getAllChatsError extends AppState{
  String? error;
  getAllChatsError({required this.error});
}

// send message
final class sendMessagesuccess extends AppState{}
final class sendMessageError extends AppState{
  String? error;
  sendMessageError({required this.error});
}
// get all messages
final class getAllMessagesLoading extends AppState{}
final class getAllMessagesSuccess extends AppState{}
final class getAllMessagesError extends AppState{
  String? error;
  getAllMessagesError({required this.error});
}

// get gemini response
final class getGeminiResponseLoading extends AppState{}
final class getGeminiResponseSuccess extends AppState{}
final class getGeminiResponseError extends AppState{
  String? error;
  getGeminiResponseError({required this.error});
}

// pick & crop PIC
final class PickedImageSuccessfully extends AppState {}
final class PickedImageWithError extends AppState {
  String? error;
  PickedImageWithError({required this.error});
}
final class CroppedSuccesfully extends AppState {}
// upload PIC to cloudinary
final class UploadLoading extends AppState {}
final class UploadSuccess extends AppState {}
final class UploadWithError extends AppState {
  String? error;
  UploadWithError({required this.error});
}
// speech to text
