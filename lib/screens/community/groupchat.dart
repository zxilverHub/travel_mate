import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:travelmate/component/headerComponent.dart';
import 'package:travelmate/db/chatdb.dart';
import 'package:travelmate/db/communitydb.dart';
import 'package:travelmate/db/userdb.dart';
import 'package:travelmate/helper/imgpath.dart';
import 'package:travelmate/models/chatmodel.dart';
import 'package:travelmate/models/sessions.dart';
import 'package:travelmate/theme/apptheme.dart';

class GroupChat extends StatefulWidget {
  GroupChat({super.key, required this.comid});

  int comid;

  @override
  State<GroupChat> createState() => _GroupChatState();
}

class _GroupChatState extends State<GroupChat> {
  String uploadImgURL = "";

  var textCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            header(
              context: context,
              title: com![Community.comStreet] + " community",
              sub: com![Community.comProvince],
              action: Image.asset(
                "assets/images/app/comicon.png",
                width: 46,
              ),
            ),
            FutureBuilder(
              future: Chat.fetchAllChatsFromCom(comid: com![Community.comId]),
              builder: (_, s) {
                if (s.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (s.connectionState == ConnectionState.done) {
                  if (s.hasData) {
                    final chats = s.data;
                    return chatsList(chats!);
                  }
                }

                return Expanded(child: Center(child: Text("No data")));
              },
            ),
            messageField(),
          ],
        ),
      ),
    );
  }

  Expanded chatsList(List<Map<String, dynamic>> chats) {
    var revChats = chats.reversed.toList();
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 6,
          horizontal: 12,
        ),
        child: ListView.builder(
          reverse: true,
          itemCount: revChats.length,
          itemBuilder: (_, i) {
            final chat = revChats[i];

            return FutureBuilder(
              future: User.getUserInfo(userid: chat[Chat.userIdFk]),
              builder: (_, s) {
                if (s.connectionState == ConnectionState.waiting) {
                  return SizedBox();
                }

                if (s.connectionState == ConnectionState.done) {
                  if (s.hasData) {
                    final sender = s.data;
                    if (sender![User.userId] == user![User.userId]) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: myMsg(chat, sender),
                      );
                    }
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: msgFromOther(chat, sender),
                    );
                  }
                }

                return SizedBox();
              },
            );
          },
        ),
      ),
    );
  }

  Row msgFromOther(Map<String, dynamic> chat, Map<String, dynamic> sender) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        ClipOval(
          child: CircleAvatar(
            radius: 20,
            child: sender[User.imgURL] == null
                ? Text(sender[User.username][0])
                : Image.file(
                    File(sender[User.imgURL]),
                  ),
            backgroundColor: appTheme.primaryColor,
          ),
        ),
        Gap(6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              sender[User.username],
              style: appTheme.textTheme.bodyMedium,
            ),
            Gap(4),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: chat[Chat.chatType] == "text" ? 300 : 300,
                maxHeight: 300,
              ),
              child: Container(
                padding: EdgeInsets.all(chat[Chat.chatType] == "text" ? 10 : 0),
                decoration: const BoxDecoration(
                  color: Color(0xFFD9D9D9),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                  ),
                ),
                child: chat[Chat.chatType] == "text"
                    ? Text(
                        chat[Chat.chatContent],
                        softWrap: true,
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          File(chat[Chat.chatContent]),
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Row myMsg(Map<String, dynamic> chat, Map<String, dynamic> sender) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: chat[Chat.chatType] == "text" ? 300 : 300,
                maxHeight: 300,
              ),
              child: Container(
                padding: EdgeInsets.all(chat[Chat.chatType] == "text" ? 10 : 0),
                decoration: BoxDecoration(
                  color: appTheme.primaryColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                    bottomLeft: Radius.circular(25),
                  ),
                ),
                child: chat[Chat.chatType] == "text"
                    ? Text(
                        chat[Chat.chatContent],
                        softWrap: true,
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          File(chat[Chat.chatContent]),
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Padding messageField() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 12,
      ),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 4,
        ),
        decoration: BoxDecoration(
          color: appTheme.colorScheme.surfaceBright,
          borderRadius: BorderRadius.circular(32),
        ),
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                manageUploadImage();
              },
              icon: Icon(Icons.image),
            ),
            Gap(4),
            Expanded(
              child: TextField(
                controller: textCtrl,
                style: TextStyle(
                  color: appTheme.colorScheme.onPrimary,
                  fontSize: 14,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Message",
                  hintStyle: TextStyle(
                    color: const Color.fromARGB(255, 156, 153, 153),
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: manageSendChat,
              icon: Icon(
                Icons.send,
                color: appTheme.colorScheme.secondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void manageSendChat() async {
    //

    var dateFormat = DateFormat("MMM, d, yyyy");
    TimeOfDay currentTime = TimeOfDay.now();
    String formattedTime =
        '${currentTime.hourOfPeriod}:${currentTime.minute} ${currentTime.period == DayPeriod.am ? 'AM' : 'PM'}';

    await Chat.adNewChat(chat: {
      Chat.comIdFk: com![Community.comId],
      Chat.userIdFk: user![User.userId],
      Chat.chatType: "text",
      Chat.chatDate: dateFormat.format(DateTime.now()),
      Chat.chatTime: formattedTime,
      Chat.chatContent: textCtrl.text,
    });

    setState(() {
      textCtrl.clear();
    });
  }

  void delChats() async {
    await Chat.deleteAllChats();
    setState(() {});
  }

  void manageUploadImage() async {
    //
    var dateFormat = DateFormat("MMM, d, yyyy");
    TimeOfDay currentTime = TimeOfDay.now();
    String formattedTime =
        '${currentTime.hourOfPeriod}:${currentTime.minute} ${currentTime.period == DayPeriod.am ? 'AM' : 'PM'}';

    final imgpicked =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (imgpicked == null) return;

    File? imgPath = await getImagePath(pickedFile: imgpicked);

    uploadImgURL = imgPath!.path;

    await Chat.adNewChat(chat: {
      Chat.comIdFk: com![Community.comId],
      Chat.userIdFk: user![User.userId],
      Chat.chatType: "media",
      Chat.chatDate: dateFormat.format(DateTime.now()),
      Chat.chatTime: formattedTime,
      Chat.chatContent: uploadImgURL,
    });

    setState(() {});
  }
}
