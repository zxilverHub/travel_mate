import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:geocoding/geocoding.dart';
import 'package:travelmate/db/communitydb.dart';
import 'package:travelmate/db/userdb.dart';
import 'package:travelmate/helper/locationhelper.dart';
import 'package:travelmate/models/sessions.dart';
import 'package:travelmate/theme/apptheme.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          child: Container(),
        ),
        header(),
        midContent(),
      ],
    );
  }

  Positioned midContent() {
    return Positioned(
      top: 160,
      left: 12,
      right: 12,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Welcome to",
            style: appTheme.textTheme.headlineLarge,
          ),
          Text(
            "${com![Community.comStreet]}, ${com![Community.comCity]}, ${com![Community.comProvince]}",
            style: appTheme.textTheme.displayLarge,
          )
        ],
      ),
    );
  }

  Positioned header() {
    return Positioned(
      top: 64,
      left: 12,
      right: 12,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.only(
              top: 8,
              bottom: 8,
              right: 16,
              left: 8,
            ),
            decoration: BoxDecoration(
              color: appTheme.colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  child: Text("DP"),
                  backgroundColor: appTheme.primaryColor,
                ),
                Gap(8),
                Text("USERNAME"),
              ],
            ),
          ),
          IconButton(
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(
                appTheme.colorScheme.error,
              ),
            ),
            onPressed: () {},
            icon: Icon(
              Icons.sos,
              color: appTheme.colorScheme.secondaryContainer,
            ),
          ),
        ],
      ),
    );
  }
}
