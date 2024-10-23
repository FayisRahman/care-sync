import 'package:caresync/form_response/form_response.dart';
import 'package:caresync/networking/authentication.dart';
import 'package:caresync/screens/dashboard.dart';
import 'package:caresync/screens/hospital_screens/hospital_dashboard.dart';
import 'package:caresync/screens/hospital_screens/upload_screen.dart';
import 'package:caresync/screens/signup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/constants.dart';
import '../networking/cloud_storage.dart';
import '../widgets/raised_button.dart';
import '../widgets/text_field.dart';

class LoginScreen extends StatefulWidget {
  static const String id = "LoginScreen";

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String pno = "", pass = "";
  bool isLogging = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 25),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: SizedBox(
              // height: MediaQuery.of(context).size.height,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const SizedBox(),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Sign in to ",
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
                            "Enter your details to Sign In",
                          ),
                          SizedBox(
                            height: 35,
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        LoginField(
                          title: "Phone No.",
                          onChanged: (String text) {
                            pno = text;
                          },
                          needHiding: false,
                          isError: false,
                          errorText: "Phone Number",
                        ),
                        LoginField(
                          title: "Password",
                          onChanged: (String text) {
                            pass = text;
                          },
                          needHiding: true,
                          isError: false,
                          errorText: "password",
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "Forgot Password",
                                style: kTextStyleUnderline,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 20),
                          child: RaisedButton(
                            onTap: () async {
                              setState(() {
                                isLogging = true;
                              });
                              dynamic user = await Authentication.signIn(
                                  pno, pass, context);
                              UserRole role =
                                  await Authentication.findUserRole();

                              if (user != null) {
                                Provider.of<FormResponse>(context,
                                        listen: false)
                                    .pno = pno;
                                if (role == UserRole.user) {
                                  UserProfile userData = UserProfile(
                                      await CloudStorage.getUserData(context));
                                  Provider.of<FormResponse>(context,
                                          listen: false)
                                      .user = userData;
                                  Navigator.pushReplacementNamed(
                                      context, Dashboard.id);
                                } else if (role == UserRole.hospital) {
                                  Navigator.pushReplacementNamed(
                                      context, HospitalDashboard.id);
                                }
                              } else {
                                kSnackBar(
                                    "Incorrect number or password", context);
                              }
                              setState(() {
                                isLogging = false;
                              });
                            },
                            child: isLogging
                                ? SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 3,
                                      color: Colors.grey,
                                    ),
                                  )
                                : const Text(
                                    "Sign In",
                                    style: TextStyle(
                                        fontFamily: "Roboto",
                                        fontStyle: FontStyle.italic),
                                  ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Don't have an account? ",
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.grey,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.pushReplacementNamed(
                                      context, SignUpScreen.id);
                                },
                                child: const Text(
                                  "Sign Up",
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
                    // const Image.asset("assets/images/vibgreen_logo.png"),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
