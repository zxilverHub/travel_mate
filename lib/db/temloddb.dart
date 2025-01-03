import 'package:travelmate/db/travelmatedb.dart';

class Temloc {
  static const String tableName = "temploc";
  static const String templocid = "templocid";
  static const String useridfk = "useridfk";
  static const String comidfk = "comidfk";

  static Future addTempLoc({required Map<String, dynamic> temploc}) async {
    var db = await TravelMateDb.openDb();
    await db.insert(Temloc.tableName, temploc);
    print("TEMPLOC ADDED");
  }

  static Future checkLastLoc({required int userid}) async {
    var db = await TravelMateDb.openDb();
    var locs = await db.query(
      Temloc.tableName,
      where: "${Temloc.useridfk} = ?",
      whereArgs: [userid],
    );

    if (locs.isEmpty) {
      return null;
    }

    return locs.last;
  }

  static Future deleteAll() async {
    var db = await TravelMateDb.openDb();
    await db.delete(Temloc.tableName);
    print("TEMP LOC DELETED");
  }
}
