import 'package:travelmate/db/travelmatedb.dart';

class ServiceDb {
  static const String tableName = "service";
  static const String serviceid = "serviceid";
  static const String servicetitle = "servicetitle";
  static const String servicedesc = "servicedesc";
  static const String serviceimg = "serviceimg";
  static const String useridfk = "useridfk";
  static const String comidfk = "comidfk";
  static const String servicelat = "servicelat";
  static const String servicelng = "servicelng";
  static const String opentime = "opentime";
  static const String closetime = "closetime";

  static Future addNewService({required Map<String, dynamic> service}) async {
    var db = await TravelMateDb.openDb();
    await db.insert(ServiceDb.tableName, service);
    print("SERVICE ADDED");
  }

  static Future getUserServices({required int userid}) async {
    var db = await TravelMateDb.openDb();
    var services = await db.query(
      ServiceDb.tableName,
      where: "${ServiceDb.useridfk} = ?",
      whereArgs: [userid],
    );

    return services;
  }

  static Future<Map<String, dynamic>> getServiceInfo(
      {required int serviceid}) async {
    var db = await TravelMateDb.openDb();
    var services = await db.query(
      ServiceDb.tableName,
      where: "${ServiceDb.serviceid} = ?",
      whereArgs: [serviceid],
    );

    return services.first;
  }

  static Future fetchComServices({required int comid}) async {
    var db = await TravelMateDb.openDb();
    var services = await db.query(
      ServiceDb.tableName,
      where: "${ServiceDb.comidfk} = ?",
      whereArgs: [comid],
    );

    print(services);
    return services;
  }

  static Future deleteService({required int servid}) async {
    var db = await TravelMateDb.openDb();
    await db.delete(
      ServiceDb.tableName,
      where: "${ServiceDb.serviceid} = ?",
      whereArgs: [servid],
    );

    print("SERVICE DELETED");
  }
}
