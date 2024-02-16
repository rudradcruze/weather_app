import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:weather_app/models/current_weather_response.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/models/forecast_response_model.dart';
import 'package:weather_app/utils/constants.dart';

class WeatherProvider extends ChangeNotifier {
  CurrentWeatherResponse? currentWeatherResponse;
  ForecastResponseModel? forecastResponseModel;
  double latitude = 0.0, longitude = 0.0;
  String unit = metric;
  String unitSymbol = celsius;

  void setNewLocation(double latitude, double longitude) {
    this.latitude = latitude;
    this.longitude= longitude;
  }

  void setUnit(bool status) {
    unit = status ? imperial : metric;
    unitSymbol = status ? fahrenheit : celsius;
  }

  bool get hasDataLoaded => currentWeatherResponse != null &&
      forecastResponseModel != null;

  String errorMessage = '';

  Future<void> _getCurrentWeatherData() async {
    final url = 'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&units=$unit&appid=$weatherApiKey';

    try {
      final response = await http.get(Uri.parse(url));
      final map = jsonDecode(response.body);
      if (response.statusCode == 200) {
        currentWeatherResponse = CurrentWeatherResponse.fromJson(map);
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

  Future<void> _getForecastWeatherData() async {
    final url = 'https://api.openweathermap.org/data/2.5/forecast?lat=$latitude&lon=$longitude&units=$unit&appid=$weatherApiKey';

    try {
      final response = await http.get(Uri.parse(url));
      final map = jsonDecode(response.body);
      if (response.statusCode == 200) {
        forecastResponseModel = ForecastResponseModel.fromJson(map);
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

  Future<void> getData() async {
    await _getCurrentWeatherData();
    await _getForecastWeatherData();
  }
}