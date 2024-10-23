import 'dart:io';

import 'package:alarm/alarm.dart';
import 'package:caresync/constants/constants.dart';
import 'package:caresync/form_response/memory_access.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddMedicationRemainder extends StatefulWidget {
  const AddMedicationRemainder({super.key, this.alarmSettings});

  final AlarmSettings? alarmSettings;

  @override
  State<AddMedicationRemainder> createState() => _AddMedicationRemainderState();
}

class _AddMedicationRemainderState extends State<AddMedicationRemainder> {
  bool loading = false;

  late bool creating;
  late DateTime selectedDateTime;
  late bool loopAudio;
  late bool vibrate;
  late double? volume;
  late String assetAudio;
  late int noOfTimes;
  SharedPreferences? _prefs;
  final TextEditingController _controller = TextEditingController();
  late String alarmName;
  String newAlarmName = "";

  void getPref() async {
    _prefs = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    super.initState();
    creating = widget.alarmSettings == null;
    getPref();
    if (creating) {
      selectedDateTime = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        7,
        0,
      );
      selectedDateTime = selectedDateTime.copyWith(second: 0, millisecond: 0);
      loopAudio = true;
      vibrate = true;
      volume = null;
      assetAudio = 'assets/sounds/vintage_clock.mp3';
      noOfTimes = 3;
    } else {
      selectedDateTime = widget.alarmSettings!.dateTime;
      loopAudio = widget.alarmSettings!.loopAudio;
      vibrate = widget.alarmSettings!.vibrate;
      volume = widget.alarmSettings!.volume;
      assetAudio = widget.alarmSettings!.assetAudioPath;
      // _prefs.get("")
    }
  }

  String getDay() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final difference = selectedDateTime.difference(today).inDays;

    switch (difference) {
      case 0:
        return 'Today';
      case 1:
        return 'Tomorrow';
      case 2:
        return 'After tomorrow';
      default:
        return 'In $difference days';
    }
  }

  Future<void> pickTime() async {
    final res = await showTimePicker(
      initialTime: TimeOfDay.fromDateTime(selectedDateTime),
      context: context,
    );

    if (res != null) {
      setState(() {
        final now = DateTime.now();
        selectedDateTime = now.copyWith(
          hour: res.hour,
          minute: res.minute,
          second: 0,
          millisecond: 0,
          microsecond: 0,
        );
        // if (selectedDateTime.isBefore(now)) {
        //   selectedDateTime = selectedDateTime.add(const Duration(days: 1));
        // }
      });
    }
  }

  AlarmSettings buildAlarmSettings() {
    final id = creating
        ? DateTime.now().millisecondsSinceEpoch % 10000 + 1
        : widget.alarmSettings!.id;

    final alarmSettings = AlarmSettings(
      id: id,
      dateTime: selectedDateTime,
      loopAudio: loopAudio,
      vibrate: vibrate,
      volume: volume,
      assetAudioPath: assetAudio,
      warningNotificationOnKill: Platform.isIOS,
      notificationSettings: NotificationSettings(
        title: 'Medicine Intake Reminder',
        body: alarmName,
        icon: 'ic_launcher',
        stopButton: "Stop"
      ),
    );
    return alarmSettings;
  }

  Future<void> addNewAlarm(int id, String time) async {
    int alarmId = MemoryAccess.getAlarmId(_prefs!, time);
    if (alarmId != -1) {
      await MemoryAccess.replaceAlarmId(_prefs!, id, alarmId, time);
      await Alarm.stop(alarmId);
      newAlarmName = MemoryAccess.getNamesWithSameIds(_prefs!, id);
    } else {
      await MemoryAccess.addAlarmId(_prefs!, id, time);
    }
    await MemoryAccess.addNewAlarm(_prefs!, id, alarmName);
    newAlarmName += ",$alarmName";
  }

  Future<bool> createAlarmSettings() async {
    int timeGap = DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          23,
          59,
        ).difference(selectedDateTime).inSeconds ~/
        noOfTimes;
    print("timegap is: $timeGap");
    int id = DateTime.now().millisecondsSinceEpoch % 100000000;
    for (int i = 0; i < noOfTimes; i++) {
      id++;
      DateTime selTime =
          kRoundToNearest(kAddTime(selectedDateTime, timeGap * i));
      String time = kGetTime(selTime);
      print(time);
      await addNewAlarm(id, time);
      final alarmSettings = AlarmSettings(
        id: id,
        dateTime: selTime,
        loopAudio: loopAudio,
        vibrate: vibrate,
        volume: volume,
        assetAudioPath: assetAudio,
        warningNotificationOnKill: Platform.isIOS,
        notificationSettings: NotificationSettings(
          title: 'Medicine Intake Reminder',
          body: newAlarmName,
          icon: 'ic_launcher',
          stopButton: "Stop",
        ),
      );
      Alarm.set(alarmSettings: alarmSettings);
    }
    return true;
  }

  void saveAlarm() {
    if (loading) return;
    setState(() => loading = true);
    createAlarmSettings().then((res) {
      if (res && mounted) Navigator.pop(context, true);
      setState(() => loading = false);
    });
  }

  String removeWord(String word, String remove) {
    List<String> res = word.split(",");
    for (String word in res) {
      if (word == remove) {
        res.remove(word);
        break;
      }
    }
    return res.join(",");
  }

  Future<void> deleteAlarm() async {
    List<int> ids = MemoryAccess.getAlarmIds(_prefs!, alarmName);
    for (int id in ids) {
      if (await MemoryAccess.deleteAlarm(_prefs!, id, alarmName)) {
        Alarm.stop(id);
      } else {
        NotificationSettings not = Alarm.getAlarm(id)!.notificationSettings;
        String body = removeWord(not.body, alarmName);
        Alarm.set(
            alarmSettings: Alarm.getAlarm(id)!.copyWith(
          notificationSettings: not.copyWith(body: body),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: creating
                ? MainAxisAlignment.spaceBetween
                : MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(
                  'Cancel',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(color: Colors.blueAccent),
                ),
              ),
              if (creating)
                TextButton(
                  onPressed: saveAlarm,
                  child: loading
                      ? const CircularProgressIndicator()
                      : Text(
                          'Save',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(color: Colors.blueAccent),
                        ),
                ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 2,
                child: Text(
                  "Alarm Name: ",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Flexible(
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onChanged: (String val) {
                    alarmName = val;
                  },
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 2,
                child: Text(
                  "How many per Day?",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Flexible(
                child: TextField(
                  controller: _controller,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onChanged: (String val) {
                    setState(() {
                      if (val.isEmpty) {
                        noOfTimes = 0;
                      } else {
                        noOfTimes = int.parse(val);
                      }
                    });
                  },
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Medication starts from: ",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              TextButton(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  backgroundColor: Colors.grey[300],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: pickTime,
                child: Text(
                  TimeOfDay.fromDateTime(selectedDateTime).format(context),
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Loop alarm audio',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Switch(
                value: loopAudio,
                onChanged: (value) => setState(() => loopAudio = value),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Vibrate',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Switch(
                value: vibrate,
                onChanged: (value) => setState(() => vibrate = value),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Sound',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              DropdownButton(
                value: assetAudio,
                items: const [
                  DropdownMenuItem<String>(
                    value: "assets/sounds/beep_alarm.mp3",
                    child: Text('Beep'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/sounds/generic_alarm.mp3',
                    child: Text('Generic'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/sounds/vintage_clock.mp3',
                    child: Text('Vintage'),
                  ),
                ],
                onChanged: (value) => setState(() => assetAudio = value!),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Custom volume',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Switch(
                value: volume != null,
                onChanged: (value) =>
                    setState(() => volume = value ? 0.5 : null),
              ),
            ],
          ),
          SizedBox(
            height: 30,
            child: volume != null
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        volume! > 0.7
                            ? Icons.volume_up_rounded
                            : volume! > 0.1
                                ? Icons.volume_down_rounded
                                : Icons.volume_mute_rounded,
                      ),
                      Expanded(
                        child: Slider(
                          value: volume!,
                          onChanged: (value) {
                            setState(() => volume = value);
                          },
                        ),
                      ),
                    ],
                  )
                : const SizedBox(),
          ),
          if (!creating)
            TextButton(
              onPressed: deleteAlarm,
              child: Text(
                'Delete Alarm',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: Colors.red),
              ),
            ),
          const SizedBox(),
        ],
      ),
    );
  }
}
