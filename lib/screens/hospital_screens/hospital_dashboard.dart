import 'package:caresync/form_response/form_response.dart';
import 'package:caresync/networking/authentication.dart';
import 'package:caresync/screens/dashboard_screens/lab_reports.dart';
import 'package:caresync/screens/dashboard_screens/medication_screens/medication.dart';
import 'package:caresync/screens/hospital_screens/add_category_screen.dart';
import 'package:caresync/screens/hospital_screens/upload_screen.dart';
import 'package:caresync/widgets/dashboard_text_card.dart';
import 'package:caresync/widgets/drawer.dart';
import 'package:caresync/widgets/drawer_for_hospital.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import 'delete_category_screen.dart';

class HospitalDashboard extends StatelessWidget {
  static const String id = "HospitalDashboard";

  const HospitalDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          widthFactor: 2,
          child: Text("Dashboard"),
        ),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      drawer: const HospitalDrawer(),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DashboardCard(
                child: Image.asset('assets/images/hmetrics.png'),
                onTap: () {
                  Navigator.pushNamed(context, UploadScreen.id);
                },
                title: "Upload Lab Report",
              ),
              DashboardCard(
                child: SvgPicture.asset('assets/images/lab.svg'),
                onTap: () {
                  Navigator.pushNamed(context, AddCategoryScreen.id);
                },
                title: "Add Categories",
              ),
              // DashboardCard(
              //   child: Image.asset("assets/images/remove.png"),
              //   onTap: () {
              //     Navigator.pushNamed(context, DeleteCategoryScreen.id);
              //   },
              //   title: "Remove Categories",
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
