import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:travelmate/component/headerComponent.dart';
import 'package:travelmate/db/communitydb.dart';
import 'package:travelmate/db/cornerdb.dart';
import 'package:travelmate/db/userdb.dart';
import 'package:travelmate/models/sessions.dart';
import 'package:travelmate/screens/community/addcornerscreen.dart';
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
          cornersList(myCorner),
          Gap(12),
          Text(
            "Community",
            style: appTheme.textTheme.headlineLarge,
          ),
          Gap(12),
          cornersList(comCorners),
        ],
      ),
    );
  }

  Column cornersList(List<Map<String, dynamic>> corners) {
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
                            padding: const EdgeInsets.all(16),
                            child: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 243, 240, 240),
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
}
