import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
// import 'package:weatherapp/models/weather_model.dart';
// import 'package:weatherapp/service/weather_service.dart';

import '../models/weather_model.dart';
import '../service/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {

  //api key
  final _weatherService = WeatherService('987d67f581f76aea6addd1d669b86fea');
  Weather? _weather;

  //fetch weather
  _fetchWeather() async{
    //get current city
    String cityName = await _weatherService.getCurrentCity();

    //get weather for city
    try  {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    }

    //any errors
    catch (e){
      print(e);
    }
  }

  //weather animations
  String getWeatherAnimation(String? mainConditon){
    if (mainConditon== null) return 'assets/sunny.json'; //default to sunny 

    switch (mainConditon.toLowerCase()){
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
        return  'assets/sunny.json';
      default:
        return 'assets/sunny.json';
    }
  }

  //init state
  @override
  void initState() {
    super.initState();

    //fetch weather on startup
    _fetchWeather();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // location icon and city name
            Column(
              children: [
                const Icon(
                  Icons.location_on,
                  color: Colors.white,
                  size: 22.0, // Adjust size as needed
                ),
            Text(_weather?.cityName ?? "Loading city..",
            style: const TextStyle(
              color: Colors.white
            ),
            ),
              ],
            ),

            //animation
            Lottie.asset(getWeatherAnimation(_weather?.mainConditon)),

            //temperature
            Text('${_weather?.temperature.round()}℃',
            style: const TextStyle(
              color: Colors.white,
            ),
            ),

            //weather conditon
            Text(_weather?.mainConditon ?? "",
            style: const TextStyle(
              color: Colors.white,
            ),
            ),
          ],
        ),
      ),

    );
  }
}