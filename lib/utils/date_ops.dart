import 'package:app_of_sales/utils/constants.dart';
import 'package:intl/intl.dart';

String getNormalDate(DateTime dateTime) {
  return "${dateTime.day}$interpunct${dateTime.month}$interpunct${dateTime.year}";
}

String getNormalTime(DateTime dateTime) {
  return "${dateTime.hour}:${dateTime.minute}:${dateTime.second}";
}

String getRoughTime(DateTime dateTime) {
  return "${dateTime.hour}:${dateTime.minute}:${dateTime.second}";
}

DateTime toDateTime(String date, String time) {
  String dateFormat = 'dd${interpunct}MM${interpunct}yyyy';
  String timeFormat = 'HH:mm:ss';
  String formattedDateTimeString = '$date $time';
  DateTime dateTime =
      DateFormat('$dateFormat $timeFormat').parse(formattedDateTimeString);
  return dateTime;
}
