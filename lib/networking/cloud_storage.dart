import 'package:caresync/constants/constants.dart';
import 'package:caresync/networking/authentication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class CloudStorage {
  static final _cloud = FirebaseFirestore.instance;

  static dynamic getUserData(BuildContext context) async {
    try {
      return await _cloud
          .collection("users")
          .doc(Authentication.currentUser)
          .get()
          .then((val) => val.data());
    } catch (e) {
      kSnackBar(e.toString(), context);
    }
  }

  static dynamic getAllUsers(BuildContext context) async {
    try {
      return await _cloud.collection("users").get().then((value) {
        return value.docs;
      });
    } catch (e) {
      kSnackBar(e.toString(), context);
    }
  }

  static dynamic addImageUrl(
      String pno, String url, String filename, BuildContext context) async {
    try {
      await _cloud.collection("users").doc(pno).collection("uploads").add({
        "url": url,
        "filename": filename,
      });
    } catch (e) {
      kSnackBar(e.toString(), context);
      print(e.toString());
    }
  }

  static dynamic getUploads(String pno, BuildContext context) async {
    try {
      return await _cloud
          .collection("users")
          .doc(pno)
          .collection("uploads")
          .get()
          .then((value) {
        return value.docs;
      });
    } catch (e) {
      kSnackBar(e.toString(), context);
    }
  }

  static Future<List> getRelatedUsers() async {
    List users = [];
    await _cloud.collection("users").get().then((val) {
      for (var doc in val.docs) {
        if (doc.id != Authentication.currentUser) {
          if (doc.data()["parentNumber"] == Authentication.currentUser) {
            users.add(doc.data());
          }
        }
      }
    });
    return users;
  }

  static Future<List<String>> getCategories() async {
    List<String> categories = [];
    await _cloud.collection("categories").get().then((val) {
      for (var doc in val.docs) {
        categories.add(doc.data()["category"]);
      }
    });
    return categories;
  }

  static Future<void> addCategory(String category) async {
    List<String> categories = [];
    await _cloud.collection("categories").add(
      {
        "category": category,
      },
    );
  }

  static Future<bool> removeCategory(
      String category, BuildContext context) async {
    try {
      await _cloud.collection("categories").doc(category).delete();
      return true;
    } catch (e) {
      kSnackBar(e.toString(), context);
    }
    return false;
  }
}
