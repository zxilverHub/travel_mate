import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:travelmate/db/communitydb.dart';
import 'package:travelmate/db/cornerdb.dart';
import 'package:travelmate/db/notifcontentdb.dart';
import 'package:travelmate/db/temloddb.dart';
import 'package:travelmate/db/userdb.dart';
import 'package:travelmate/helper/locationhelper.dart';
import 'package:travelmate/models/sessions.dart';

Future getPlaceMrk(loc) async {
  var dateFormat = DateFormat("MMM, d, yyyy");
  TimeOfDay currentTime = TimeOfDay.now();
  String formattedTime =
      '${currentTime.hourOfPeriod}:${currentTime.minute} ${currentTime.period == DayPeriod.am ? 'AM' : 'PM'}';
  try {
    List<Placemark> pm =
        await placemarkFromCoordinates(loc.latitude, loc.longitude);
    userPlacemark = pm.first;

    var isExistsId = await Community.isCommunityExists(
      street: pm.first.street!,
      city: pm.first.locality!,
      province: pm.first.subAdministrativeArea!,
    );

    if (isExistsId == null) {
      int comid = await Community.addNewCommnunity(com: {
        Community.comStreet: pm.first.street!,
        Community.comCity: pm.first.locality!,
        Community.comProvince: pm.first.subAdministrativeArea!,
      });

      if (user != null) {
        var lastLoc = await Temloc.checkLastLoc(userid: user![User.userId]);
        if (lastLoc == null) {
          await Temloc.addTempLoc(temploc: {
            Temloc.useridfk: user![User.userId],
            Temloc.comidfk: comid,
          });
        } else if (isExistsId != lastLoc[Temloc.comidfk]) {
          await Temloc.addTempLoc(temploc: {
            Temloc.useridfk: user![User.userId],
            Temloc.comidfk: comid,
          });
        }
      }

      var returnedCom = await Community.getCommunityInfo(comid: comid);
      com = returnedCom;

      var returnedCorner = await Corner.fetchAllComCorners(comid: comid);
      corners = returnedCorner;

      if (user != null) {
        NotificationContent.addNewNotification(notif: {
          NotificationContent.notifType: "community",
          NotificationContent.notifTitle: "Joined community",
          NotificationContent.notifContent:
              "You are in a range of new community ${returnedCom[Community.comStreet]}, ${returnedCom[Community.comCity]}, ${returnedCom[Community.comProvince]}",
          NotificationContent.notifDate: dateFormat.format(DateTime.now()),
          NotificationContent.notifTime: formattedTime,
          NotificationContent.isread: 0,
          NotificationContent.useridfk: user![User.userId],
        });
      }

      return;
    }

    bool isAddNotif = false;

    if (user != null) {
      var lastLoc = await Temloc.checkLastLoc(userid: user![User.userId]);
      if (lastLoc == null) {
        isAddNotif = true;
        await Temloc.addTempLoc(temploc: {
          Temloc.useridfk: user![User.userId],
          Temloc.comidfk: isExistsId,
        });
      } else if (isExistsId != lastLoc[Temloc.comidfk]) {
        isAddNotif = true;
        await Temloc.addTempLoc(temploc: {
          Temloc.useridfk: user![User.userId],
          Temloc.comidfk: isExistsId,
        });
      }
    }

    var returnedCom = await Community.getCommunityInfo(comid: isExistsId);
    com = returnedCom;

    var returnedCorner = await Corner.fetchAllComCorners(comid: isExistsId);
    corners = returnedCorner;

    if (user != null && isAddNotif) {
      NotificationContent.addNewNotification(notif: {
        NotificationContent.notifType: "community",
        NotificationContent.notifTitle: "Joined community",
        NotificationContent.notifContent:
            "You are in a range of new community ${returnedCom[Community.comStreet]}, ${returnedCom[Community.comCity]}, ${returnedCom[Community.comProvince]}",
        NotificationContent.notifDate: dateFormat.format(DateTime.now()),
        NotificationContent.notifTime: formattedTime,
        NotificationContent.isread: 0,
        NotificationContent.useridfk: user![User.userId],
      });
    }
  } catch (e) {
    print(e);
  }
}
