import 'package:travelmate/db/travelmatedb.dart';
import 'package:travelmate/models/sessions.dart';

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

  static Future getAllUserAccount() async {
    var db = await TravelMateDb.openDb();
    var acc = await db.query(User.tableName);
    print(acc);
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

  static Future checkAccount(
      {required String email, required String pass}) async {
    var db = await TravelMateDb.openDb();
    var users = await db.query(
      User.tableName,
      where: "${User.email} = ? and ${User.password} = ?",
      whereArgs: [email, pass],
    );

    if (users.isEmpty) {
      return null;
    }

    return users.first;
  }

  static Future<Map<String, dynamic>> getUserInfo({required int userid}) async {
    var db = await TravelMateDb.openDb();
    var users = await db.query(
      User.tableName,
      where: "${User.userId} = ?",
      whereArgs: [userid],
    );

    return users.first;
  }

  static Future<Map<String, dynamic>> updateUserProfile(
      {required Map<String, dynamic> user, required int userid}) async {
    var db = await TravelMateDb.openDb();
    await db.update(
      User.tableName,
      user,
      where: "${User.userId} = ?",
      whereArgs: [userid],
    );

    var users = await db.query(
      User.tableName,
      where: "${User.userId} = ?",
      whereArgs: [userid],
    );

    print("USER PROFILE UPDATED");
    return users.first;
  }
}
