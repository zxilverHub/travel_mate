import 'package:travelmate/db/travelmatedb.dart';

class PrivateChat {
  static const String tableName = "privatechat";
  static const String pChatId = "pchatid";
  static const String senderIdFk = "senderidfk";
  static const String receiverIdFk = "receiveridfk";

  static Future addDummyChats() async {
    var db = await TravelMateDb.openDb();
    await db.insert(PrivateChat.tableName, {
      PrivateChat.senderIdFk: 1,
      PrivateChat.receiverIdFk: 2,
    });
    print("PRIVATE CHATS ADDED");
  }

  static Future<int> addNewPrivateChat(
      {required int user1, required int user2}) async {
    var db = await TravelMateDb.openDb();
    return await db.insert(PrivateChat.tableName, {
      PrivateChat.senderIdFk: user1,
      PrivateChat.receiverIdFk: user2,
    });
  }

  static Future<List<Map<String, dynamic>>> fetchAllUserPrivateChats(
      {required int userid}) async {
    var db = await TravelMateDb.openDb();
    var chats = await db.query(
      PrivateChat.tableName,
      where: "${PrivateChat.senderIdFk} = ? or ${PrivateChat.receiverIdFk} = ?",
      whereArgs: [userid, userid],
    );

    return chats;
  }

  static Future checkIfHaveChatHistory(
      {required int user1, required int user2}) async {
    var db = await TravelMateDb.openDb();
    var chats = await db.query(
      PrivateChat.tableName,
      where:
          "(${PrivateChat.senderIdFk} = ? AND ${PrivateChat.receiverIdFk} = ?) "
          "OR (${PrivateChat.senderIdFk} = ? AND ${PrivateChat.receiverIdFk} = ?)",
      whereArgs: [user1, user2, user2, user1],
    );

    if (chats.isEmpty) {
      return null;
    }

    return chats.first[PrivateChat.pChatId];
  }

  static Future<Map<String, dynamic>> getPrivateChatInfo(
      {required int pcId}) async {
    var db = await TravelMateDb.openDb();
    var chats = await db.query(
      PrivateChat.tableName,
      where: "${PrivateChat.pChatId} = ?",
      whereArgs: [pcId],
    );

    return chats.first;
  }
}
