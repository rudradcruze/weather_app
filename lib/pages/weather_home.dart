import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/providers/weather_provider.dart';

class WeatherHome extends StatefulWidget {
  const WeatherHome({super.key});

  @override
  State<WeatherHome> createState() => _WeatherHomeState();
}

class _WeatherHomeState extends State<WeatherHome> {

  @override
  void didChangeDependencies() {

    context.read<WeatherProvider>().getCurrentWeatherData();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather Status'),
      ),
      body: Consumer<WeatherProvider>(
        builder:(context, provider, child) => Center(
          child: Text('Current Weather: ${provider.currentWeatherResponse!.main!.temp}', style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),),
        ),
      ),
    );
  }
}
