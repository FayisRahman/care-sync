import 'package:caresync/constants/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../constants/models.dart';

class FormResponse extends ChangeNotifier {
  UserProfile? user;
  String pno = "";
  String currName = "";
}
