import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class TravelMateDb {
  static const String dbName = "travelmatedb.db";
  static const int dbVersion = 6;

  static Future<Database> openDb() async {
    var path = join(await getDatabasesPath(), dbName);

    var db = await openDatabase(
      path,
      version: dbVersion,
      onCreate: (db, version) => _onCreate(db),
      onUpgrade: (db, oldVersion, newVersion) => _onCreate(db),
    );

    // Enable foreign keys
    await db.execute('PRAGMA foreign_keys = ON;');

    return db;
  }

  static Future<void> _onCreate(Database db) async {
    // db.execute("DROP TABLE IF EXISTS corner");

    var sql = '''
    CREATE TABLE IF NOT EXISTS community (
      comid INTEGER PRIMARY KEY,
      comstreet TEXT NOT NULL,
      comcity TEXT NOT NULL,
      comprovince TEXT NOT NULL
    );
    ''';
    await db.execute(sql);

    sql = '''
    CREATE TABLE IF NOT EXISTS chat (
      chatid INTEGER PRIMARY KEY,
      comidfk INTEGER NOT NULL,
      useridfk INTEGER NOT NULL,
      chattype TEXT NOT NULL,
      chatdate TEXT NOT NULL, -- Store DATE as TEXT
      chattime TEXT NOT NULL, -- Store TIME as TEXT
      chatcontent TEXT NOT NULL,
      FOREIGN KEY (comidfk) REFERENCES community (comid) ON DELETE CASCADE ON UPDATE CASCADE,
      FOREIGN KEY (useridfk) REFERENCES user (userid) ON DELETE CASCADE ON UPDATE CASCADE
    );
    ''';
    await db.execute(sql);

    sql = '''
    CREATE TABLE IF NOT EXISTS user (
      userid INTEGER PRIMARY KEY,
      username TEXT NOT NULL,
      email TEXT NOT NULL,
      password TEXT NOT NULL,
      imgURL TEXT
    );
    ''';
    await db.execute(sql);

    sql = '''
    CREATE TABLE IF NOT EXISTS privatechat (
      pchatid INTEGER PRIMARY KEY,
      senderidfk INTEGER NOT NULL,
      receiveridfk INTEGER NOT NULL,
      FOREIGN KEY (senderidfk) REFERENCES user (userid) ON DELETE CASCADE ON UPDATE CASCADE,
      FOREIGN KEY (receiveridfk) REFERENCES user (userid) ON DELETE CASCADE ON UPDATE CASCADE
    );
    ''';
    await db.execute(sql);

    sql = '''
    CREATE TABLE IF NOT EXISTS chatcontent (
      contentid INTEGER PRIMARY KEY,
      pchatidfk INTEGER NOT NULL,
      contenttype TEXT NOT NULL,
      content TEXT NOT NULL,
      useridfk INTEGER NOT NULL,
      chatdate TEXT NOT NULL, -- Store DATE as TEXT
      chattime TEXT NOT NULL, -- Store TIME as TEXT
      FOREIGN KEY (pchatidfk) REFERENCES privatechat (pchatid) ON DELETE CASCADE ON UPDATE CASCADE,
      FOREIGN KEY (useridfk) REFERENCES user (userid) ON DELETE CASCADE ON UPDATE CASCADE
    );
    ''';
    await db.execute(sql);

    sql = '''
    CREATE TABLE IF NOT EXISTS notification (
      notificationid INTEGER PRIMARY KEY,
      useridfk INTEGER NOT NULL,
      FOREIGN KEY (useridfk) REFERENCES user (userid) ON DELETE CASCADE ON UPDATE CASCADE
    );
    ''';
    await db.execute(sql);

    sql = '''
    CREATE TABLE IF NOT EXISTS notificationcontent ( -- Corrected name
      notifcontentid INTEGER PRIMARY KEY,
      notificationidfk INTEGER NOT NULL,
      notiftype TEXT NOT NULL,
      notiftitle TEXT NOT NULL,
      notifcontent TEXT NOT NULL,
      notifdate TEXT NOT NULL, -- Store DATE as TEXT
      notiftime TEXT NOT NULL, -- Store TIME as TEXT
      FOREIGN KEY (notificationidfk) REFERENCES notification (notificationid) ON DELETE CASCADE ON UPDATE CASCADE
    );
    ''';
    await db.execute(sql);

    sql = '''
    CREATE TABLE IF NOT EXISTS sos (
      sosid INTEGER PRIMARY KEY,
      useridfk INTEGER NOT NULL,
      comidfk INTEGER NOT NULL,
      sosdate TEXT NOT NULL, -- Store DATE as TEXT
      sostime TEXT NOT NULL, -- Store TIME as TEXT
      FOREIGN KEY (useridfk) REFERENCES user (userid) ON DELETE CASCADE ON UPDATE CASCADE,
      FOREIGN KEY (comidfk) REFERENCES community (comid) ON DELETE CASCADE ON UPDATE CASCADE
    );
    ''';
    await db.execute(sql);

    sql = '''
    CREATE TABLE IF NOT EXISTS soslocation (
      soslocid INTEGER PRIMARY KEY,
      latitude INTEGER NOT NULL,
      longitude INTEGER NOT NULL,
      altitude INTEGER NOT NULL,
      FOREIGN KEY (soslocid) REFERENCES sos (sosid) ON DELETE CASCADE ON UPDATE CASCADE
    );
    ''';
    await db.execute(sql);

    sql = '''
    CREATE TABLE IF NOT EXISTS corner (
      cornerid INTEGER PRIMARY KEY,
      useridfk INTEGER NOT NULL,
      comidfk INTEGER NOT NULL,
      cornercontent TEXT NOT NULL,
      cornerimg TEXT,
      corderdate TEXT NOT NULL,
      cornertime TEXT NOT NULL,
      FOREIGN KEY (useridfk) REFERENCES user (userid) ON DELETE CASCADE ON UPDATE CASCADE,
      FOREIGN KEY (comidfk) REFERENCES community (comid) ON DELETE CASCADE ON UPDATE CASCADE
    );
    ''';
    await db.execute(sql);

    print("DB IS CREATED");
  }
}
