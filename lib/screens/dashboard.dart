import 'package:caresync/form_response/form_response.dart';
import 'package:caresync/networking/authentication.dart';
import 'package:caresync/screens/dashboard_screens/lab_reports.dart';
import 'package:caresync/screens/dashboard_screens/medication_screens/medication.dart';
import 'package:caresync/widgets/dashboard_text_card.dart';
import 'package:caresync/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../constants/constants.dart';
import 'dashboard_screens/health_metrics.dart';

class Dashboard extends StatelessWidget {
  static const String id = "Dashboard";

  const Dashboard({super.key});

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
      drawer: const DrawerDash(),
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
                  Navigator.pushNamed(context, HealthMetrics.id);
                },
                title: "Health Metrics",
              ),
              DashboardCard(
                child: SvgPicture.asset('assets/images/lab.svg'),
                onTap: () {
                  Navigator.pushNamed(context, LabReport.id);
                },
                title: "Lab Reports",
              ),
              if (Provider.of<FormResponse>(context, listen: false).pno ==
                  Authentication.currentUser)
                DashboardCard(
                  child: Image.asset(
                    'assets/images/medicine.png',
                  ),
                  onTap: () async {
                    await Authentication.signOut();
                    Navigator.pushNamed(context, MedicationScreen.id);
                  },
                  title: "Medication",
                ),
            ],
          ),
        ),
      ),
    );
  }
}
