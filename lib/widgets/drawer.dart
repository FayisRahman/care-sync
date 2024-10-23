import 'package:caresync/form_response/form_response.dart';
import 'package:caresync/networking/authentication.dart';
import 'package:caresync/screens/dashboard.dart';
import 'package:caresync/screens/dashboard_screens/members.dart';
import 'package:caresync/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DrawerDash extends StatelessWidget {
  const DrawerDash({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            curve: Curves.bounceInOut,
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Provider.of<FormResponse>(context, listen: false).pno =
                  Authentication.currentUser;
              Navigator.pushNamedAndRemoveUntil(
                  context, Dashboard.id, (route) => false);
            },
          ),
          ListTile(
            leading: const Icon(Icons.family_restroom),
            title: const Text('Family DashBoard'),
            onTap: () async {
              await Navigator.pushNamed(context, MembersScreen.id);
              FormResponse formResponse =
                  Provider.of<FormResponse>(context, listen: false);
              formResponse.pno = Authentication.currentUser;
              formResponse.currName = formResponse.user!.name!;
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.workspace_premium),
            title: const Text('Get Premium'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, LoginScreen.id, (route) => false);
            },
          ),
        ],
      ),
    );
  }
}
