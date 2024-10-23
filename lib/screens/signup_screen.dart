import 'dart:convert';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:caresync/constants/constants.dart';
import 'package:caresync/networking/authentication.dart';
import 'package:caresync/screens/dashboard.dart';
import 'package:caresync/screens/hospital_screens/upload_screen.dart';
import 'package:caresync/widgets/drop_down_menu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../form_response/form_response.dart';
import '../widgets/raised_button.dart';
import '../widgets/text_field.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  static const String id = "SignUpScreen";

  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String name = "",
      address = "",
      dob = "",
      bloodGroup = "",
      age = "",
      gender = "",
      phoneNumber = "";
  TextEditingController dobController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  bool related = false;
  String parentNumber = "";
  String pass = "";

  Future<void> signUp() async {
    Map<String, String> credentials = {
      "name": name,
      "address": address,
      "dob": dob,
      "bloodGroup": bloodGroup,
      "age": age,
      "pNo": phoneNumber,
      "password": pass,
      "related": related.toString(),
      "parentNumber": parentNumber
    };

    dynamic result = await Authentication.signUp(credentials, context);
    UserRole role = await Authentication.findUserRole();
    if (result != null) {
      Provider.of<FormResponse>(context, listen: false).pno =
          credentials["pNo"]!;
      if (role == UserRole.user) {
        Navigator.pushReplacementNamed(context, Dashboard.id);
      } else {
        Navigator.pushReplacementNamed(context, UploadScreen.id);
      }
    } else {
      kSnackBar("There was an error creating your account", context);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Sign up to ",
                                style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontFamily: "Roboto",
                                    fontSize: 24),
                              ),
                              Text(
                                "Care-Sync",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "LilyScript",
                                ),
                              )
                            ],
                          ),
                          Text(
                            "Create your Account",
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        LoginField(
                          title: "Name",
                          onChanged: (String text) {
                            name = text;
                          },
                          errorText: "Name",
                        ),
                        LoginField(
                          title: "Address",
                          onChanged: (String text) {
                            address = text;
                          },
                          errorText: "email address",
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: LoginField(
                                readOnly: true,
                                controller: ageController,
                                title: "Age",
                                onChanged: (String text) {
                                  age = text;
                                },
                                errorText: "Age",
                                child: null,
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: LoginField(
                                  readOnly: true,
                                  controller: dobController,
                                  title: "DOB",
                                  onChanged: (String text) {
                                    dob = text;
                                  },
                                  errorText: "DOB",
                                  onDateChanged: () async {
                                    List<DateTime?>? results =
                                        await showCalendarDatePicker2Dialog(
                                      context: context,
                                      config:
                                          CalendarDatePicker2WithActionButtonsConfig(),
                                      dialogSize: const Size(325, 400),
                                      value: [],
                                      borderRadius: BorderRadius.circular(15),
                                    );
                                    setState(() {
                                      dob =
                                          "${results!.first?.day}/${results.first?.month}/${results.first?.year}";
                                      dobController.text = dob;
                                      age = (DateTime.now()
                                                  .difference(results.first!)
                                                  .inDays ~/
                                              365)
                                          .toString();
                                      ageController.text = age;
                                    });
                                  }),
                            ),
                          ],
                        ),
                        LoginField(
                          title: "Gender",
                          readOnly: true,
                          onChanged: (_) {},
                          controller: genderController,
                          errorText: "gender",
                          child: DropDownIconButton(
                            categories: const ["Male", "Female"],
                            onSelected: (String val) {
                              setState(() {
                                gender = val;
                                genderController.text = gender;
                              });
                            },
                          ),
                        ),
                        LoginField(
                          title: "Blood Group",
                          onChanged: (String text) {
                            bloodGroup = text;
                          },
                          needHiding: false,
                          errorText: "password",
                        ),
                        LoginField(
                          title: "Phone Number",
                          onChanged: (String text) {
                            phoneNumber = text;
                          },
                          errorText: "phone number",
                        ),
                        LoginField(
                          needHiding: true,
                          title: "Password",
                          onChanged: (String text) {
                            pass = text;
                          },
                          errorText: "password",
                        ),
                        Column(
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                  value: related,
                                  onChanged: (val) {
                                    setState(() {
                                      related = val!;
                                    });
                                  },
                                ),
                                const Flexible(
                                  child: Text(
                                    "Do you have any user related to you ?",
                                  ),
                                ),
                              ],
                            ),
                            if (related)
                              LoginField(
                                  title: "Parent Number",
                                  onChanged: (val) {
                                    parentNumber = val;
                                  },
                                  errorText: "parent number")
                          ],
                        )
                      ],
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 20),
                          child: RaisedButton(
                              child: const Text(
                                "Sign Up",
                                style: TextStyle(
                                    fontFamily: "Roboto",
                                    fontStyle: FontStyle.italic),
                              ),
                              onTap: () async {
                                if (name == "" ||
                                    age == "" ||
                                    gender == "" ||
                                    phoneNumber == "" ||
                                    bloodGroup == "") {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content:
                                        Text("One of the entry isnt filled"),
                                  ));
                                } else {
                                  await signUp();
                                }
                              }),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Already a member? ",
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.grey),
                              ),
                              InkWell(
                                onTap: () async {},
                                child: const Text(
                                  "Sign in",
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    // Image.asset("assets/images/vibgreen_logo.png"),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
