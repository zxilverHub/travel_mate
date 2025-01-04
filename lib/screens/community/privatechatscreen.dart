import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:travelmate/component/headerComponent.dart';
import 'package:travelmate/db/chatcontentdb.dart';
import 'package:travelmate/db/communitydb.dart';
import 'package:travelmate/db/privatechatdb.dart';
import 'package:travelmate/db/userdb.dart';
import 'package:travelmate/helper/imgpath.dart';
import 'package:travelmate/models/sessions.dart';
import 'package:travelmate/theme/apptheme.dart';

class PrivateChatScreen extends StatefulWidget {
  PrivateChatScreen({super.key, required this.pchat});

  Map<String, dynamic> pchat;

  @override
  State<PrivateChatScreen> createState() => _PrivateChatScreenState();
}

class _PrivateChatScreenState extends State<PrivateChatScreen> {
  Map<String, dynamic>? person;
  var textCtrl = TextEditingController();
  String? uploadImgURL;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initPerson();
  }

  Future initPerson() async {
    int personId = user![User.userId] == widget.pchat[PrivateChat.senderIdFk]
        ? widget.pchat[PrivateChat.receiverIdFk]
        : widget.pchat[PrivateChat.senderIdFk];
    Map<String, dynamic> shownPerson = await User.getUserInfo(userid: personId);
    setState(() {
      person = shownPerson;
    });
  }

  Widget personProfile() {
    return person![User.imgURL] == null
        ? Text(person![User.username][0])
        : Image.file(
            File(person![User.imgURL]),
            width: double.infinity,
            height: double.infinity,
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: person == null
          ? Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Column(
                children: [
                  header(
                    context: context,
                    title: person![User.username],
                    sub: com![Community.comCity],
                    action: ClipOval(
                      child: CircleAvatar(
                        radius: 20,
                        child: personProfile(),
                      ),
                    ),
                    index: 2,
                  ),
                  FutureBuilder(
                    future: ChatContent.getAllChats(
                        pchatid: widget.pchat[PrivateChat.pChatId]),
                    builder: (_, s) {
                      if (s.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      if (s.connectionState == ConnectionState.done) {
                        if (s.hasData) {
                          final chats = s.data;
                          return chatList(chats!);
                        }
                      }

                      return Center(child: CircularProgressIndicator());
                    },
                  ),
                  messageField(),
                ],
              ),
            ),
    );
  }

  Widget chatList(List<Map<String, dynamic>> chats) {
    final revChats = chats.reversed.toList();
    return Expanded(
      child: ListView.builder(
        reverse: true,
        padding: EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 6,
        ),
        itemCount: revChats.length,
        itemBuilder: (_, i) {
          final chat = revChats[i];
          if (chat[ChatContent.userIdFk] == person![User.userId]) {
            return msgFromOther(chat, person!);
          }
          return myMsg(chat, user!);
        },
      ),
    );
  }

  Widget msgFromOther(Map<String, dynamic> chat, Map<String, dynamic> sender) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
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
                  maxWidth: chat[ChatContent.contentType] == "text" ? 300 : 300,
                  maxHeight: 300,
                ),
                child: Container(
                  padding: EdgeInsets.all(
                      chat[ChatContent.contentType] == "text" ? 10 : 0),
                  decoration: const BoxDecoration(
                    color: Color(0xFFD9D9D9),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                      bottomRight: Radius.circular(25),
                    ),
                  ),
                  child: chat[ChatContent.contentType] == "text"
                      ? Text(
                          chat[ChatContent.content],
                          softWrap: true,
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            File(chat[ChatContent.content]),
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
      ),
    );
  }

  Widget myMsg(Map<String, dynamic> chat, Map<String, dynamic> sender) {
    return GestureDetector(
      onLongPress: () => showDeleteModal(chat[ChatContent.contentId]),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth:
                        chat[ChatContent.contentType] == "text" ? 300 : 300,
                    maxHeight: 300,
                  ),
                  child: Container(
                    padding: EdgeInsets.all(
                        chat[ChatContent.contentType] == "text" ? 10 : 0),
                    decoration: BoxDecoration(
                      color: appTheme.primaryColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25),
                        bottomLeft: Radius.circular(25),
                      ),
                    ),
                    child: chat[ChatContent.contentType] == "text"
                        ? Text(
                            chat[ChatContent.content],
                            softWrap: true,
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              File(chat[ChatContent.content]),
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
        ),
      ),
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
              onPressed: () => manageUploadImage(),
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
              onPressed: () => manageSendChat(),
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
    var dateFormat = DateFormat("MMM, d, yyyy");
    TimeOfDay currentTime = TimeOfDay.now();
    String formattedTime =
        '${currentTime.hourOfPeriod}:${currentTime.minute} ${currentTime.period == DayPeriod.am ? 'AM' : 'PM'}';

    await ChatContent.addNewChatContent(content: {
      ChatContent.pChatIdFk: widget.pchat[PrivateChat.pChatId],
      ChatContent.contentType: "text",
      ChatContent.content: textCtrl.text,
      ChatContent.userIdFk: user![User.userId],
      ChatContent.chatDate: dateFormat.format(DateTime.now()),
      ChatContent.chatTime: formattedTime,
    });

    setState(() {
      textCtrl.clear();
    });
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

    await ChatContent.addNewChatContent(content: {
      ChatContent.pChatIdFk: widget.pchat[PrivateChat.pChatId],
      ChatContent.contentType: "media",
      ChatContent.content: uploadImgURL,
      ChatContent.userIdFk: user![User.userId],
      ChatContent.chatDate: dateFormat.format(DateTime.now()),
      ChatContent.chatTime: formattedTime,
    });

    setState(() {
      uploadImgURL = null;
    });
  }

  void showDeleteModal(int chatid) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 12,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Divider(
              color: Colors.grey,
            ),
            Gap(8),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
                manageDeleteChat(chatid);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 219, 214, 214),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: Icon(Icons.delete),
                  title: Text("Delete"),
                  trailing: Icon(Icons.arrow_right),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void manageDeleteChat(int chatid) async {
    // delete msg
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          "Delete message",
          style: appTheme.textTheme.titleLarge,
        ),
        content: Text("Are you sure to delete message?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("No"),
          ),
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: appTheme.primaryColor,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              await ChatContent.deleteMessage(chatid: chatid);
              Navigator.pop(context);
              setState(() {});
            },
            child: Text("Yes"),
          ),
        ],
      ),
    );
  }
}
