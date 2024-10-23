import 'package:caresync/form_response/form_response.dart';
import 'package:caresync/networking/authentication.dart';
import 'package:caresync/networking/cloud_storage.dart';
import 'package:caresync/screens/dashboard.dart';
import 'package:caresync/screens/dashboard_screens/lab_reports.dart';
import 'package:caresync/widgets/dashboard_text_card.dart';
import 'package:caresync/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class MembersScreen extends StatefulWidget {
  static const String id = "MembersScreen";

  const MembersScreen({super.key});

  @override
  State<MembersScreen> createState() => _MembersScreenState();
}

class _MembersScreenState extends State<MembersScreen> {
  String pno = "";

  List<DashboardCard> cards = [];

  void createCards() async {
    List users = await CloudStorage.getRelatedUsers();
    for (var user in users) {
      cards.add(
        DashboardCard(
          onTap: () {
            Provider.of<FormResponse>(context, listen: false).pno = user["pNo"];
            Provider.of<FormResponse>(context, listen: false).currName =
                user["name"];
            Navigator.pushNamed(context, Dashboard.id);
          },
          title: user["name"],
          child: Image.asset("assets/images/dp.png"),
        ),
      );
    }
    setState(() {
      cards;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    createCards();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          widthFactor: 2,
          child: Text("Family Members"),
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
            children: cards,
          ),
        ),
      ),
    );
  }
}
