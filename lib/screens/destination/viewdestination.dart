import 'package:flutter/material.dart';
import 'package:travelmate/component/headerComponent.dart';

class ViewDestination extends StatefulWidget {
  ViewDestination({super.key, required this.placeDetails});

  Map<String, dynamic> placeDetails;

  @override
  State<ViewDestination> createState() => _ViewDestinationState();
}

class _ViewDestinationState extends State<ViewDestination> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Image.network(
            widget.placeDetails["photos"][0]["photo_reference"],
          ),
        ),
      ],
    ));
  }
}
