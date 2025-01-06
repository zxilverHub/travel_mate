import 'package:travelmate/db/travelmatedb.dart';

class Chat {
  static const String tableName = "chat";
  static const String chatId = "chatid";
  static const String comIdFk = "comidfk";
  static const String userIdFk = "useridfk";
  static const String chatType = "chattype";
  static const String chatDate = "chatdate";
  static const String chatTime = "chattime";
  static const String chatContent = "chatcontent";

  static Future adNewChat({
    required Map<String, dynamic> chat,
  }) async {
    var db = await TravelMateDb.openDb();
    await db.insert(Chat.tableName, chat);
    print("NEW CHAT ADDED");
  }

  static Future<List<Map<String, dynamic>>> fetchAllChatsFromCom(
      {required int comid}) async {
    var db = await TravelMateDb.openDb();
    var chats = await db.query(
      Chat.tableName,
      where: "${Chat.comIdFk} = ?",
      whereArgs: [comid],
    );

    print("GET");
    return chats;
  }

  static Future deleteAllChats() async {
    var db = await TravelMateDb.openDb();
    await db.delete(Chat.tableName);
    print("DELETED ALL CHATS");
  }

  static Future deleteMessage({required int chatid}) async {
    var db = await TravelMateDb.openDb();
    await db.delete(
      Chat.tableName,
      where: "${Chat.chatId} = ?",
      whereArgs: [chatid],
    );

    print("CHAT DELETED");
  }

  static Future<Map<String, dynamic>> getLasChat({required int comid}) async {
    var db = await TravelMateDb.openDb();
    var chats = await db.query(
      Chat.tableName,
      where: "${Chat.comIdFk} = ?",
      whereArgs: [comid],
    );

    return chats.last;
  }
}
