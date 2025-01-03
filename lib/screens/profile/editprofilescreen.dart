import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:travelmate/component/headerComponent.dart';
import 'package:travelmate/db/userdb.dart';
import 'package:travelmate/helper/imgpath.dart';
import 'package:travelmate/models/sessions.dart';
import 'package:travelmate/screens/mainscreen.dart';
import 'package:travelmate/theme/apptheme.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  var usernameCtrl = TextEditingController();

  File? profilePic;
  String? imgUrl;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    usernameCtrl.text = user![User.username];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            header(
              context: context,
              title: "Change profile information",
              sub: "Edit profile",
              action: SizedBox(),
              index: 4,
            ),
            Column(
              children: [
                profileImg(),
                Gap(32),
                Text("Username"),
                usernameTextInput(),
              ],
            ),
            SizedBox(),
            SizedBox(),
            saveBtn(context),
          ],
        ),
      ),
    );
  }

  Padding usernameTextInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 32,
      ),
      child: TextField(
        style: TextStyle(
          color: appTheme.colorScheme.onPrimary,
        ),
        controller: usernameCtrl,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          hintText: "Username",
        ),
      ),
    );
  }

  ClipOval profileImg() {
    return ClipOval(
      child: CircleAvatar(
        backgroundColor: appTheme.colorScheme.secondary,
        radius: 50,
        child: Stack(
          children: [
            user![User.imgURL] == null
                ? profilePic == null
                    ? const SizedBox()
                    : Image.file(File(profilePic!.path))
                : profilePic != null
                    ? Image.file(File(profilePic!.path))
                    : Image.file(File(user![User.imgURL])),
            Center(
              child: IconButton(
                onPressed: handleChangeImg,
                icon: Icon(
                  Icons.edit,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  GestureDetector saveBtn(BuildContext context) {
    return GestureDetector(
      onTap: saveUserProfile,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Container(
          width: MediaQuery.of(context).size.width - 24,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: appTheme.primaryColor,
          ),
          child: Text(
            "Save",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  void handleChangeImg() async {
    final pickedProfile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedProfile == null) return;

    File? profileUrl = await getImagePath(pickedFile: pickedProfile);

    setState(() {
      profilePic = File(pickedProfile.path);
      imgUrl = profileUrl!.path;
    });
  }

  void saveUserProfile() async {
    if (usernameCtrl.text.trim() == "") {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please enter username"),
        ),
      );

      return;
    }

    var editedUser = await User.updateUserProfile(
      user: {
        User.username: usernameCtrl.text,
        User.imgURL: imgUrl,
      },
      userid: user![User.userId],
    );
    setState(() {
      user = editedUser;
    });

    profilePic = null;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MainScreen(screenIndex: 4),
      ),
    );
  }
}
