import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:travelmate/db/communitydb.dart';
import 'package:travelmate/db/notifcontentdb.dart';
import 'package:travelmate/db/sosdb.dart';
import 'package:travelmate/db/userdb.dart';
import 'package:travelmate/helper/locationhelper.dart';
import 'package:travelmate/models/sessions.dart';
import 'package:travelmate/theme/apptheme.dart';

class SosScreen extends StatefulWidget {
  const SosScreen({super.key});

  @override
  State<SosScreen> createState() => _SosScreenState();
}

class _SosScreenState extends State<SosScreen>
    with SingleTickerProviderStateMixin {
  int count = 5;
  Timer? _holdTimer;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  double btnPosition = 0.0;
  double containerWidth = 350;
  bool trigered = false;

  @override
  void initState() {
    super.initState();

    // Initialize the AnimationController
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );

    // Define the scaling animation
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // Loop the animation
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _holdTimer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  void _startHoldTimer() {
    _holdTimer?.cancel();
    _holdTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (count > 0) {
          count--;
        } else {
          if (!trigered) {
            manageAddSos();
          }
          trigered = true;

          _holdTimer?.cancel();
        }
      });
    });
  }

  void _stopHoldTimer() {
    setState(() {
      if (count > 0) {
        manageAddSos();
        print("SOS ACTIVATED");
        count = 5;
      }
    });
    _holdTimer?.cancel();
  }

  Future manageAddSos() async {
    var dateFormat = DateFormat("MMM, d, yyyy");
    TimeOfDay currentTime = TimeOfDay.now();
    String formattedTime =
        '${currentTime.hourOfPeriod}:${currentTime.minute} ${currentTime.period == DayPeriod.am ? 'AM' : 'PM'}';

    int sosReturedId = await Sos.addNewSOS(sos: {
      Sos.userIdFk: user![User.userId],
      Sos.comIdFk: com![Community.comId],
      Sos.sosDate: dateFormat.format(DateTime.now()),
      Sos.sosTime: formattedTime,
      Sos.latitude: locactionData!.latitude,
      Sos.longitude: locactionData!.longitude,
    });

    await NotificationContent.addSosNotifToAllUsers(
      sosid: sosReturedId,
      uid: user![User.userId],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: count > 0 ? appTheme.colorScheme.surface : Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  sosHeader(context),
                  Gap(12),
                  userLocation(),
                ],
              ),
              count > 0 ? sosBtn() : activeSOS(),
              // cancelSOSBtn(),
              SizedBox(),
              count > 0
                  ? Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        textAlign: TextAlign.center,
                        "Your SOS will be sent to ${com![Community.comStreet]} Community",
                        style: TextStyle(
                          backgroundColor: count > 0
                              ? appTheme.colorScheme.surface
                              : Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  : cancelSOSBtn(),
            ],
          ),
        ),
      ),
    );
  }

  Widget userLocation() {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: count > 0 ? Colors.white : const Color.fromARGB(255, 39, 41, 39),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: ClipOval(
          child: CircleAvatar(
            child: user![User.imgURL] == null
                ? Text(user![User.username][0])
                : Image.file(
                    File(user![User.imgURL]),
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                "${com![Community.comStreet]}, ${com![Community.comCity]}, ${com![Community.comProvince]}",
                softWrap: true,
                overflow: TextOverflow.visible,
                style: TextStyle(
                  fontSize: 16,
                  color: count > 0 ? Colors.black : Colors.white,
                ),
              ),
            ),
          ],
        ),
        trailing: Icon(
          Icons.location_on,
          color: appTheme.colorScheme.error,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text("Longitude: ${locactionData!.longitude}",
                style: TextStyle(
                  fontSize: 14,
                  color: count > 0
                      ? Colors.black
                      : const Color.fromARGB(255, 235, 233, 233),
                )),
            Text("Latitude: ${locactionData!.latitude}",
                style: TextStyle(
                  fontSize: 14,
                  color: count > 0
                      ? Colors.black
                      : const Color.fromARGB(255, 233, 229, 229),
                )),
          ],
        ),
      ),
    );
  }

  Container cancelSOSBtn() {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
      ),
      width: containerWidth,
      child: Stack(
        children: [
          Container(
            height: 50,
            child: Center(
              child: Text(
                "Slide to cancel SOS",
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          Positioned(
            left: btnPosition,
            child: GestureDetector(
              onHorizontalDragUpdate: (details) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  setState(() {
                    // Update button position
                    if (btnPosition <= containerWidth - 80 &&
                        btnPosition >= 0) {
                      btnPosition += details.delta.dx;
                    } else {
                      count = 5;
                      btnPosition = 0;

                      print("CANCELED");
                    }
                  });
                });
              },
              onHorizontalDragEnd: (details) {
                setState(() {
                  btnPosition = 0;
                });
              },
              child: Container(
                child: Icon(
                  Icons.arrow_right_alt,
                  color: Colors.white,
                ),
                width: 80,
                height: 50,
                decoration: BoxDecoration(
                  color: appTheme.colorScheme.error,
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget activeSOS() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Background animation
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value *
                        1.1, // Scale the background larger
                    child: Container(
                      width: 200, // Background width
                      height: 200, // Background height
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: appTheme.colorScheme.error.withOpacity(0.3),
                      ),
                    ),
                  );
                },
              ),

              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value *
                        1.5, // Scale the background larger
                    child: Container(
                      width: 200, // Background width
                      height: 200, // Background height
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: appTheme.colorScheme.error.withOpacity(0.3),
                      ),
                    ),
                  );
                },
              ),
              // SOS Button
              AnimatedBuilder(
                animation: _scaleAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: ClipOval(
                      child: Container(
                        padding: const EdgeInsets.all(22),
                        color: appTheme.colorScheme.error,
                        child: const Icon(
                          Icons.sos,
                          size: 100,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          "SLIDE TO CANCEL SOS",
          style: TextStyle(
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          "Your SOS and location were sent to the Community",
          style: TextStyle(
            fontSize: 14,
            color: Color.fromARGB(255, 236, 231, 231),
          ),
        ),
      ],
    );
  }

  Widget sosBtn() {
    return GestureDetector(
      onTapDown: (_) {
        print("Button pressed");
        _startHoldTimer(); // Start the timer when the button is pressed
      },
      onTapUp: (_) =>
          _stopHoldTimer(), // Stop the timer when the button is released
      onTapCancel: _stopHoldTimer, // Stop the timer if the gesture is canceled
      child: Column(
        children: [
          ClipOval(
            child: Container(
              padding: const EdgeInsets.all(22),
              color: appTheme.colorScheme.error,
              child: const Icon(
                Icons.sos,
                size: 100,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "HOLD ME FOR $count SECONDS",
            style: appTheme.textTheme.headlineLarge,
          ),
          const SizedBox(height: 8),
          const Text("TO SEEK HELP AT YOUR RADIUS"),
        ],
      ),
    );
  }

  Container sosHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: count > 0 ? Colors.white : const Color.fromARGB(255, 39, 41, 39),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        title: Text(
          "SOS alert",
          style: TextStyle(
            color: count > 0 ? Colors.black87 : Colors.white,
          ),
        ),
        leading: IconButton(
          style: IconButton.styleFrom(
            backgroundColor: Colors.grey,
          ),
          onPressed: () {
            if (count > 0) {
              Navigator.pop(context);
              return;
            }

            showActiveSOSMsg();
          },
          icon: const Icon(
            Icons.arrow_back_ios_sharp,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void showActiveSOSMsg() {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("SOS is active"),
      ),
    );
  }
}
