import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:travelmate/component/headerComponent.dart';
import 'package:travelmate/db/chatcontentdb.dart';
import 'package:travelmate/db/communitydb.dart';
import 'package:travelmate/db/cornerdb.dart';
import 'package:travelmate/db/privatechatdb.dart';
import 'package:travelmate/db/userdb.dart';
import 'package:travelmate/models/sessions.dart';
import 'package:travelmate/screens/community/addcornerscreen.dart';
import 'package:travelmate/screens/community/privatechatscreen.dart';
import 'package:travelmate/theme/apptheme.dart';

class CornerScreen extends StatefulWidget {
  const CornerScreen({super.key});

  @override
  State<CornerScreen> createState() => _CornerScreenState();
}

class _CornerScreenState extends State<CornerScreen> {
  IconButton addIcon() {
    return IconButton(
      style: IconButton.styleFrom(
        backgroundColor: appTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      onPressed: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => AddCorner(),
        ),
      ),
      icon: Icon(Icons.add),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            header(
              context: context,
              title: "Community corner",
              sub: com![Community.comStreet],
              action: addIcon(),
            ),
            FutureBuilder(
              future: Corner.fetchAllComCorners(comid: com![Community.comId]),
              builder: (_, s) {
                if (s.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (s.connectionState == ConnectionState.done) {
                  if (s.hasData) {
                    final corners = s.data;
                    return Expanded(
                      child: SingleChildScrollView(
                        child: bodyContent(corners),
                      ),
                    );
                  }
                }

                return SizedBox();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget bodyContent(List<Map<String, dynamic>> corners) {
    List<Map<String, dynamic>> myCorner = [];
    List<Map<String, dynamic>> comCorners = [];
    corners.forEach((cr) {
      if (cr[Corner.userIdFk] == user![User.userId]) {
        myCorner.add(cr);
      } else {
        comCorners.add(cr);
      }
    });

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Gap(12),
          Text(
            "My corner",
            style: appTheme.textTheme.headlineLarge,
          ),
          Gap(12),
          cornersList(myCorner, true),
          Gap(12),
          Text(
            "Community",
            style: appTheme.textTheme.headlineLarge,
          ),
          Gap(12),
          cornersList(comCorners, false),
        ],
      ),
    );
  }

  Column cornersList(List<Map<String, dynamic>> corners, bool isUser) {
    if (corners.isEmpty) {
      // Handle the case when corners list is empty
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 226, 221, 221),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              "No corners",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color.fromARGB(255, 160, 155, 155),
              ),
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: corners.map((cr) {
        return FutureBuilder(
          future: User.getUserInfo(userid: cr[Corner.userIdFk]),
          builder: (_, s) {
            if (s.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (s.connectionState == ConnectionState.done) {
              if (s.hasData && s.data!.isNotEmpty) {
                final uploader = s.data;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 0),
                      color: Colors.white,
                      child: ExpansionTile(
                        leading: ClipOval(
                          child: CircleAvatar(
                            backgroundColor: appTheme.primaryColor,
                            child: uploader![User.imgURL] == null
                                ? Text(uploader[User.username][0])
                                : Image.file(
                                    File(uploader[User.imgURL]),
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                  ),
                          ),
                        ),
                        title: Text(uploader[User.username]),
                        subtitle: Text(
                          "${cr[Corner.cornerDate]} · ${cr[Corner.cornerTime]}",
                          style: appTheme.textTheme.bodyMedium,
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 16,
                              right: 16,
                              bottom: 6,
                            ),
                            child: Container(
                              padding: EdgeInsets.all(
                                  cr[Corner.cornerImg] == null ? 8 : 0),
                              decoration: BoxDecoration(
                                color: cr[Corner.cornerImg] == null
                                    ? Color.fromARGB(255, 243, 240, 240)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              width: double.infinity,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    cr[Corner.cornerContent],
                                    softWrap: true,
                                  ),
                                  Gap(8),
                                  cr[Corner.cornerImg] == null
                                      ? SizedBox()
                                      : ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          child: AspectRatio(
                                            aspectRatio: 3 / 2,
                                            child: Image.file(
                                              File(cr[Corner.cornerImg]),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 0,
                              left: 16,
                              right: 16,
                              bottom: 16,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: const Color.fromARGB(255, 241, 237, 237),
                              ),
                              child: ListTile(
                                onTap: () => manageCornerActionClicked(
                                  isUser: isUser,
                                  cornerid: cr[Corner.cornerId],
                                  uploaderid: cr[Corner.userIdFk],
                                  cr: cr,
                                ),
                                trailing: Icon(Icons.arrow_right),
                                leading:
                                    Icon(isUser ? Icons.delete : Icons.chat),
                                title: Text(
                                  isUser ? "Delete" : "Response",
                                  style: appTheme.textTheme.titleLarge,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }

              return Container(
                color: Colors.grey,
                child: Text(
                  "No corner",
                  textAlign: TextAlign.center,
                ),
              );
            }

            return SizedBox();
          },
        );
      }).toList(),
    );
  }

  void manageCornerActionClicked({
    required bool isUser,
    required int cornerid,
    required int uploaderid,
    required Map<String, dynamic> cr,
  }) async {
    if (isUser) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(
            "Delete corner",
            style: appTheme.textTheme.titleLarge,
          ),
          content: Text("Are you to delete this corner?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("No"),
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: appTheme.primaryColor,
                padding: EdgeInsets.all(12),
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                // delete corner
                Corner.deleteCorner(cornerId: cornerid);
                Navigator.pop(context);
                setState(() {});
              },
              child: Text("Yes"),
            ),
          ],
        ),
      );
      return;
    }

    // response
    var dateFormat = DateFormat("MMM, d, yyyy");
    TimeOfDay currentTime = TimeOfDay.now();
    String formattedTime =
        '${currentTime.hourOfPeriod}:${currentTime.minute} ${currentTime.period == DayPeriod.am ? 'AM' : 'PM'}';

    int? pcId;
    var prChatId = await PrivateChat.checkIfHaveChatHistory(
        user1: uploaderid, user2: user![User.userId]);

    pcId = prChatId;
    if (prChatId == null) {
      pcId = await PrivateChat.addNewPrivateChat(
          user1: uploaderid, user2: user![User.userId]);
    }
    var pchat = await PrivateChat.getPrivateChatInfo(pcId: pcId!);
    await ChatContent.addNewChatContent(content: {
      ChatContent.pChatIdFk: pcId,
      ChatContent.contentType: "text",
      ChatContent.content: cr[Corner.cornerContent],
      ChatContent.userIdFk: cr[Corner.userIdFk],
      ChatContent.chatDate: dateFormat.format(DateTime.now()),
      ChatContent.chatTime: formattedTime,
    });

    if (cr[Corner.cornerImg] != null) {
      await ChatContent.addNewChatContent(content: {
        ChatContent.pChatIdFk: pcId,
        ChatContent.contentType: "media",
        ChatContent.content: cr[Corner.cornerImg],
        ChatContent.userIdFk: cr[Corner.userIdFk],
        ChatContent.chatDate: dateFormat.format(DateTime.now()),
        ChatContent.chatTime: formattedTime,
      });
    }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PrivateChatScreen(pchat: pchat),
      ),
    );
  }
}
