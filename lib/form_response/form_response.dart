import 'package:caresync/constants/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class UserProfile {
  String? name;
  String? password;
  String? pNo;
  String? address;
  String? gender;
  String? dob;
  String? parentNumber;
  UserRole role = UserRole.noUser;
  Map userData = {};

  UserProfile(this.userData) {
    name = userData["name"] ?? "";
    password = userData["pass"] ?? "";
    pNo = userData["pNo"] ?? "";
    address = userData["address"] ?? "";
    gender = userData["gender"] ?? "";
    dob = userData["dob"] ?? "";
    parentNumber = userData["parentNumber"] ?? "";
    // switch(userData["role"]){
    //   case "user":
    //     role = UserRole.user;
    //     break;
    //   case "hospital":
    //     role = UserRole.hospital;
    //     break;
    //   case "admin":
    //     role = UserRole.admin;
    //     break;
    //   default:
    //     role = UserRole.noUser;
    //     break;
    // }
    role = userData["role"] == "user" ? UserRole.user : UserRole.hospital;
  }
}

class FormResponse extends ChangeNotifier {
  UserProfile? user;
  String pno = "";
  String currName = "";
}
