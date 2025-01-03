import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:location/location.dart';
import 'package:travelmate/component/gsbg.dart';
import 'package:travelmate/db/notifcontentdb.dart';
import 'package:travelmate/db/temloddb.dart';
import 'package:travelmate/db/userdb.dart';
import 'package:travelmate/helper/getPlacemarks.dart';
import 'package:travelmate/helper/locationhelper.dart';
import 'package:travelmate/models/getstartedmodel.dart';
import 'package:travelmate/models/sessions.dart';
import 'package:travelmate/screens/mainscreen.dart';
import 'package:travelmate/screens/registration/signin.dart';
import 'package:travelmate/screens/registration/signup.dart';
import 'package:travelmate/theme/apptheme.dart';

class GetStarted extends StatefulWidget {
  const GetStarted({super.key});

  @override
  State<GetStarted> createState() => _GetStartedState();
}

class _GetStartedState extends State<GetStarted> {
  LocationData? myLocData;

  bool isStarted = false;
  int index = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMyLocation();
  }

  Future getMyLocation() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    location.onLocationChanged.listen((LocationData currentLocation) {
      getPlaceMrk(currentLocation);
      setState(() {
        myLocData = currentLocation;
        locactionData = currentLocation;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: myLocData == null ? loadingLocation() : mainBody(),
    );
  }

  Center loadingLocation() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          Gap(12),
          Text("Getting location..."),
        ],
      ),
    );
  }

  Stack mainBody() {
    return Stack(
      children: [
        gsBg(!isStarted ? "gsbg" : index),
        Positioned(
          left: isStarted ? 12 : 0,
          right: isStarted ? 12 : 0,
          bottom: 50,
          child: !isStarted ? getStartMainScreen() : gsScreens(),
        ),
      ],
    );
  }

  Column gsScreens() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          getstarted[index].title,
          style: appTheme.textTheme.displayLarge,
          softWrap: true,
        ),
        Gap(12),
        Text(
          getstarted[index].content,
          style: appTheme.textTheme.titleLarge,
        ),
        Gap(12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            indicators(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: 46,
                  vertical: 12,
                ),
                backgroundColor: appTheme.primaryColor,
                foregroundColor: appTheme.colorScheme.secondaryContainer,
              ),
              onPressed: manageNext,
              child: Text(
                "Next",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Row indicators() {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: index == 0 ? appTheme.primaryColor : appTheme.indicatorColor,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        Gap(4),
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: index == 1 ? appTheme.primaryColor : appTheme.indicatorColor,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        Gap(4),
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: index == 2 ? appTheme.primaryColor : appTheme.indicatorColor,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ],
    );
  }

  Column getStartMainScreen() {
    return Column(
      children: [
        GestureDetector(
          onTap: manageStart,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 48,
              vertical: 24,
            ),
            decoration: BoxDecoration(
              color: appTheme.primaryColor,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Text(
              "Get started with TravelMate",
              style: appTheme.textTheme.headlineSmall,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Already have an account? ",
              style: appTheme.textTheme.titleSmall,
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => Loginpage(),
                  ),
                );
              },
              child: Text(
                "Sign in",
                style: appTheme.textTheme.titleMedium,
              ),
            ),
          ],
        )
      ],
    );
  }

  void manageStart() async {
    await Temloc.deleteAll();
    // remove this Navigator and uncomment the setState
    thisuserid = 1;
    user = await User.checkAccount(email: "user3@gmail.com", pass: "12345678");

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MainScreen(screenIndex: 0),
      ),
    );

    return;

    // setState(() {
    //   isStarted = true;
    // });
  }

  void manageNext() {
    if (index == 2) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => SignUpPage(),
        ),
      );
      return;
    }
    setState(() {
      index++;
    });
  }
}
