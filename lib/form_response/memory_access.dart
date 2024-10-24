import 'dart:convert';
import 'package:alarm/alarm.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MemoryAccess {
  static String getNamesWithSameIds(SharedPreferences prefs, int alarmId) {
    String res = "";
    Map alarms = jsonDecode(prefs.getString("alarms") ?? "{}");
    for (var alarm in alarms.keys) {
      for (var id in alarms[alarm]) {
        if (id == alarmId) {
          res += alarm;
          res += ',';
          break;
        }
      }
    }
    return res;
  }

  static int getAlarmId(SharedPreferences prefs, String currTime) {
    Map times = jsonDecode(prefs.getString("times") ?? "{}");
    for (var time in times.keys) {
      if (time == currTime) {
        return times[time];
      }
    }
    return -1;
  }

  static Future<void> replaceAlarmId(
    SharedPreferences prefs,
    int newId,
    int prevId,
    String currTime,
  ) async {
    Map times = jsonDecode(prefs.getString("times") ?? "{}");
    Map alarms = jsonDecode(prefs.getString("alarms") ?? "{}");
    for (var time in times.keys) {
      if (time == currTime) {
        times[currTime] = newId;
        break;
      }
    }
    for (var alarm in alarms.keys) {
      for (var id in alarms[alarm]) {
        if (id == prevId) {
          alarms[alarm].remove(id);
          alarms[alarm].add(newId);
          break;
        }
      }
    }
    await prefs.setString("times", jsonEncode(times));
    await prefs.setString("alarms", jsonEncode(alarms));
  }

  static Future<void> addAlarmId(
    SharedPreferences prefs,
    int newId,
    String currTime,
  ) async {
    Map times = jsonDecode(prefs.getString("times") ?? "{}");
    times[currTime] = newId;
    await prefs.setString("times", jsonEncode(times));
  }

  static Future<void> addNewAlarm(
    SharedPreferences prefs,
    int newId,
    String alarmName,
  ) async {
    Map alarms = jsonDecode(prefs.getString("alarms") ?? "{}");
    if (alarms.containsKey(alarmName)) {
      alarms[alarmName].add(newId);
    } else {
      alarms[alarmName] = [newId];
    }
    await prefs.setString("alarms", jsonEncode(alarms));
  }

  static int countAlarmIdOccurrences(SharedPreferences prefs, int currId) {
    Map alarms = jsonDecode(prefs.getString("alarms") ?? "{}");
    int count = 0;
    for (var alarm in alarms.keys) {
      for (var id in alarms[alarm]) {
        if (id == currId) {
          count++;
          break;
        }
      }
    }

    return count;
  }

  static List<int> getAlarmIds(SharedPreferences prefs, String alarmName) {
    Map alarms = jsonDecode(prefs.getString("alarms") ?? "{}");
    return alarms[alarmName].cast<int>();
  }

  static Future<bool> deleteAlarm(
      SharedPreferences prefs, int id, String alarmName) async {
    Map times = jsonDecode(prefs.getString("times") ?? "{}");
    Map alarms = jsonDecode(prefs.getString("alarms") ?? "{}");

    bool isSingle = false;
    if (countAlarmIdOccurrences(prefs, id) == 1) {
      for (var time in times.keys) {
        if (times[time] == id) {
          times.remove(time);
          break;
        }
      }
      isSingle = true;
    } else {
      isSingle = false;
    }
    alarms[alarmName].remove(id);
    if (alarms[alarmName].isEmpty) {
      alarms.remove(alarmName);
    }
    await prefs.setString("times", jsonEncode(times));
    await prefs.setString("alarms", jsonEncode(alarms));
    return isSingle;
  }

  static String getTimeFromId(SharedPreferences prefs, int id) {
    Map times = jsonDecode(prefs.getString("times") ?? "{}");
    for (var time in times.keys) {
      if (times[time] == id) {
        return time;
      }
    }
    return "";
  }
}
