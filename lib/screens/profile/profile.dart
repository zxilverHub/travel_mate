import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:travelmate/db/userdb.dart';
import 'package:travelmate/models/sessions.dart';
import 'package:travelmate/models/settings.dart';
import 'package:travelmate/screens/getstarted.dart';
import 'package:travelmate/theme/apptheme.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        profileBg(),
        userInfo(),
      ],
    );
  }

  Positioned userInfo() {
    return Positioned(
      top: 60,
      left: 12,
      right: 12,
      bottom: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          header(),
          Gap(12),
          profilePic(),
          Gap(24),
          Text(
            "General",
            style: appTheme.textTheme.displaySmall,
          ),
          Gap(12),
          settingsList()
        ],
      ),
    );
  }

  Expanded settingsList() {
    return Expanded(
      child: ListView.builder(
          padding: EdgeInsets.all(0),
          itemCount: settings.length,
          itemBuilder: (_, i) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 6,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  onTap: () => manageSettingsCliked(i),
                  leading: Icon(
                    settings[i].icon,
                    color: appTheme.primaryColor,
                  ),
                  title: Text(
                    settings[i].label,
                    style: appTheme.textTheme.titleLarge,
                  ),
                ),
              ),
            );
          }),
    );
  }

  Container profilePic() {
    return Container(
      width: double.infinity - 12,
      height: 200,
      decoration: BoxDecoration(
        color: appTheme.colorScheme.onSecondaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 12),
          user![User.imgURL] == null
              ? CircleAvatar(
                  backgroundColor: appTheme.primaryColor,
                  radius: 50,
                  child: Text(
                    user![User.username][0],
                    style: appTheme.textTheme.displayLarge,
                  ),
                )
              : Image.file(
                  File(user![User.imgURL]),
                ),
          Gap(6),
          Text(
            user![User.username],
            style: appTheme.textTheme.titleLarge,
          ),
          Text(
            user![User.email],
            style: appTheme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Row header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Profile",
          style: appTheme.textTheme.bodyLarge,
        ),
        IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.edit,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Positioned profileBg() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        child: Image.asset(
          "assets/images/app/profilebg.jpg",
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      ),
    );
  }

  void manageSettingsCliked(int i) {
    if (i == 3) {
      confirmLogOut();
    }
  }

  void confirmLogOut() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          "Confirm log out",
          style: appTheme.textTheme.displaySmall,
        ),
        content: Text("Are you sure you want to log out?"),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => GetStarted(),
                  ),
                );
              },
              child: Text("Yes")),
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: appTheme.primaryColor,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(context),
            child: Text("No"),
          ),
        ],
      ),
    );
  }
}
