import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:travelmate/db/notifcontentdb.dart';
import 'package:travelmate/db/userdb.dart';
import 'package:travelmate/models/sessions.dart';
import 'package:travelmate/theme/apptheme.dart';

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
          Text(
            "Notifications",
            style: appTheme.textTheme.headlineLarge,
          ),
          Gap(12),
          Expanded(
            child: ListView.builder(
              itemCount: notifs!.length,
              itemBuilder: (_, i) {
                final notif = notifs[notifs.length - 1 - i];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
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
                            "${notif[NotificationContent.notifDate]} | ${notif[NotificationContent.notifTime]}",
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
