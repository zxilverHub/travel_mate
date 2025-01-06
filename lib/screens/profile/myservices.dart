import 'dart:io';

import 'package:flutter/material.dart';
import 'package:travelmate/component/headerComponent.dart';
import 'package:travelmate/db/communitydb.dart';
import 'package:travelmate/db/servicedb.dart';
import 'package:travelmate/db/userdb.dart';
import 'package:travelmate/models/sessions.dart';
import 'package:travelmate/screens/profile/addmyservice.dart';
import 'package:travelmate/theme/apptheme.dart';

class MyServices extends StatefulWidget {
  const MyServices({super.key});

  @override
  State<MyServices> createState() => _MyServicesState();
}

class _MyServicesState extends State<MyServices> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: addServiceBtn(context),
      body: SafeArea(
        child: Column(
          children: [
            header(
              context: context,
              title: "My services",
              sub: com![Community.comStreet],
              action: SizedBox(),
              index: 4,
            ),
            FutureBuilder(
              future: ServiceDb.getUserServices(userid: user![User.userId]),
              builder: (_, s) {
                if (s.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (s.connectionState == ConnectionState.done) {
                  if (s.hasData) {
                    final services = s.data;
                    return serviceList(services);
                  }
                }

                return Center(child: Text("No services"));
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget serviceList(services) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView.builder(
          itemCount: services.length,
          itemBuilder: (_, i) {
            final service = services[i];
            return Padding(
              padding: const EdgeInsets.only(
                bottom: 12,
              ),
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                      child: AspectRatio(
                        aspectRatio: 3 / 2,
                        child: Image.file(
                          File(service[ServiceDb.serviceimg]),
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    ListTile(
                      title: Text(service[ServiceDb.servicetitle]),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(service[ServiceDb.servicedesc]),
                          Text(
                              "${service[ServiceDb.opentime]} - ${service[ServiceDb.closetime]}"),
                        ],
                      ),
                      trailing: IconButton(
                        onPressed: () => manageOpenServiceOption(
                            service[ServiceDb.serviceid]),
                        icon: Icon(Icons.more_horiz),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  IconButton addServiceBtn(BuildContext context) {
    return IconButton(
      style: IconButton.styleFrom(
        backgroundColor: appTheme.primaryColor,
      ),
      onPressed: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => AddMyService(),
        ),
      ),
      icon: Icon(
        Icons.add,
        color: Colors.white,
        size: 48,
      ),
    );
  }

  manageOpenServiceOption(int servid) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Padding(
        padding: const EdgeInsets.only(
          top: 12,
          left: 12,
          right: 12,
          bottom: 12,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 218, 214, 214),
            borderRadius: BorderRadius.circular(16),
          ),
          child: ListTile(
            onTap: () async {
              await ServiceDb.deleteService(servid: servid);
              Navigator.pop(context);
              setState(() {});
            },
            title: Text("Delete"),
            leading: Icon(Icons.delete),
            trailing: Icon(Icons.arrow_right),
          ),
        ),
      ),
    );
  }
}
