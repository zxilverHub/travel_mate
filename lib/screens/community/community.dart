import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:travelmate/db/communitydb.dart';
import 'package:travelmate/db/cornerdb.dart';
import 'package:travelmate/models/sessions.dart';
import 'package:travelmate/screens/community/cornerscreen.dart';
import 'package:travelmate/screens/community/groupchat.dart';
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

  Expanded userPrivateChats() {
    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.all(0),
        itemCount: 2,
        itemBuilder: (_, i) {
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
                leading: CircleAvatar(
                  radius: 24,
                  backgroundColor: appTheme.primaryColor,
                  child: Text("DP"),
                ),
                title: Text(
                  "USERNAME",
                  style: appTheme.textTheme.titleLarge,
                ),
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("LAST CHAT"),
                    Text("TIME SENT"),
                  ],
                ),
              ),
            ),
          );
        },
      ),
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
}
