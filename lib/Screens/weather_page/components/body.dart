import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../Models/weather_model.dart';
import '../../../Services/weather_services.dart';


class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  //api key
  final _weatherService = WeatherServices("f99d9ea6b0a628d07b3ae45258c0e258");
  Weather? _weather;

  // fetch weather
  _fetchWeather() async {
    // get the current city
    String cityName = await _weatherService.getCurrentCity();

    // get weather for city
    try{
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    }
    catch (e){
      print(e);
    }
  }

  // weather animation
  String getWeatherAnimation(String? mainCondition){
    if (mainCondition == null ) return 'assets/loading.json';  //default to sunny

    switch (mainCondition.toLowerCase()){
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
        return 'assets/rainy.json' ;
      case 'thunderstorm':
        return 'assets/thunder.json' ;
      case 'clear' :
        return 'assets/sunny.json';
      default:
        return 'assets/sunny.json';
    }
  }


  @override
  void initState() {
    super.initState();
    // fetch weather on startup
    _fetchWeather();
  }
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.location_pin,color:Colors.grey[300],size: 30,),
         const SizedBox(height: 20,),
         // city name
          Text(_weather?.cityName??"loading city...",
            style: TextStyle(
              fontSize: 30,
              color: Colors.grey[300],
              fontWeight: FontWeight.bold,
            ) ,
          ),
          const SizedBox(height: 100,),
          // animation
          Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),
          const SizedBox(height: 100,),
          // temperature
          Text("${_weather?.temperature.round()}°C",
            style: TextStyle( fontSize: 20,color:Colors.grey[300],fontWeight: FontWeight.bold ),
            ),
          const SizedBox(height: 30,),
          // condition
          Text(_weather?.mainCondition ??"",style:
              TextStyle( fontSize: 20,color:Colors.grey[300],fontWeight: FontWeight.bold ),
            ),
        ],
      ),
    );
  }
}
