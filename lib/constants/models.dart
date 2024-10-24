import 'constants.dart';

class UserProfile {
  String? name;
  String? password;
  String? pNo;
  String? address;
  String? gender;
  String? dob;
  int? age;
  String? parentNumber;
  UserRole role = UserRole.noUser;

  UserProfile(userData) {
    name = userData["name"] ?? "";
    password = userData["pass"] ?? "";
    pNo = userData["pNo"] ?? "";
    address = userData["address"] ?? "";
    gender = userData["gender"] ?? "";
    dob = userData["dob"] ?? "";
    age = userData["age"] ?? 18;
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

class Category {
  String? name;
  double? minVal;
  double? maxVal;
  String? tipForHighVal;
  String? tipForLowVal;

  Category(categoryData) {
    name = categoryData["category"];
    maxVal = double.parse(categoryData["max"]);
    minVal = double.parse(categoryData["min"]);
    tipForHighVal = categoryData["tipHigh"];
    tipForLowVal = categoryData["tipLow"];
  }
}
