import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:travelmate/db/communitydb.dart';
import 'package:travelmate/db/notifcontentdb.dart';
import 'package:travelmate/db/sosdb.dart';
import 'package:travelmate/db/userdb.dart';
import 'package:travelmate/models/sessions.dart';
import 'package:travelmate/screens/community/groupchat.dart';
import 'package:travelmate/theme/apptheme.dart';
import 'package:url_launcher/url_launcher.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder(
        future: NotificationContent.getAllUserNotification(
            userid: user![User.userId]),
        builder: (_, s) {
          if (s.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (s.connectionState == ConnectionState.done) {
            if (s.hasData) {
              final notifs = s.data;
              return notificationContents(notifs);
            }
          }

          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget notificationContents(List<Map<String, dynamic>>? notifs) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Gap(12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Notifications",
                style: appTheme.textTheme.headlineLarge,
              ),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 223, 217, 217),
                  foregroundColor: Colors.black54,
                ),
                onPressed: () => manageReadAll(),
                child: Text("Mark all as read"),
              ),
            ],
          ),
          Gap(12),
          Expanded(
            child: ListView.builder(
              itemCount: notifs!.length,
              itemBuilder: (_, i) {
                final notif = notifs[notifs.length - 1 - i];
                return notif[NotificationContent.notifType] == "community"
                    ? notificationCard(notif)
                    : sosAlertCard(notif);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget sosAlertCard(Map<String, dynamic> notif) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        decoration: BoxDecoration(
          color: notif[NotificationContent.isread] == 0
              ? Colors.white
              : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
        ),
        child: ListTile(
          onTap: () => manageResponseToSos(notif),
          leading: CircleAvatar(
            backgroundColor: appTheme.colorScheme.error,
            child: Icon(
              Icons.sos,
              color: Colors.white,
            ),
          ),
          title: Text("SOS alert"),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text("Someone near your area needs help."),
              Gap(4),
              Text(
                  "${notif[NotificationContent.notifDate]} · ${notif[NotificationContent.notifTime]}",
                  style: TextStyle(
                    color: Colors.grey,
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget notificationCard(Map<String, dynamic> notif) {
    return GestureDetector(
      onTap: () => manageNotifClick(notif),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Container(
          decoration: BoxDecoration(
            color: notif[NotificationContent.isread] == 0
                ? Colors.white
                : Colors.transparent,
            borderRadius: BorderRadius.circular(24),
          ),
          child: ListTile(
            isThreeLine: true,
            leading: CircleAvatar(
              child: Image.asset("assets/images/app/comicon.png"),
            ),
            title: Text(notif[NotificationContent.notifTitle]),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(notif[NotificationContent.notifContent]),
                Gap(4),
                Text(
                  "${notif[NotificationContent.notifDate]} · ${notif[NotificationContent.notifTime]}",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  manageReadAll() async {
    await NotificationContent.markAllAsRead(
      notif: {
        NotificationContent.isread: 1,
      },
      userid: user![User.userId],
    );
    setState(() {});
  }

  manageNotifClick(Map<String, dynamic> notif) async {
    await NotificationContent.markAsRead(
        userid: user![User.userId],
        notifid: notif[NotificationContent.notifContentId]);

    if (notif[NotificationContent.notifType] == "community") {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => GroupChat(comid: com![Community.comId]),
        ),
      );
      return;
    }
  }

  manageResponseToSos(Map<String, dynamic> notif) async {
    await NotificationContent.markAsRead(
      userid: user![User.userId],
      notifid: notif[NotificationContent.notifContentId],
    );

    Map<String, dynamic> sosInfo = await Sos.getSosInfo(
        sosid: int.parse(notif[NotificationContent.notifContent]));
    Map<String, dynamic> userInfo =
        await User.getUserInfo(userid: sosInfo[Sos.userIdFk]);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          "SOS alert",
          style: appTheme.textTheme.headlineMedium,
        ),
        content: ListTile(
          title: Text(
            "${userInfo[User.username]} needs help",
            style: appTheme.textTheme.titleLarge,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Lattitude: ${sosInfo[Sos.latitude]}"),
              Text("Longitude: ${sosInfo[Sos.longitude]}"),
            ],
          ),
          leading: ClipOval(
            child: CircleAvatar(
              backgroundColor: appTheme.primaryColor,
              child: userInfo[User.imgURL] == null
                  ? Text(userInfo[User.username][0])
                  : Image.file(
                      File(userInfo[User.imgURL]),
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(
                horizontal: 24,
              ),
              backgroundColor: appTheme.colorScheme.primary,
            ),
            onPressed: () => manageViewMap(sosInfo),
            child: Text(
              "View map",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _launchUrl(_url) async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  manageViewMap(Map<String, dynamic> sosInfo) async {
    final Uri _url = Uri.parse(
        "https://www.google.com/maps/search/?api=1&query=${sosInfo[Sos.latitude]}, ${sosInfo[Sos.longitude]}");
    _launchUrl(_url);
  }
}
