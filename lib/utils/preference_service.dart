import 'package:shared_preferences/shared_preferences.dart';

Future<bool> setUnit(bool status) async {
  final pref = await SharedPreferences.getInstance();
  return pref.setBool('status', status);
}

Future<bool> getUnit() async {
  final pref = await SharedPreferences.getInstance();
  return pref.getBool('status') ?? false;
}

Future<bool> setTimeFormat(bool format) async {
  final pref = await SharedPreferences.getInstance();
  return pref.setBool('format', format);
}

Future<bool> getTimeFormat() async {
  final pref = await SharedPreferences.getInstance();
  return pref.getBool('format') ?? false;
}