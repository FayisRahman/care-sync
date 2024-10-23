import 'package:caresync/constants/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class Authentication {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _cloud = FirebaseFirestore.instance;

  static Future<dynamic> signUp(
      Map<String, String> credentials, BuildContext context) async {
    try {
      return await _auth
          .createUserWithEmailAndPassword(
              email: "${credentials["pNo"]!}@gmail.com",
              password: credentials["password"]!)
          .then((value) async {
        await _cloud.collection("users").doc(credentials["pNo"]).set({
          "name": credentials["name"],
          "pNo": credentials["pNo"],
          "password": credentials["password"],
          "parentNumber": credentials["parentNumber"],
          "role": "user",
        });
        return value;
      });
    } catch (e) {
      kSnackBar(e.toString(), context);
      return null;
    }
  }

  static dynamic signIn(
      String pNo, String password, BuildContext context) async {
    try {
      return await _auth.signInWithEmailAndPassword(
          email: "$pNo@gmail.com", password: password);
    } catch (e) {
      kSnackBar(e.toString(), context);
      return null;
    }
  }

  static dynamic checkLogged() {
    if (_auth.currentUser != null) {
      return _auth.currentUser;
    } else {
      return null;
    }
  }

  static Future<UserRole> findUserRole() async {
    UserRole role = UserRole.noUser;
    await _cloud.collection("users").doc(currentUser).get().then((val) {
      print(val.id);
      print(val.exists);
      if (val.exists) {
        role = UserRole.user;
      }
    });
    if (role != UserRole.noUser) return role;
    await _cloud.collection("hospitalUsers").doc(currentUser).get().then((val) {
      if (val.exists) role = UserRole.hospital;
    });
    return role;
  }

  static Future<void> signOut() async {
    await _auth.signOut();
  }

  static get currentUser => _auth.currentUser!.email!.split("@")[0];
}
