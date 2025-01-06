import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:geocoding/geocoding.dart';
import 'package:travelmate/db/communitydb.dart';
import 'package:travelmate/db/servicedb.dart';
import 'package:travelmate/db/userdb.dart';
import 'package:travelmate/helper/getPlacemarks.dart';
import 'package:travelmate/helper/locationhelper.dart';
import 'package:travelmate/models/sessions.dart';
import 'package:travelmate/screens/home/viewservice.dart';
import 'package:travelmate/screens/sos/sosscreen.dart';
import 'package:travelmate/theme/apptheme.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return com == null || user == null
        ? Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Gap(32),
                Text("No internet connection."),
                Gap(12),
                retryBtn(),
              ],
            ),
          )
        : Stack(
            children: [
              Positioned(
                child: Container(),
              ),
              header(),
              midContent(),
            ],
          );
  }

  ElevatedButton retryBtn() {
    return ElevatedButton(
      onPressed: () async {
        await getPlaceMrk(locactionData);
        setState(() {});
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.refresh),
          Gap(8),
          Text("Retry"),
        ],
      ),
    );
  }

  Positioned midContent() {
    return Positioned(
      top: 150,
      left: 12,
      right: 12,
      bottom: 12,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Welcome to",
              style: appTheme.textTheme.headlineLarge,
            ),
            Gap(6),
            Text(
              "${com![Community.comStreet]}, ${com![Community.comCity]}, ${com![Community.comProvince]}",
              style: appTheme.textTheme.displayLarge,
            ),
            Gap(32),
            Text(
              "Services",
              style: appTheme.textTheme.headlineMedium,
            ),
            Gap(6),
            services == null || services!.isEmpty
                ? Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 1.7,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Opacity(
                      opacity: 0.7,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.sentiment_dissatisfied_outlined,
                              size: 56,
                              color: Colors.grey,
                            ),
                            Gap(12),
                            Text("No services available in your community."),
                            Gap(12),
                            retryBtn(),
                          ],
                        ),
                      ),
                    ),
                  )
                : Wrap(
                    runSpacing: 12,
                    spacing: 12,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: services!.map((serv) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ViewService(
                                serv: serv,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width / 2 - 18,
                          padding: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            children: [
                              AspectRatio(
                                aspectRatio: 2 / 2,
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(12),
                                    topRight: Radius.circular(12),
                                    bottomLeft: Radius.circular(6),
                                    bottomRight: Radius.circular(6),
                                  ),
                                  child: Image.file(
                                    File(serv[ServiceDb.serviceimg]),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Gap(2),
                                  Text(
                                    serv[ServiceDb.servicetitle],
                                    style: appTheme.textTheme.titleLarge,
                                  ),
                                  Text(
                                    "${serv[ServiceDb.opentime]} - ${serv[ServiceDb.closetime]}",
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Gap(2),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
          ],
        ),
      ),
    );
  }

  Positioned header() {
    return Positioned(
      top: 64,
      left: 12,
      right: 12,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.only(
              top: 8,
              bottom: 8,
              right: 16,
              left: 8,
            ),
            decoration: BoxDecoration(
              color: appTheme.colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Row(
              children: [
                ClipOval(
                  child: CircleAvatar(
                    radius: 22,
                    backgroundColor: appTheme.primaryColor,
                    child: user![User.imgURL] == null
                        ? Text(user![User.username][0])
                        : Image.file(
                            File(user![User.imgURL]),
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                Gap(8),
                Text(user![User.username]),
              ],
            ),
          ),
          IconButton(
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(
                appTheme.colorScheme.error,
              ),
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => SosScreen(),
                ),
              );
            },
            icon: Icon(
              Icons.sos,
              color: appTheme.colorScheme.secondaryContainer,
            ),
          ),
        ],
      ),
    );
  }
}
