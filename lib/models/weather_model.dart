class Weather {
  final String cityName;
  final double temperature;
  final String mainConditon;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.mainConditon,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
        cityName: json['name'],
        temperature: json['main'] ['temp'].toDouble(),
        mainConditon: json['weather'] [0] ['main']
    );
  }
}
