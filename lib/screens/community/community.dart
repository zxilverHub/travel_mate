import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:travelmate/db/chatcontentdb.dart';
import 'package:travelmate/db/communitydb.dart';
import 'package:travelmate/db/cornerdb.dart';
import 'package:travelmate/db/privatechatdb.dart';
import 'package:travelmate/db/userdb.dart';
import 'package:travelmate/models/sessions.dart';
import 'package:travelmate/screens/community/cornerscreen.dart';
import 'package:travelmate/screens/community/groupchat.dart';
import 'package:travelmate/screens/community/privatechatscreen.dart';
import 'package:travelmate/theme/apptheme.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 64,
          left: 12,
          right: 12,
          bottom: 0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Community",
                style: appTheme.textTheme.headlineLarge,
              ),
              Gap(12),
              GestureDetector(
                onTap: handleGroupCardClicked,
                child: communityCard(),
              ),
              Gap(12),
              GestureDetector(
                  onTap: handleCornerCardClicked, child: cornerCard()),
              Gap(18),
              Text(
                "Private chats",
                style: appTheme.textTheme.headlineLarge,
              ),
              Gap(12),
              userPrivateChats()
            ],
          ),
        ),
      ],
    );
  }

  Widget userPrivateChats() {
    return FutureBuilder(
      future: PrivateChat.fetchAllUserPrivateChats(userid: user![User.userId]),
      builder: (_, s) {
        if (s.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (s.connectionState == ConnectionState.done) {
          if (s.hasData && s.data != null) {
            final privateChats = s.data as List;
            if (privateChats.isNotEmpty) {
              return Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.all(0),
                  itemCount: privateChats.length,
                  itemBuilder: (_, i) {
                    final pchat = privateChats[i];
                    return GestureDetector(
                      onTap: () => managePrivateChatCardClicked(pchat),
                      child: privateChatCard(pchat),
                    );
                  },
                ),
              );
            } else {
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
                      "No chats",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color.fromARGB(255, 160, 155, 155),
                      ),
                    ),
                  ),
                ],
              );
            }
          } else {
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
                    "No chats",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color.fromARGB(255, 160, 155, 155),
                    ),
                  ),
                ),
              ],
            );
          }
        }

        return SizedBox();
      },
    );
  }

  Widget privateChatCard(Map<String, dynamic> chat) {
    int shownUser = chat[PrivateChat.senderIdFk] == user![User.userId]
        ? chat[PrivateChat.receiverIdFk]
        : chat[PrivateChat.senderIdFk];
    return FutureBuilder(
      future: User.getUserInfo(userid: shownUser),
      builder: (_, s) {
        if (s.connectionState == ConnectionState.waiting) {
          return SizedBox();
        }

        if (s.connectionState == ConnectionState.done) {
          if (s.hasData) {
            final shown = s.data;
            return Padding(
              padding: const EdgeInsets.only(
                bottom: 12,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: ListTile(
                  leading: ClipOval(
                    child: CircleAvatar(
                      radius: 24,
                      backgroundColor: appTheme.primaryColor,
                      child: shown![User.imgURL] == null
                          ? Text(shown[User.username][0])
                          : Image.file(
                              File(shown[User.imgURL]),
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  title: Text(
                    shown[User.username],
                    style: appTheme.textTheme.titleLarge,
                  ),
                  subtitle: lastChatInChatCard(chat[PrivateChat.pChatId]),
                ),
              ),
            );
          }
        }

        return SizedBox();
      },
    );
  }

  Widget lastChatInChatCard(int pChatId) {
    return FutureBuilder(
      future: ChatContent.getLastChat(pChatId: pChatId),
      builder: (_, s) {
        if (s.connectionState == ConnectionState.waiting) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [Text("Loading...")],
          );
        }

        if (s.connectionState == ConnectionState.done) {
          if (s.hasData) {
            final content = s.data;
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                content![ChatContent.contentType] == "text"
                    ? Expanded(
                        child: Text(
                          user![User.userId] == content[ChatContent.userIdFk]
                              ? "You: ${content[ChatContent.content]}"
                              : content[ChatContent.content],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      )
                    : Expanded(
                        child: Text(
                          user![User.userId] == content[ChatContent.userIdFk]
                              ? "You: Sent a photo"
                              : "Sent a photo",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                Text(
                  content[ChatContent.chatTime].toString(),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            );
          }
        }

        return SizedBox();
      },
    );
  }

  Container cornerCard() {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        title: Text(
          "Community corner",
          style: appTheme.textTheme.titleLarge,
        ),
        leading: CircleAvatar(
          radius: 24,
          child: Image.asset(
            "assets/images/app/cornericon.png",
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.contain,
          ),
        ),
        trailing: CircleAvatar(
          child: Text(corners!.length.toString()),
        ),
      ),
    );
  }

  Container communityCard() {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        subtitle: Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: appTheme.primaryColor,
                borderRadius: BorderRadius.circular(32),
              ),
              child: Text(
                com![Community.comProvince],
                style: appTheme.textTheme.labelLarge,
              ),
            ),
            Gap(6),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(32),
              ),
              child: Text(
                com![Community.comCity],
                style: appTheme.textTheme.labelLarge,
              ),
            ),
          ],
        ),
        title: Text(
          "${com![Community.comStreet]} community",
          style: appTheme.textTheme.titleLarge,
        ),
        leading: CircleAvatar(
          radius: 32,
          child: Image.asset(
            "assets/images/app/comicon.png",
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  void handleGroupCardClicked() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => GroupChat(
          comid: com![Community.comId],
        ),
      ),
    );
  }

  void handleCornerCardClicked() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CornerScreen(),
      ),
    );
  }

  managePrivateChatCardClicked(Map<String, dynamic> pchat) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PrivateChatScreen(
          pchat: pchat,
        ),
      ),
    );
  }
}
