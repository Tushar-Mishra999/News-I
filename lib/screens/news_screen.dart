import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:red_hat_up/components/shimmer_card.dart';
import 'package:red_hat_up/screens/web_screen.dart';

import '../routes.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({Key? key}) : super(key: key);

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  late Future myFuture;
  List<dynamic> newsList = [];
  @override
  void initState() {
    super.initState();
    myFuture = getData();
  }

  Future<bool?> showAlertDialog() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Do you want to exit?'),
            actions: [
              TextButton(
                child: Text("CANCEL"),
                onPressed: () {
                  Navigator.pop(context, false);
                },
              ),
              TextButton(
                child: Text("YES"),
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pop(context, true);
                },
              )
            ],
          );
        });
  }

  Future<void> getData() async {
    try {
      var response = await http.get(Uri.parse(
          'https://newsapi.org/v2/top-headlines?country=in&category=general&apiKey=7c4f2cc0051f4f9e906f7fa0124672ed'));
      var jsonData = await jsonDecode(response.body);
      jsonData['articles'].forEach((element) {
        if (element['description'] != null &&
            element['url'] != null &&
            element['urlToImage'] != null &&
            element['content'] != null) {
          newsList.add(element);
        }
      });
      print(newsList);
    } catch (e) {
      print(e);
      return Future.error(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        final shouldPop = await showAlertDialog();
        return shouldPop ?? false;
      },
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.bookmark,
                  color: Colors.blue,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.bookmarkScreen);
                },
              )
            ],
            leading: SizedBox(width: size.width * 0.4),
            title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'News',
                    style: TextStyle(
                        color: Colors.orange, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'I',
                    style: TextStyle(
                        color: Colors.green, fontWeight: FontWeight.bold),
                  ),
                ]),
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
                } else {
                  return RefreshIndicator(
                    displacement: 100,
                    onRefresh: getData,
                    child: ListView(children: [
                      ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: snapshot.connectionState ==
                                  ConnectionState.waiting
                              ? 3
                              : newsList.length,
                          itemBuilder: (context, index) {
                            return snapshot.connectionState ==
                                    ConnectionState.waiting
                                ? ShimmerCard()
                                : GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => WebScreen(
                                                url: newsList[index]['url'],
                                                title: newsList[index]['title'],
                                                description: newsList[index]
                                                    ['description'])),
                                      );
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.all(8),
                                      padding: const EdgeInsets.all(7),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.orange.shade100,
                                            spreadRadius: 5,
                                            blurRadius: 5,
                                            offset: const Offset(0,
                                                0), // changes position of shadow
                                          ),
                                        ],
                                      ),
                                      child: Column(children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          child: CachedNetworkImage(
                                            imageUrl: newsList[index]
                                                ['urlToImage'],
                                            width: size.width * 0.95,
                                            height: size.height * 0.25,
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) =>
                                                Container(
                                              color: Colors.black12,
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                     Container(
                                                       color: Colors.black12,
                                                       child: Icon(Icons.error,color: Colors.red,)),
                                          ),
                                        ),
                                        SizedBox(
                                          height: size.height * 0.01,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Text(
                                            newsList[index]['title'],
                                            style: const TextStyle(
                                                fontSize: 17,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ),
                                        SizedBox(
                                          height: size.height * 0.01,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 3.0,
                                              right: 3.0,
                                              bottom: 3.0),
                                          child: Text(
                                            newsList[index]['description'],
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey.shade500),
                                          ),
                                        )
                                      ]),
                                    ),
                                  );
                          }),
                    ]),
                  );
                }
              })),
    );
  }
}
