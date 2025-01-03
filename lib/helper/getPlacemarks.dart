import 'package:geocoding/geocoding.dart';
import 'package:travelmate/db/communitydb.dart';
import 'package:travelmate/db/cornerdb.dart';
import 'package:travelmate/helper/locationhelper.dart';
import 'package:travelmate/models/sessions.dart';

Future getPlaceMrk(loc) async {
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

      var returnedCom = await Community.getCommunityInfo(comid: comid);
      com = returnedCom;

      var returnedCorner = await Corner.fetchAllComCorners(comid: comid);
      corners = returnedCorner;

      return;
    }

    var returnedCom = await Community.getCommunityInfo(comid: isExistsId);
    com = returnedCom;

    var returnedCorner = await Corner.fetchAllComCorners(comid: isExistsId);
    corners = returnedCorner;
  } catch (e) {
    print(e);
  }
}
