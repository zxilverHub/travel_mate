import 'package:travelmate/db/privatechatdb.dart';
import 'package:travelmate/db/travelmatedb.dart';

class ChatContent {
  static const String tableName = "chatcontent";
  static const String contentId = "contentid";
  static const String pChatIdFk = "pchatidfk";
  static const String contentType = "contenttype";
  static const String content = "content";
  static const String userIdFk = "useridfk";
  static const String chatDate = "chatdate";
  static const String chatTime = "chattime";

  static Future addDummyChats() async {
    var db = await TravelMateDb.openDb();
    await db.insert(ChatContent.tableName, {
      ChatContent.pChatIdFk: 1,
      ChatContent.contentType: "text",
      ChatContent.content: "PRIVATE CHAT 1",
      ChatContent.userIdFk: 1,
      ChatContent.chatDate: "Jan, 3 2025",
      ChatContent.chatTime: "10:30pm",
    });

    await db.insert(ChatContent.tableName, {
      ChatContent.pChatIdFk: 1,
      ChatContent.contentType: "text",
      ChatContent.content: "PRIVATE CHAT 2",
      ChatContent.userIdFk: 2,
      ChatContent.chatDate: "Jan, 3 2025",
      ChatContent.chatTime: "10:30pm",
    });
    print("CHATS ADDED");
  }

  static Future addNewChatContent(
      {required Map<String, dynamic> content}) async {
    var db = await TravelMateDb.openDb();
    await db.insert(ChatContent.tableName, content);
    print("CONTENT ADDED");
  }

  static Future<List<Map<String, dynamic>>> getAllChats(
      {required int pchatid}) async {
    var db = await TravelMateDb.openDb();
    var chats = await db.query(
      ChatContent.tableName,
      where: "${ChatContent.pChatIdFk} = ?",
      whereArgs: [pchatid],
    );

    return chats;
  }

  static Future<Map<String, dynamic>> getLastChat(
      {required int pChatId}) async {
    var db = await TravelMateDb.openDb();
    var chats = await db.query(
      ChatContent.tableName,
      where: "${ChatContent.pChatIdFk} = ?",
      whereArgs: [pChatId],
    );

    return chats.last;
  }
}
