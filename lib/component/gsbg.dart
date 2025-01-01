import 'package:flutter/material.dart';

Positioned gsBg(img) {
  return Positioned(
    left: 0,
    top: 0,
    bottom: 0,
    right: 0,
    child: Container(
      width: double.infinity,
      height: double.infinity,
      child: Image.asset(
        "assets/images/gs/$img.jpg",
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
      ),
    ),
  );
}
