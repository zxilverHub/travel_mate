import 'package:flutter/material.dart';
import 'package:travelmate/theme/apptheme.dart';

PreferredSize header(
    {required BuildContext context,
    required String title,
    required String sub,
    required Widget action}) {
  return PreferredSize(
    preferredSize: Size(MediaQuery.of(context).size.width - 24, 500),
    child: Padding(
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
          title: Text(title),
          subtitle: Text(sub),
          trailing: action,
        ),
      ),
    ),
  );
}
