import 'package:travelmate/db/travelmatedb.dart';
import 'package:travelmate/db/userdb.dart';

class NotificationContent {
  static const String tableName = "notificationcontent";
  static const String notifContentId = "notifcontentid";
  static const String notifType = "notiftype";
  static const String notifTitle = "notiftitle";
  static const String notifContent = "notifcontent";
  static const String notifDate = "notifdate";
  static const String notifTime = "notiftime";
  static const String useridfk = "useridfk";

  static Future addNewNotification(
      {required Map<String, dynamic> notif}) async {
    var db = await TravelMateDb.openDb();
    await db.insert(NotificationContent.tableName, notif);
    print("NOTIFICATION ADDED");
    print(notif);
  }

  static Future deleteAll() async {
    var db = await TravelMateDb.openDb();
    await db.delete(NotificationContent.tableName);
    print("TEMP LOC NOTIF");
  }

  static Future<List<Map<String, dynamic>>> getAllUserNotification(
      {required int userid}) async {
    var db = await TravelMateDb.openDb();
    var notifs = await db.query(
      NotificationContent.tableName,
      where: "${NotificationContent.useridfk} = ?",
      whereArgs: [userid],
    );

    return notifs;
  }
}
