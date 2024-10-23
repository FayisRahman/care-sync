import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum UserRole { user, hospital, admin, noUser }

void kSnackBar(String text, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
    ),
  );
  print(text);
}

TextStyle kGreySmallTextStyle = const TextStyle(
  fontWeight: FontWeight.bold,
  color: Colors.grey,
);

TextStyle kRegularPoppinsTextStyle =
    const TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.w600);

TextStyle kEndgameFont = const TextStyle(
  color: Color(0xff65716c),
  fontFamily: "Accura",
);
TextStyle kHistoryTextSmall =
    const TextStyle(fontWeight: FontWeight.w600, fontFamily: "Accura");
Color kTextColorBlue = const Color(0xff586c9d);

TextStyle kTextStyle = const TextStyle(
    fontWeight: FontWeight.w800, fontFamily: "Roboto", fontSize: 18);
TextStyle kTextStyle24 = const TextStyle(
    fontWeight: FontWeight.w800, fontFamily: "Roboto", fontSize: 24);
TextStyle kTextStyleItalic = const TextStyle(
    fontWeight: FontWeight.w800,
    fontFamily: "Roboto",
    fontSize: 18,
    fontStyle: FontStyle.italic);

TextStyle kTextStyleUnderline = const TextStyle(
  shadows: [Shadow(color: Colors.grey, offset: Offset(0, -2))],
  color: Colors.transparent,
  fontWeight: FontWeight.w700,
  decoration: TextDecoration.underline,
);

TextStyle kTextStyleHead = const TextStyle(
    fontWeight: FontWeight.w700,
    fontFamily: "Poppins",
    fontSize: 14,
    color: Colors.white);

TextStyle kDisplayCardStringTextStyle = const TextStyle(
    fontWeight: FontWeight.w700,
    color: Color(0xff586c9d),
    fontFamily: "Roboto",
    fontSize: 13);

String kSetClock(int timeTaken) {
  int hour = timeTaken ~/ 60;
  int minutes = timeTaken - hour * 60;
  String sMin = minutes.toString();
  String sHour = hour.toString();
  if (sMin.length == 1) {
    sMin = '0$sMin';
  }
  if (sHour.length == 1) {
    sHour = '0$sHour';
  }
  return "$sHour:$sMin";
}

Future<void> kHapticFeedBack(int mode) async {
  if (mode == 1) {
    await HapticFeedback.lightImpact();
  } else if (mode == 2) {
    await HapticFeedback.mediumImpact();
  } else if (mode == 3) {
    await HapticFeedback.heavyImpact();
  }
}

BoxDecoration kButtonDecoration = BoxDecoration(
  border: Border.all(color: const Color(0xffd2d2d2), width: 1.9),
  borderRadius: BorderRadius.circular(10),
  color: Colors.white,
  boxShadow: [
    BoxShadow(
      color: kShadowGrey,
      spreadRadius: 0,
      blurRadius: 0,
      offset: const Offset(0, 5), // shadow direction: bottom right
    ),
  ],
);

TextStyle kPoppinsBold = const TextStyle(
  fontFamily: "Poppins",
  fontWeight: FontWeight.bold,
);

Color kShadowGrey = const Color(0xffd2d2d2);

Color kThemeBlue = const Color(0xff586C9D);

Color kThemeDarkBlue = const Color(0xff0F2552);

TextStyle kCalendarTextStyle = TextStyle(
  color: kThemeDarkBlue,
  fontFamily: "Poppins",
);

String kGetDate(DateTime date) {
  return "${date.day < 9 ? "0${date.day}" : date.day}-${date.month < 9 ? "0${date.month}" : date.month}-${date.year}";
}

DateTime kStartDate = DateTime(2024, 7, 8);

int kDaysBetween(DateTime to) {
  DateTime from = DateTime(kStartDate.year, kStartDate.month, kStartDate.day);
  to = DateTime(to.year, to.month, to.day);
  return (to.difference(from).inHours / 24).round();
}

DateTime convertToDate(String date) {
  List<String> dates = date.split("-");
  return DateTime(
      int.parse(dates[2]), int.parse(dates[1]), int.parse(dates[0]));
}

DateTime kRoundToNearest(DateTime time) {
  DateTime res = DateTime.now();
  if (time.minute < 15) {
    res = DateTime(time.year, time.month, time.day, time.hour, 0);
  } else if (time.minute > 15 && time.minute < 45 || time.hour + 1 == 24) {
    res = DateTime(time.year, time.month, time.day, time.hour, 30);
  } else {
    res = DateTime(time.year, time.month, time.day, time.hour + 1, 0);
  }

  return res;
}

String kGetTime(DateTime time) {
  return "${time.hour < 9 ? "0${time.hour}" : time.hour}:${time.minute < 9 ? "0${time.minute}" : time.minute}";
}

DateTime kAddTime(DateTime time, int seconds) {
  DateTime newTime = time.add(Duration(seconds: seconds));
  if (newTime.difference(DateTime.now()).isNegative) {
    return DateTime(
            time.year, time.month, time.day, newTime.hour, newTime.minute)
        .add(const Duration(days: 1));
  }
  return newTime;
}

int kDistanceBetweenInSeconds(DateTime time1, DateTime time2) {
  return time1.difference(time2).inSeconds;
}

String kGetFormattedTime(DateTime time, BuildContext context) {
  String res = "";
  String m = "";
  DateTime newTime = time;
  if (time.hour >= 12) {
    m = "PM";
    if (time.hour > 12) newTime = time.subtract(const Duration(hours: 12));
  } else {
    m = "AM";
  }
  return "${kGetTime(newTime)} $m";
}
