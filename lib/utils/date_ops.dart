import 'package:app_of_sales/utils/constants.dart';

String getNormalDate(DateTime dateTime) {
  return "${dateTime.day}$interpunct${dateTime.month}$interpunct${dateTime.year}";
}

String getNormalTime(DateTime dateTime) {
  return "${dateTime.hour}:${dateTime.minute}:${dateTime.second}";
}

String getRoughTime(DateTime dateTime) {
  return "${dateTime.hour}:${dateTime.minute}:${dateTime.second}";
}
