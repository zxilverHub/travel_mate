import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:travelmate/db/communitydb.dart';
import 'package:travelmate/db/cornerdb.dart';
import 'package:travelmate/db/userdb.dart';
import 'package:travelmate/helper/imgpath.dart';
import 'package:travelmate/models/sessions.dart';
import 'package:travelmate/screens/community/cornerscreen.dart';
import 'package:travelmate/screens/mainscreen.dart';
import 'package:travelmate/theme/apptheme.dart';

class AddCorner extends StatefulWidget {
  const AddCorner({super.key});

  @override
  State<AddCorner> createState() => _AddCornerState();
}

class _AddCornerState extends State<AddCorner> {
  var cornerCtrl = TextEditingController();
  String? imgURL;
  File? imgPreview;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 12,
                  right: 12,
                  top: 12,
                ),
                child: Container(
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
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back_ios_sharp,
                        color: Colors.white,
                      ),
                    ),
                    title: Text("Add corner"),
                    subtitle: Text(com![Community.comStreet]),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextField(
                      controller: cornerCtrl,
                      style: appTheme.textTheme.bodyMedium,
                      minLines: 10,
                      maxLines:
                          null, // Allows dynamic height for a textarea-like input
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        hintText: "Add your corner",
                        hintStyle: TextStyle(
                          color: const Color.fromARGB(255, 138, 136, 136),
                        ),
                        // Keeps label at the top
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    Gap(12),
                    imgPreview == null
                        ? SizedBox()
                        : Column(
                            children: [
                              AspectRatio(
                                aspectRatio: 3 / 2,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.file(
                                    File(imgPreview!.path),
                                    width:
                                        MediaQuery.of(context).size.width - 24,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Gap(6),
                            ],
                          ),
                    TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 14,
                        ),
                        backgroundColor:
                            const Color.fromARGB(255, 153, 156, 153),
                        foregroundColor: Colors.white,
                      ),
                      onPressed: manageAddImage,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(Icons.image),
                          Gap(6),
                          Text(imgPreview == null
                              ? "Add image"
                              : "Change image"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: maangeSubmitCorner,
                child: Container(
                  width: MediaQuery.of(context).size.width - 24,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: appTheme.primaryColor,
                  ),
                  child: Text(
                    "Submit",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
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

  void manageAddImage() async {
    final imagePicked =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (imagePicked == null) return;

    File? pickedURL = await getImagePath(pickedFile: imagePicked);

    setState(() {
      imgPreview = File(imagePicked.path);
      imgURL = pickedURL!.path;
    });
  }

  void maangeSubmitCorner() async {
    if (cornerCtrl.text.trim() == "") {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please add your corner."),
        ),
      );
      return;
    }

    var dateFormat = DateFormat("MMM, d, yyyy");
    TimeOfDay currentTime = TimeOfDay.now();
    String formattedTime =
        '${currentTime.hourOfPeriod}:${currentTime.minute} ${currentTime.period == DayPeriod.am ? 'AM' : 'PM'}';

    await Corner.addNewCorner(corner: {
      Corner.userIdFk: user![User.userId],
      Corner.comIdFk: com![Community.comId],
      Corner.cornerContent: cornerCtrl.text,
      Corner.cornerImg: imgURL,
      Corner.cornerDate: dateFormat.format(DateTime.now()),
      Corner.cornerTime: formattedTime,
    });

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CornerScreen(),
      ),
    );
  }
}
