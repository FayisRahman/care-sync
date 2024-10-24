import 'dart:collection';

import 'package:caresync/networking/authentication.dart';
import 'package:caresync/networking/cloud_storage.dart';
import 'package:caresync/screens/dashboard.dart';
import 'package:caresync/screens/hospital_screens/hospital_dashboard.dart';
import 'package:caresync/screens/hospital_screens/upload_screen.dart';
import 'package:caresync/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:caresync/form_response/form_response.dart';
import 'package:provider/provider.dart';

import '../constants/models.dart';

class LoadingScreen extends StatefulWidget {
  static const String id = "LoadingScreen";

  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;

  HashSet<String> hashSet = HashSet<String>();

  Future<void> initialise() async {
    hashSet.addAll({
      "a",
      "b",
      "c",
      "d",
      "e",
      "f",
      "g",
      "h",
      "i",
      "j",
      "k",
      "l",
      "m",
      "n",
      "o",
      "p",
      "q",
      "r",
      "s",
      "t",
      "u",
      "v",
      "w",
      "x",
      "y",
      "z",
    });
    User? res = Authentication.checkLogged();
    if (res != null) {
      if (res.email!
          .split("@")[0]
          .characters
          .any((element) => hashSet.contains(element))) {
        Provider.of<FormResponse>(context, listen: false).pno =
            res.email!.split("@")[0];
        Navigator.pushReplacementNamed(context, HospitalDashboard.id);
        return;
      } else {
        dynamic map = await CloudStorage.getUserData(context);
        UserProfile userData = UserProfile(map);
        Provider.of<FormResponse>(context, listen: false).user = userData;
        Provider.of<FormResponse>(context, listen: false).pno = userData.pNo!;
        Navigator.pushReplacementNamed(context, Dashboard.id);
      }
    } else {
      Navigator.pushReplacementNamed(context, LoginScreen.id);
    }
  }

  @override
  void initState() {
    super.initState();
    initialise();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 75),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/care.png",
                scale: 1.5,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 50),
                child: LinearProgressIndicator(
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
