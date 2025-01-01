import 'package:travelmate/db/travelmatedb.dart';

class User {
  static const String tableName = "user";
  static const String userId = "userid";
  static const String username = "username";
  static const String email = "email";
  static const String password = "password";
  static const String imgURL = "imgURL";

  static Future<int> addNewUser({required Map<String, dynamic> user}) async {
    var db = await TravelMateDb.openDb();
    int id = await db.insert(User.tableName, user);
    print("USER ADDED");
    return id;
  }

  static Future isUserExists({required String email}) async {
    var db = await TravelMateDb.openDb();
    var users = await db.query(
      User.tableName,
      where: "${User.email} = ?",
      whereArgs: [email],
    );

    return users.isNotEmpty;
  }

  static Future<int> checkAccount(
      {required String email, required String pass}) async {
    var db = await TravelMateDb.openDb();
    var users = await db.query(
      User.tableName,
      where: "${User.email} = ? and ${User.password} = ?",
      whereArgs: [email, pass],
    );

    if (users.isEmpty) {
      return 0;
    }

    return users.first[User.userId] as int;
  }
}