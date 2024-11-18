class UserModel {
  String? username;
  String? avatar;
  String? email;
  String? name;
  UserModel();

  UserModel.fromJson(Map value, String uname) {
    username = uname;
    name = value['name'];
    avatar = value['avatarlink'];
    email = value['email'];
  }
}
