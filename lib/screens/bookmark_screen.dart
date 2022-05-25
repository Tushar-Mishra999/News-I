import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:red_hat_up/screens/web_screen.dart';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({Key? key}) : super(key: key);

  @override
  State<BookmarkScreen> createState() => _BookMarkScreenState();
}

class _BookMarkScreenState extends State<BookmarkScreen> {
  late Future myFuture;
  List<String> title = [];
  List<String> description = [];
  List<String> url = [];
  Future<void> getData() async {
    try {
      String currEmail = FirebaseAuth.instance.currentUser!.email!;
      final docUser =
          FirebaseFirestore.instance.collection('users').doc(currEmail);
      int count = 0;
      var docSnapshot = await docUser.get();
      Map<String, dynamic>? data = docSnapshot.data();
      count = data!['count'];
      for (var i = 1; i <= count; i++) {
        String titleKey = 'title-' + i.toString();
        String descriptionKey = 'description-' + i.toString();
        String urlKey = 'url-' + i.toString();
        title.add(data[titleKey]);
        description.add(data[descriptionKey]);
        url.add(data[urlKey]);
      }
    } catch (e) {
      print(e);
      return Future.error(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    myFuture = getData();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.purple,
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Bookmarked News',
          style: TextStyle(color: Colors.purple),
        ),
      ),
      body: FutureBuilder(
          future: myFuture,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return GestureDetector(
                onTap: () async {
                  if (!(await InternetConnectionChecker().hasConnection)) {
                    Fluttertoast.showToast(
                        msg: "Please check your internet connection");
                  } else {
                    myFuture = getData();
                    setState(() {});
                  }
                },
                child: const Center(
                    child: Text(
                  "Tap To Refresh",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                )),
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator(
                color: Colors.purple,
              ));
            } else {
              return RefreshIndicator(
                displacement: 100,
                onRefresh: getData,
                child: ListView(children: [
                  ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: title.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WebScreen(
                                  url: url[index],
                                  title: title[index],
                                  description: description[index],
                                ),
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.all(10),
                            padding: const EdgeInsets.all(10),
                            width: size.width * 0.8,
                            height: size.height * 0.12,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.purple.shade100,
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.grey,
                                  offset: Offset(4.0, 6.0), //(x,y)
                                  blurRadius: 5.0,
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Text(
                                  title[index],
                                  style: TextStyle(
                                      color: Colors.red.shade700,
                                      fontSize: size.height * 0.02,
                                      fontWeight: FontWeight.bold),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                ]),
              );
            }
          }),
    );
  }
}
