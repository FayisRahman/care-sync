import 'dart:async';
import 'dart:convert';
import 'package:alarm/alarm.dart';
import 'package:caresync/constants/constants.dart';
import 'package:caresync/form_response/memory_access.dart';
import 'package:caresync/screens/dashboard_screens/medication_screens/add_alarm.dart';
import 'package:caresync/screens/dashboard_screens/medication_screens/ring_alarm.dart';
import 'package:caresync/widgets/drawer.dart';
import 'package:caresync/widgets/medication_card.dart';
import 'package:caresync/widgets/medication_time.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../networking/alarm_permission.dart';

class MedicationScreen extends StatefulWidget {
  static const String id = "MedicationScreen";

  const MedicationScreen({super.key});

  @override
  State<MedicationScreen> createState() => _MedicationScreenState();
}

class _MedicationScreenState extends State<MedicationScreen> {
  String pno = "";

  List<AlarmSettings> alarms = [];
  bool isFirst = true;

  static StreamSubscription<AlarmSettings>? ringSubscription;
  static StreamSubscription<int>? updateSubscription;

  @override
  void initState() {
    super.initState();
    initialise();
  }

  void loadAlarms() {
    setState(() {
      alarms = Alarm.getAlarms();
      alarms.sort((a, b) => a.dateTime.isBefore(b.dateTime) ? 0 : 1);
      if (isFirst) {
        createCards();
        isFirst = false;
      }
    });
  }

  Future<void> navigateToRingScreen(AlarmSettings alarmSettings) async {
    final DateTime now = DateTime.now();
    int alarmId = DateTime.now().millisecondsSinceEpoch % 100000000;
    await MemoryAccess.replaceAlarmId(
        _prefs!, alarmId, alarmSettings.id, kGetTime(alarmSettings.dateTime));
    await Alarm.set(
      alarmSettings: alarmSettings.copyWith(
        id: alarmId,
        dateTime: DateTime(
          now.year,
          now.month,
          now.day,
          now.hour,
          now.minute,
        ).add(const Duration(days: 1)),
      ),
    );
    await Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) => AlarmRingScreen(alarmSettings: alarmSettings),
      ),
    );
    loadAlarms();
  }

  Future<void> navigateToAlarmScreen(AlarmSettings? settings) async {
    final res = await showModalBottomSheet<bool?>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.75,
          child: AddMedicationRemainder(alarmSettings: settings),
        );
      },
    );

    if (res != null && res == true) loadAlarms();
  }

  // Future<void> launchReadmeUrl() async {
  //   final url = Uri.parse('https://pub.dev/packages/alarm/versions/$version');
  //   await launchUrl(url);
  // }
  List<MedicationCard> cards = [];
  SharedPreferences? _prefs;

  Future<void> getPref() async {
    _prefs = await SharedPreferences.getInstance();
    // await _prefs!.setString("alarms", "{}");
    // await _prefs!.setString("times", "{}");
  }

  Future<void> initialise() async {
    AlarmPermissions.checkNotificationPermission();
    await getPref();
    if (Alarm.android) {
      AlarmPermissions.checkAndroidScheduleExactAlarmPermission();
    }
    loadAlarms();

    ringSubscription ??= Alarm.ringStream.stream.listen(navigateToRingScreen);
    updateSubscription ??= Alarm.updateStream.stream.listen((_) {});
    createCards();
  }

  void createCards() {
    cards = [];
    Map alarms = jsonDecode(_prefs?.getString("alarms") ?? "{}");
    Map times = jsonDecode(_prefs?.getString("times") ?? "{}");
    print(times);
    print(alarms);
    DateTime minTime;
    final now = DateTime.now();
    for (var alarm in alarms.keys) {
      List<MedicationTime> medTime = [];
      minTime = DateTime(3000);
      String nextDosage = "";
      for (var id in alarms[alarm]) {
        if (Alarm.getAlarm(id)!.dateTime.isAfter(now) &&
            Alarm.getAlarm(id)!.dateTime.isBefore(minTime)) {
          minTime = Alarm.getAlarm(id)!.dateTime;
        }
        medTime.add(MedicationTime(
          hour: Alarm.getAlarm(id)!.dateTime.hour,
          minute: Alarm.getAlarm(id)!.dateTime.minute,
        ));
      }
      nextDosage = kGetFormattedTime(minTime, context);
      print(nextDosage);
      cards.add(MedicationCard(
          medicationName: alarm,
          noOfTimes: medTime.length,
          nextDosage: nextDosage,
          time: medTime));
    }
    setState(() {
      cards;
    });
  }

  void deleteAll() async {
    await _prefs!.setString("alarms", '{}');
    await _prefs!.setString("times", '{}');
    Alarm.stopAll();
  }

  @override
  void dispose() {
    ringSubscription?.cancel();
    updateSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          widthFactor: 2,
          child: Text("Medication"),
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
      body: SafeArea(
        child: alarms.isNotEmpty
            ? SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Column(
                    children: cards,
                  ),
                ),
              )
            : Center(
                child: Text(
                  'No alarms set',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await navigateToAlarmScreen(null);
          createCards();
          // deleteAll();
        },
        child: const Icon(Icons.add, size: 33),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
