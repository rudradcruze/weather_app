import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:weather_app/models/current_weather_response.dart';
import 'package:weather_app/models/forecast_weather_response.dart';
import 'package:http/http.dart' as http;

class WeatherProvider extends ChangeNotifier {
  CurrentWeatherResponse? currentWeatherResponse;
  ForecastWeatherResponse? forecastWeatherResponse;
  String errorMessage = '';

  Future<void> getCurrentWeatherData() async {
    const url = 'https://api.openweathermap.org/data/2.5/weather?lat=23.95123&lon=90.7545123&units=metric&appid=31a1dc67da858718e60d04979176c636';

    try {
      final response = await http.get(Uri.parse(url));
      final map = jsonDecode(response.body);
      if (response.statusCode == 200) {
        currentWeatherResponse = CurrentWeatherResponse.fromJson(map);
        print(currentWeatherResponse!.main!.temp!.toString());
        notifyListeners();
      } else {
        errorMessage = map['message'];
        notifyListeners();
      }
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
    }
  }
}