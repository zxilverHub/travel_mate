import 'package:travelmate/db/travelmatedb.dart';

class Community {
  static const String tableName = "community";
  static const String comId = "comid";
  static const String comStreet = "comstreet";
  static const String comCity = "comcity";
  static const String comProvince = "comprovince";

  static Future isCommunityExists({
    required String street,
    required String city,
    required String province,
  }) async {
    var db = await TravelMateDb.openDb();
    var coms = await db.query(
      Community.tableName,
      where:
          "${Community.comStreet} = ? and ${Community.comCity} = ? and ${Community.comProvince} = ?",
      whereArgs: [street, city, province],
    );

    if (coms.isEmpty) {
      return null;
    }
    return coms.first[Community.comId];
  }

  static Future<int> addNewCommnunity({
    required Map<String, dynamic> com,
  }) async {
    var db = await TravelMateDb.openDb();
    int comid = await db.insert(Community.tableName, com);
    print("COM ADDED");
    return comid;
  }

  static Future<Map<String, dynamic>> getCommunityInfo({
    required int comid,
  }) async {
    var db = await TravelMateDb.openDb();
    var coms = await db.query(
      Community.tableName,
      where: "${Community.comId} = ?",
      whereArgs: [comid],
    );

    return coms.first;
  }
}
