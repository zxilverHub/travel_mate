import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:scrabble_word_checker/scrabble_word_checker.dart';
import 'package:travelmate/component/headerComponent.dart';
import 'package:travelmate/db/chatdb.dart';
import 'package:travelmate/db/communitydb.dart';
import 'package:travelmate/models/itemslist.dart';
import 'package:travelmate/models/sessions.dart';
import 'package:travelmate/theme/apptheme.dart';

class ComDataScreen extends StatefulWidget {
  ComDataScreen({super.key});

  @override
  State<ComDataScreen> createState() => _ComDataScreenState();
}

class _ComDataScreenState extends State<ComDataScreen> {
  String allChats = "";
  List<Words> fWords = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getAllChatsText();
  }

  List<String> validItems = vitems.map((vi) => vi.toLowerCase()).toList();

  Future getAllChatsText() async {
    print(validItems);
    var chats = await Chat.fetchAllChatsFromCom(comid: com![Community.comId]);

    List<String> chatItems = [];

    // Loop through each chat and check if the content is in validItems (case-insensitive)
    for (int i = 0; i < chats.length; i++) {
      validItems.forEach((vi) {
        if (chats[i][Chat.chatContent].contains(vi)) {
          chatItems.add(chats[i][Chat.chatContent]);
        }
      });
    }

    List<Words> filtered = [];

    // Iterate over chat items to count occurrences
    chatItems.forEach((ci) {
      bool isHave = false;

      for (var word in filtered) {
        if (word.word == ci) {
          isHave = true;
          word.increment(); // Increment the count if the word exists
          break;
        }
      }

      // If word doesn't exist in filtered list, add it with count = 1
      if (!isHave) {
        filtered.add(Words(word: ci));
      }
    });

    filtered.sort((a, b) => b.count.compareTo(a.count));

    print(filtered); // Print the filtered list with word counts

    setState(() {
      fWords = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            children: [
              dataHeader(context),
              fWords.isEmpty ? CircularProgressIndicator() : wordsList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget wordsList() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 18,
      ),
      child: Column(
        children: fWords.map((w) {
          int totalWordCount = fWords.fold(0, (sum, word) => sum + word.count);
          double percentage = (w.count / totalWordCount) * 100;
          var fullWidth = MediaQuery.of(context).size.width - 24;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                w.word,
                style: appTheme.textTheme.titleLarge,
              ),
              Gap(6),
              Container(
                width: fullWidth,
                height: 28,
                decoration: BoxDecoration(
                  color: appTheme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      height: 28,
                      width: fullWidth * (percentage / 100),
                      decoration: BoxDecoration(
                        color: appTheme.colorScheme.secondary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          "${percentage.toStringAsFixed(2)}%",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Gap(14),
            ],
          );
        }).toList(),
      ),
    );
  }

  Container dataHeader(BuildContext context) {
    return Container(
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
        title: Text("Community data"),
        subtitle: Text(com![Community.comStreet]),
      ),
    );
  }
}

class Words {
  late String word;
  int count = 1;

  Words({
    required this.word,
  });

  // Increment count
  void increment() {
    count++;
  }
}
