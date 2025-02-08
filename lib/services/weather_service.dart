import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

class WeatherService {
  static const String _apiKey = '7a61540cac7688b35ca6bd125d54401e'; // Replace with your API key
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5';

  Future<Position> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<Map<String, dynamic>> getWeatherForecast() async {
    try {
      final position = await getCurrentLocation();
      final url = "$_baseUrl/forecast?lat=${position.latitude}&lon=${position.longitude}&units=metric&appid=$_apiKey";
      //print(url);
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load weather data for url $url');
      }
    } catch (e) {
      throw Exception('Error getting weather: $e');
    }
  }
} 