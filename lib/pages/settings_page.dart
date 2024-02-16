import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/providers/weather_provider.dart';
import 'package:weather_app/utils/preference_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  bool isOn = false;
  bool timeFormatIsOn = false;

  @override
  void initState() {

    getUnit().then((value) => setState(() {
      isOn = value;
    }));

    getTimeFormat().then((value) => setState(() {
      timeFormatIsOn = value;
    }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings Page'),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Show temperature in Fahrenheit'),
            subtitle: const Text('Default is Celsius'),
            value: isOn,
            onChanged: (value) async {
              setState(() {
                isOn = value;
              });
              await setUnit(value);
              context.read<WeatherProvider>().setUnit(value);
              context.read<WeatherProvider>().getData();
            },
          ),
          SwitchListTile(
            title: const Text('Show time in 24 hour format'),
            subtitle: const Text('Default is 12 hour format'),
            value: timeFormatIsOn,
            onChanged: (value) async {
              setState(() {
                timeFormatIsOn = value;
              });
              await setTimeFormat(value);
              context.read<WeatherProvider>().setTimeFormat(value);
              context.read<WeatherProvider>().getData();
            },
          ),
        ],
      ),
    );
  }
}
