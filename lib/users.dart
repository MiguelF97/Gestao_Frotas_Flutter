


class Users{
  int userid;
  String userName;
  int userAge;

  Users({
    this.userid,
    this.userName,
    this.userAge
 });

    factory Users.fromJson(Map<String, dynamic> parsedJson){
    return Users(
      userid: parsedJson['id'],
      userName: parsedJson['nome'],
      userAge: parsedJson ['idade']
    );
  }

}