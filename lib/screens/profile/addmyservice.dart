import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:travelmate/db/communitydb.dart';
import 'package:travelmate/db/servicedb.dart';
import 'package:travelmate/db/userdb.dart';
import 'package:travelmate/helper/imgpath.dart';
import 'package:travelmate/helper/locationhelper.dart';
import 'package:travelmate/models/sessions.dart';
import 'package:travelmate/screens/profile/myservices.dart';
import 'package:travelmate/theme/apptheme.dart';

class AddMyService extends StatefulWidget {
  const AddMyService({super.key});

  @override
  State<AddMyService> createState() => _AddMyServiceState();
}

class _AddMyServiceState extends State<AddMyService> {
  var titleCtrl = TextEditingController();
  var descCtrl = TextEditingController();
  var openCtrl = TextEditingController();
  var closeCtrl = TextEditingController();

  File? serviceIMG;
  String? imgURL;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            addServiceHeader(context),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: ListView(
                  children: [
                    TextField(
                      controller: titleCtrl,
                      style: textFieldTextDesign(),
                      decoration: textFiledDesign("Service name"),
                    ),
                    Gap(14),
                    TextField(
                      maxLines: null,
                      minLines: 5,
                      controller: descCtrl,
                      style: textFieldTextDesign(),
                      decoration: textFiledDesign("Description"),
                    ),
                    Gap(14),
                    serviceIMG == null
                        ? SizedBox()
                        : Column(
                            children: [
                              AspectRatio(
                                aspectRatio: 3 / 2,
                                child: Image.file(
                                  File(serviceIMG!.path),
                                  width: double.infinity,
                                  height: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Gap(12),
                            ],
                          ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(12),
                        backgroundColor:
                            const Color.fromARGB(255, 189, 184, 184),
                      ),
                      onPressed: () => manageAddImage(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.image,
                            color: Colors.white,
                          ),
                          Gap(12),
                          Text(
                            serviceIMG == null ? "Add image" : "Change image",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Gap(14),
                    TextField(
                      readOnly: true,
                      controller: openCtrl,
                      style: textFieldTextDesign(),
                      decoration: textFiledDesign("Open time").copyWith(
                        suffixIcon: GestureDetector(
                            onTap: () async {
                              TimeOfDay? open = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );

                              if (open == null) return;

                              setState(() {
                                final hours = open.hourOfPeriod == 0
                                    ? 12
                                    : open.hourOfPeriod;
                                final minutes =
                                    open.minute.toString().padLeft(2, '0');
                                final period =
                                    open.period == DayPeriod.am ? 'AM' : 'PM';
                                openCtrl.text = '$hours:$minutes $period';
                              });
                            },
                            child: Icon(Icons.schedule)),
                      ),
                    ),
                    Gap(14),
                    TextField(
                      readOnly: true,
                      controller: closeCtrl,
                      style: textFieldTextDesign(),
                      decoration: textFiledDesign("Close time").copyWith(
                        suffixIcon: GestureDetector(
                          onTap: () async {
                            TimeOfDay? close = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );

                            if (close == null) return;

                            setState(() {
                              // Convert TimeOfDay to 12-hour formatted string
                              final hours = close.hourOfPeriod == 0
                                  ? 12
                                  : close
                                      .hourOfPeriod; // Convert 0 to 12 for midnight
                              final minutes =
                                  close.minute.toString().padLeft(2, '0');
                              final period =
                                  close.period == DayPeriod.am ? 'AM' : 'PM';
                              closeCtrl.text = '$hours:$minutes $period';
                            });
                          },
                          child: Icon(Icons.schedule),
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
    );
  }

  TextStyle textFieldTextDesign() {
    return TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w500,
      fontSize: 16,
    );
  }

  InputDecoration textFiledDesign(String lbl) {
    return InputDecoration(
      floatingLabelBehavior: FloatingLabelBehavior.always,
      floatingLabelAlignment: FloatingLabelAlignment.start,
      label: Text(
        lbl,
        style: appTheme.textTheme.titleLarge,
      ),
      hintText: lbl,
      hintStyle: TextStyle(
        color: Colors.grey,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: Colors.black54,
          width: 1,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.black54,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  Padding addServiceHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 12,
        right: 12,
        top: 12,
      ),
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 6,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: ListTile(
          leading: IconButton(
            style: IconButton.styleFrom(
              backgroundColor: appTheme.colorScheme.surfaceContainer,
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => MyServices(),
                ),
              );
            },
            icon: Icon(
              Icons.arrow_back_ios_sharp,
              color: Colors.white,
            ),
          ),
          title: Text("Add service"),
          trailing: TextButton(
            style: TextButton.styleFrom(
              backgroundColor: appTheme.primaryColor,
            ),
            onPressed: () => manageSaveServie(),
            child: Text(
              "Save",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }

  manageAddImage() async {
    final imagePicked =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (imagePicked == null) return;

    File? pickedURL = await getImagePath(pickedFile: imagePicked);

    imgURL = pickedURL!.path;
    setState(() {
      serviceIMG = File(imagePicked.path);
    });
  }

  manageSaveServie() async {
    if (titleCtrl.text.trim() == "" ||
        descCtrl.text.trim() == "" ||
        openCtrl.text == "" ||
        closeCtrl.text == "" ||
        imgURL == null) {
      showErrorSnackBat();
      return;
    }

    await ServiceDb.addNewService(service: {
      ServiceDb.servicetitle: titleCtrl.text,
      ServiceDb.servicedesc: descCtrl.text,
      ServiceDb.serviceimg: imgURL,
      ServiceDb.useridfk: user![User.userId],
      ServiceDb.comidfk: com![Community.comId],
      ServiceDb.servicelat: locactionData!.latitude,
      ServiceDb.servicelng: locactionData!.longitude,
      ServiceDb.opentime: openCtrl.text,
      ServiceDb.closetime: closeCtrl.text,
    });

    var returnedServices =
        await ServiceDb.fetchComServices(comid: com![Community.comId]);
    services = returnedServices;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MyServices(),
      ),
    );
  }

  showErrorSnackBat() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Please fill all inputs"),
      ),
    );
  }
}
