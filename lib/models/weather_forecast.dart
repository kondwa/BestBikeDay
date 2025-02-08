class WeatherForecast {
  final DateTime date;
  final double temperature;
  final String description;
  final String icon;
  final double windSpeed;
  final double rainChance;
  final int bikeScore;

  WeatherForecast({
    required this.date,
    required this.temperature,
    required this.description,
    required this.icon,
    required this.windSpeed,
    required this.rainChance,
    required this.bikeScore,
  });

  factory WeatherForecast.fromJson(Map<String, dynamic> json) {
    // Calculate bike score based on weather conditions
    final temp = json['main']['temp'].toDouble();
    final wind = json['wind']['speed'].toDouble();
    final rain = (json['pop'] * 100).toDouble(); // Probability of precipitation in percentage

    // Calculate individual scores (0-100)
    int temperatureScore = _calculateTemperatureScore(temp);
    int windScore = _calculateWindScore(wind);
    int rainScore = _calculateRainScore(rain);

    // Calculate final score (weighted average)
    int finalScore = ((temperatureScore * 0.4) + 
                      (windScore * 0.3) + 
                      (rainScore * 0.3)).round();
    
    // Ensure score stays within 0-100 range
    finalScore = finalScore.clamp(0, 100);

    return WeatherForecast(
      date: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
      temperature: temp,
      description: json['weather'][0]['description'],
      icon: json['weather'][0]['icon'],
      windSpeed: wind,
      rainChance: rain,
      bikeScore: finalScore,
    );
  }

  // Temperature scoring (0-100)
  // Ideal temperature range: 15-25°C
  static int _calculateTemperatureScore(double temp) {
    if (temp >= 15 && temp <= 25) {
      return 100; // Perfect temperature range
    } else if (temp < 15) {
      return (100 - ((15 - temp) * 7)).round().clamp(0, 100); // Colder temperatures
    } else {
      return (100 - ((temp - 25) * 7)).round().clamp(0, 100); // Warmer temperatures
    }
  }

  // Wind scoring (0-100)
  // Ideal wind speed: 0-15 km/h
  static int _calculateWindScore(double windSpeed) {
    if (windSpeed <= 15) {
      return 100;
    } else if (windSpeed <= 30) {
      return (100 - ((windSpeed - 15) * 4)).round().clamp(0, 100);
    } else {
      return 0; // Too windy
    }
  }

  // Rain chance scoring (0-100)
  static int _calculateRainScore(double rainChance) {
    return (100 - rainChance).round().clamp(0, 100);
  }

  String getScoreDescription() {
    if (bikeScore >= 80) return 'Perfect for cycling! 🚴‍♂️';
    if (bikeScore >= 60) return 'Good conditions';
    if (bikeScore >= 40) return 'Moderate conditions';
    if (bikeScore >= 20) return 'Not ideal';
    return 'Poor conditions ⛔';
  }
} 