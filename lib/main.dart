import 'package:alarm/alarm.dart';
import 'package:caresync/screens/dashboard.dart';
import 'package:caresync/screens/dashboard_screens/health_metrics.dart';
import 'package:caresync/screens/dashboard_screens/lab_reports.dart';
import 'package:caresync/screens/dashboard_screens/medication_screens/medication.dart';
import 'package:caresync/screens/dashboard_screens/members.dart';
import 'package:caresync/screens/hospital_screens/add_category_screen.dart';
import 'package:caresync/screens/hospital_screens/delete_category_screen.dart';
import 'package:caresync/screens/hospital_screens/hospital_dashboard.dart';
import 'package:caresync/screens/hospital_screens/upload_screen.dart';
import 'package:caresync/screens/loading_screen.dart';
import 'package:caresync/screens/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../screens/signup_screen.dart';
import 'firebase_options.dart';
import 'form_response/form_response.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Alarm.init();
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  ).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<FormResponse>(
      create: (BuildContext context) => FormResponse(),
      child: MaterialApp(
        title: 'Care Sync',
        initialRoute: LoadingScreen.id,
        routes: {
          LoadingScreen.id: (context) => const LoadingScreen(),
          LoginScreen.id: (context) => const LoginScreen(),
          SignUpScreen.id: (context) => const SignUpScreen(),
          Dashboard.id: (context) => const Dashboard(),
          HealthMetrics.id: (context) => const HealthMetrics(),
          LabReport.id: (context) => LabReport(),
          UploadScreen.id: (context) => UploadScreen(),
          MembersScreen.id: (context) => const MembersScreen(),
          MedicationScreen.id: (context) => const MedicationScreen(),
          HospitalDashboard.id: (context) => const HospitalDashboard(),
          AddCategoryScreen.id: (context) => const AddCategoryScreen(),
          DeleteCategoryScreen.id: (context) => const DeleteCategoryScreen(),
        },
      ),
    );
  }
}
