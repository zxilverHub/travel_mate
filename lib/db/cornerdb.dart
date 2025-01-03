import 'package:travelmate/db/travelmatedb.dart';

class Corner {
  static const String tableName = "corner";
  static const String cornerId = "cornerid";
  static const String userIdFk = "useridfk";
  static const String comIdFk = "comidfk";
  static const String cornerContent = "cornercontent";
  static const String cornerImg = "cornerimg";
  static const String cornerDate = "corderdate";
  static const String cornerTime = "cornertime";

  static Future addNewCorner({
    required Map<String, dynamic> corner,
  }) async {
    var db = await TravelMateDb.openDb();
    await db.insert(Corner.tableName, corner);
    print("CORNER ADDED");
  }

  static Future fetchAllComCorners({
    required int comid,
  }) async {
    var db = await TravelMateDb.openDb();
    var corners = await db.query(
      Corner.tableName,
      where: "${Corner.comIdFk} = ?",
      whereArgs: [comid],
    );

    return corners;
  }
}
