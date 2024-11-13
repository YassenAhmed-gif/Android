
class UserModel{
  late int userId;
  late String email;


  UserModel({
    required this.email,
    required this.userId ,
  });

  UserModel.fromJson(Map<String,dynamic>json){
    email = json["email"];
    userId = json["user_id"];
  }

  Map<String,dynamic> toMap(){
    return {
      "email":email,
      "user_id":userId,
    };
  }
}
