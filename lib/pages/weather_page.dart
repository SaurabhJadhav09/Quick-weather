import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lottie/lottie.dart';
import '../models/weather_model.dart';
import '../service/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _weatherService = WeatherService('a2983714aa643d8d4fb87cafbe605b78');
  Weather? _weather;

  _fetchWeather() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
        print('Location permissions are denied');
        return;
      }
    }

    String cityName = await _weatherService.getCurrentCity();
    print('City: $cityName');

    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print(e);
    }
  }

  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/sunny.json';

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/cloud.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rainy.json';
      case 'thunderstorm':
        return 'assets/thunder.json';
      case 'clear':
        return 'assets/sunny.json';
      default:
        return 'assets/sunny.json';
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                const SizedBox(height: 70), // Adjust this value to move the whole section down
                const Icon(
                  Icons.location_on,
                  color: Colors.grey,
                  size: 40.0, // Adjust size as needed
                ),
                const SizedBox(height: 5), // Adjust this value for space between icon and text
                Text(
                  _weather?.cityName ?? "Loading city...",
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 24.0, // Change text size here
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Expanded(
              child: Center(
                child: Lottie.asset(getWeatherAnimation(_weather?.mainConditon)),
              ),
            ),
            Column(
              children: [
                Text(
                  '${_weather?.temperature.round()}℃',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 50.0, // Adjust text size if needed
                  ),
                ),
                Text(
                  _weather?.mainConditon ?? "",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24.0, // Adjust text size if needed
                  ),
                ),
                const SizedBox(height: 70), // Adjust this value to move the whole section up/down
              ],
            ),
          ],
        ),
      ),
    );
  }
}
