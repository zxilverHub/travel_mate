import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:travelmate/db/travelmatedb.dart';
import 'package:travelmate/db/userdb.dart';
import 'package:travelmate/models/sessions.dart';

class NotificationContent {
  static const String tableName = "notificationcontent";
  static const String notifContentId = "notifcontentid";
  static const String notifType = "notiftype";
  static const String notifTitle = "notiftitle";
  static const String notifContent = "notifcontent";
  static const String notifDate = "notifdate";
  static const String notifTime = "notiftime";
  static const String useridfk = "useridfk";
  static const String isread = "isread";

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

  static Future markAllAsRead(
      {required Map<String, dynamic> notif, required int userid}) async {
    var db = await TravelMateDb.openDb();
    await db.update(
      NotificationContent.tableName,
      notif,
      where: "${NotificationContent.useridfk} = ?",
      whereArgs: [userid],
    );

    print("MARKED AS READ");
  }

  static Future markAsRead({required int userid, required int notifid}) async {
    var db = await TravelMateDb.openDb();
    await db.update(
      NotificationContent.tableName,
      {
        NotificationContent.isread: 1,
      },
      where:
          "${NotificationContent.useridfk} = ? and ${NotificationContent.notifContentId} = ?",
      whereArgs: [userid, notifid],
    );

    print("MARKED AS READ");
  }

  static Future addSosNotifToAllUsers({required int sosid}) async {
    var db = await TravelMateDb.openDb();
    var users = await db.query(User.tableName);

    var dateFormat = DateFormat("MMM, d, yyyy");
    TimeOfDay currentTime = TimeOfDay.now();
    String formattedTime =
        '${currentTime.hourOfPeriod}:${currentTime.minute} ${currentTime.period == DayPeriod.am ? 'AM' : 'PM'}';

    for (int i = 0; i < users.length; i++) {
      await NotificationContent.addNewNotification(
        notif: {
          NotificationContent.notifType: "sos",
          NotificationContent.notifTitle: "SOS Alert",
          NotificationContent.notifContent: "$sosid",
          NotificationContent.notifDate: dateFormat.format(DateTime.now()),
          NotificationContent.notifTime: formattedTime,
          NotificationContent.isread: 0,
          NotificationContent.useridfk: users[i][User.userId],
        },
      );
    }

    print("NOTIF ALERT ADDED");
  }

  static Future resetlSOSNotif() async {
    var db = await TravelMateDb.openDb();
    await db.delete(
      NotificationContent.tableName,
      where: "${NotificationContent.notifType} = ?",
      whereArgs: ["sos"],
    );

    print("DELETED");
  }
}
