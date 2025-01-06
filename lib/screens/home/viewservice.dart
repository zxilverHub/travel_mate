import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:travelmate/component/headerComponent.dart';
import 'package:travelmate/db/privatechatdb.dart';
import 'package:travelmate/db/servicedb.dart';
import 'package:travelmate/db/userdb.dart';
import 'package:travelmate/models/sessions.dart';
import 'package:travelmate/screens/community/privatechatscreen.dart';
import 'package:travelmate/screens/mainscreen.dart';
import 'package:travelmate/theme/apptheme.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewService extends StatefulWidget {
  ViewService({super.key, required this.serv});

  Map<String, dynamic> serv;

  @override
  State<ViewService> createState() => _ViewServiceState();
}

class _ViewServiceState extends State<ViewService> {
  Map<String, dynamic>? serviceInfo;
  Map<String, dynamic>? userInfo;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getInfos();
  }

  Future getInfos() async {
    var us = await User.getUserInfo(userid: widget.serv[ServiceDb.useridfk]);
    setState(() {
      serviceInfo = widget.serv;
      userInfo = us;
    });
  }

  Widget chatServiceBtn() {
    return IconButton(
      onPressed: () {},
      icon: ClipOval(
        child: CircleAvatar(
          child: Image.file(
            File(userInfo![User.imgURL]),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: serviceInfo != null && userInfo != null
          ? Stack(
              children: [
                serviceImage(context),
                serviceContent(context),
                backBtn(),
              ],
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  Positioned backBtn() {
    return Positioned(
      top: 46,
      left: 12,
      child: IconButton(
        style: IconButton.styleFrom(
          backgroundColor: Colors.grey,
        ),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => MainScreen(screenIndex: 0),
            ),
          );
        },
        icon: Icon(
          Icons.arrow_back_ios_new_sharp,
          color: Colors.white,
        ),
      ),
    );
  }

  Positioned serviceContent(BuildContext context) {
    return Positioned(
      top: 0,
      bottom: 0,
      left: 0,
      right: 0,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.height / 2.5,
          ),
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height / 1.75,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      indicatorDesign(),
                      Gap(8),
                      uploaderInfo(),
                      Divider(
                        color: const Color.fromARGB(255, 201, 199, 199),
                      ),
                      Gap(12),
                      serviceTime(),
                      Gap(12),
                      Text(
                        serviceInfo![ServiceDb.servicetitle],
                        style: appTheme.textTheme.headlineMedium,
                      ),
                      Text(
                        serviceInfo![ServiceDb.servicedesc],
                        softWrap: true,
                      ),
                    ],
                  ),
                  navigateBtn(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Row indicatorDesign() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 50,
          height: 4,
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ],
    );
  }

  Row serviceTime() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: const Color.fromARGB(255, 204, 200, 200),
            ),
            child: Center(
              child: Column(
                children: [
                  Text(
                    serviceInfo![ServiceDb.opentime],
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "Open",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Gap(12),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: const Color.fromARGB(255, 204, 200, 200),
            ),
            child: Center(
              child: Column(
                children: [
                  Text(
                    serviceInfo![ServiceDb.closetime],
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "Close",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _launchUrl(_url) async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  Widget navigateBtn() {
    final Uri _url = Uri.parse(
        "https://www.google.com/maps/dir/?api=1&destination=${serviceInfo![ServiceDb.servicelat]}, ${serviceInfo![ServiceDb.servicelng]}");

    return GestureDetector(
      onTap: () => _launchUrl(_url),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: appTheme.primaryColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          "Navigate route",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  ListTile uploaderInfo() {
    return ListTile(
      contentPadding: EdgeInsets.all(0),
      leading: ClipOval(
        child: CircleAvatar(
          backgroundColor: appTheme.primaryColor,
          child: userInfo![User.imgURL] == null
              ? Text(userInfo![User.username])
              : Image.file(
                  File(userInfo![User.imgURL]),
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
        ),
      ),
      title: Text(userInfo![User.username]),
      trailing: user![User.userId] == userInfo![User.userId]
          ? SizedBox()
          : Container(
              padding: EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 12,
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(
                    color: appTheme.colorScheme.onPrimary,
                  )),
              child: chatBtn(userInfo![User.userId]),
            ),
    );
  }

  Widget chatBtn(int uploaderid) {
    return GestureDetector(
      onTap: () async {
        int? pcId;
        var prChatId = await PrivateChat.checkIfHaveChatHistory(
            user1: uploaderid, user2: user![User.userId]);
        pcId = prChatId;
        if (prChatId == null) {
          pcId = await PrivateChat.addNewPrivateChat(
              user1: uploaderid, user2: user![User.userId]);
        }
        var pchat = await PrivateChat.getPrivateChatInfo(pcId: pcId!);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => PrivateChatScreen(pchat: pchat),
          ),
        );
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            size: 20,
            Icons.sms_outlined,
          ),
          Gap(6),
          Text(
            "Chat",
          ),
        ],
      ),
    );
  }

  Positioned serviceImage(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      bottom: MediaQuery.of(context).size.height / 2,
      child: Image.file(
        File(serviceInfo![ServiceDb.serviceimg]),
        fit: BoxFit.cover,
      ),
    );
  }
}
