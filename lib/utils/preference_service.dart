import 'package:shared_preferences/shared_preferences.dart';

Future<bool> setStatus(bool status) async {
  final pref = await SharedPreferences.getInstance();
  return pref.setBool('status', status);
}

Future<bool> getStatus() async {
  final pref = await SharedPreferences.getInstance();
  return pref.getBool('status') ?? false;
}