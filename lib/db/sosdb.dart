import 'package:travelmate/db/travelmatedb.dart';

class Sos {
  static const String tableName = "sos";
  static const String sosId = "sosid";
  static const String userIdFk = "useridfk";
  static const String comIdFk = "comidfk";
  static const String sosDate = "sosdate";
  static const String sosTime = "sostime";
  static const String latitude = "latitude";
  static const String longitude = "longitude";

  static Future<int> addNewSOS({required Map<String, dynamic> sos}) async {
    var db = await TravelMateDb.openDb();
    int id = await db.insert(Sos.tableName, sos);
    print("SOS added");
    return id;
  }

  static Future<Map<String, dynamic>> getSosInfo({required int sosid}) async {
    var db = await TravelMateDb.openDb();
    var soss = await db.query(
      Sos.tableName,
      where: "${Sos.sosId} = ?",
      whereArgs: [sosid],
    );

    return soss.first;
  }
}
