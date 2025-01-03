import 'package:flutter/material.dart';

class Chatmodel {
  late int id;
  int comid = 1;
  late int userid;
  late String chatType;
  DateTime date = DateTime.now();
  TimeOfDay time = TimeOfDay.now();
  late String chatcontent;

  Chatmodel({
    required this.id,
    required this.userid,
    required this.chatType,
    required this.chatcontent,
  });
}

List<Chatmodel> chatsFromModel = [
  Chatmodel(
    id: 1,
    userid: 1,
    chatType: "text",
    chatcontent: "Hello!",
  ),
  Chatmodel(
    id: 2,
    userid: 1,
    chatType: "media",
    chatcontent: "assets/images/gs/signbg.jpg",
  ),
  Chatmodel(
    id: 3,
    userid: 2,
    chatType: "text",
    chatcontent:
        "Hello! sanldkn sdjasnd ajd ajdo adja das doas dja sd jasdojs adjsa djsa das dj",
  ),
  Chatmodel(
    id: 4,
    userid: 2,
    chatType: "media",
    chatcontent: "assets/images/gs/0.jpg",
  ),
];
