import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebScreen extends StatefulWidget {
  WebScreen({required this.url, required this.title,required this.description});

  final url;
  final title;
  final description;
  @override
  State<WebScreen> createState() => _WebScreenState();
}

class _WebScreenState extends State<WebScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.blue,
        ),
        actions: [
          IconButton(
              onPressed: () async {
                String currEmail = FirebaseAuth.instance.currentUser!.email!;
                final docUser = FirebaseFirestore.instance
                    .collection('users')
                    .doc(currEmail);
                int count = 0;
                var docSnapshot = await docUser.get();
                Map<String, dynamic>? data = docSnapshot.data();
                count = data!['count'];
                bool flag = true;
                for (var i = 1; i <= count; i++) {
                  String urlKey = 'url-' + i.toString();
                  String bookmarkedUrl = data[urlKey];
                  if (bookmarkedUrl == widget.url) {
                    flag = false;
                  }
                }
                if (flag) {
                  count++;
                  String urlS = 'url-' + count.toString();
                  String titleS = 'title-' + count.toString();
                  String descriptionS = 'description-' + count.toString();
                  final bookmarkData = {
                    urlS: widget.url,
                    titleS: widget.title,
                    descriptionS: widget.description,
                    'count': count
                  };

                  await docUser.update(bookmarkData);
                  Fluttertoast.showToast(msg: "News Boookmarked!");
                }
                else{
                   Fluttertoast.showToast(msg: "You have already bookmarked this news.");
                }
              },
              icon: const Icon(Icons.bookmark_add))
        ],
        backgroundColor: Colors.white,
        title:
            Row(mainAxisAlignment: MainAxisAlignment.center, children: const [
          Text(
            'News',
            style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
          ),
          Text(
            'I',
            style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
          ),
        ]),
      ),
      body: WebView(
        initialUrl: widget.url,
      ),
    );
  }
}
