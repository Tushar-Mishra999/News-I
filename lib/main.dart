
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:red_hat_up/routes.dart';
import 'package:red_hat_up/screens/bookmark_screen.dart';
import 'package:red_hat_up/screens/login_screen.dart';
import 'package:red_hat_up/screens/news_screen.dart';
import 'package:red_hat_up/screens/registration.dart';
import 'package:red_hat_up/screens/welcome_screen.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isIOS) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyBp6M_sNdQgvj8OqVWNIM_AJkc29wUqM80",
            appId: "1:371115345858:ios:4c5ab960f28bae9c05f85b",
            messagingSenderId: "371115345858",
            projectId: "news-i-56287"));
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RedHatUp',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: AppRoutes.homeScreen,
      routes:{
        AppRoutes.homeScreen: (context) => WelcomeScreen(),
        AppRoutes.loginScreen: (context) => LoginScreen(),
        AppRoutes.registrationScreen: (context) => const RegistrationScreen(),
        AppRoutes.newsScreen:(context)=> const NewsScreen(),
        AppRoutes.bookmarkScreen:(context)=>const BookmarkScreen(),
      }
    );
  }
}


