import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/models/current_weather_response.dart';
import 'package:weather_app/models/forecast_response_model.dart';
import 'package:weather_app/pages/settings_page.dart';
import 'package:weather_app/providers/weather_provider.dart';
import 'package:weather_app/utils/constants.dart';
import 'package:weather_app/utils/helper_function.dart';
import 'package:weather_app/utils/location_service.dart';
import 'package:weather_app/utils/preference_service.dart';
import 'package:weather_app/utils/styles.dart';

class WeatherHome extends StatefulWidget {
  const WeatherHome({super.key});

  @override
  State<WeatherHome> createState() => _WeatherHomeState();
}

class _WeatherHomeState extends State<WeatherHome> {
  @override
  void didChangeDependencies() {
    _getWeatherData();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather Status'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsPage()));
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: Consumer<WeatherProvider>(
        builder: (context, provider, child) => provider.hasDataLoaded
            ? Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _currentSection(provider.currentWeatherResponse!, provider.unitSymbol),
                  _forecastSection(provider.forecastResponseModel!.list!, provider.unitSymbol),
                ],
              )
            : const Center(
                child: CircularProgressIndicator(
                  color: Colors.purple,
                ),
              ),
      ),
    );
  }

  Widget _currentSection(CurrentWeatherResponse response, String unitSymbol) {
    return Expanded(
      child: ListView(
        children: [
          Text(
            getFormattedDateTime(response.dt!),
            style: const TextStyle(fontSize: 18.0),
            textAlign: TextAlign.center,
          ),
          Text(
            "${response.name}, ${response.sys!.country}",
            style: const TextStyle(fontSize: 22.0),
            textAlign: TextAlign.center,
          ),
          Text(
            "${response.main!.temp!.round()}$degree$unitSymbol",
            style: const TextStyle(fontSize: 80.0),
            textAlign: TextAlign.center,
          ),
          Text(
            "Feels Like ${response.main!.feelsLike!.round()}$degree$unitSymbol",
            style: const TextStyle(fontSize: 22.0),
            textAlign: TextAlign.center,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(getIconDownloadUrl(response.weather!.first!.icon!)),
              Text(
                response.weather!.first!.description!,
                style: const TextStyle(fontSize: 18.0),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Sunrise: ${getFormattedDateTime(response.sys!.sunrise!, pattern: 'hh:mm')}, ',
                style: timeTextStyle,
              ),
              Text(
                  'Sunset: ${getFormattedDateTime(response.sys!.sunset!, pattern: 'hh:mm a')}',
                  style: timeTextStyle),
            ],
          )
        ],
      ),
    );
  }

  Widget _forecastSection(List<ForecastItem> items, String unitSymbol) {
    return SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return Card(
            color: Colors.grey.withOpacity(0.3),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Column(
                children: [
                  Text(getFormattedDateTime(item.dt!, pattern: 'EEE, hh:mm a')),
                  Image.network(
                    getIconDownloadUrl(item.weather!.first!.icon!),
                    width: 40,
                    height: 40,
                  ),
                  Text(
                    item.weather!.first!.description!,
                    style: const TextStyle(fontSize: 14.0),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _getWeatherData() async {
    final position = await determinePosition();
    final status = await getStatus();
    context.read<WeatherProvider>().setNewLocation(position.latitude, position.longitude);
    context.read<WeatherProvider>().setUnit(status);
    context.read<WeatherProvider>().getData();
  }
}
