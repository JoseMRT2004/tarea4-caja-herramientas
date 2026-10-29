import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  Map<String, dynamic>? _weatherData;
  bool _isLoading = false;

  Future<void> _fetchWeather() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Using OpenWeatherMap API alternative or free API
      // For Dominican Republic coordinates (approx Santo Domingo)
      final response = await http.get(
        Uri.parse('https://api.open-meteo.com/v1/forecast?latitude=18.4861&longitude=-69.9312&current_weather=true&timezone=America/Santo_Domingo'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _weatherData = data['current_weather'];
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  String _getWeatherDescription(double code) {
    if (code == 0) return 'Despejado';
    if (code >= 1 && code <= 3) return 'Parcialmente nublado';
    if (code >= 45 && code <= 48) return 'Niebla';
    if (code >= 51 && code <= 57) return 'Llovizna';
    if (code >= 61 && code <= 67) return 'Lluvia';
    if (code >= 71 && code <= 77) return 'Nieve';
    if (code >= 80 && code <= 82) return 'Chubascos';
    if (code >= 95) return 'Tormenta';
    return 'Desconocido';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clima en República Dominicana'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: _isLoading
              ? const CircularProgressIndicator()
              : _weatherData == null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Error al cargar el clima'),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _fetchWeather,
                          child: const Text('Reintentar'),
                        ),
                      ],
                    )
                  : Card(
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.wb_sunny,
                              size: 80,
                              color: Colors.orange,
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'República Dominicana',
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Santo Domingo',
                              style: TextStyle(fontSize: 18, color: Colors.grey.shade700),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              '${_weatherData!['temperature']}°C',
                              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _getWeatherDescription(_weatherData!['weathercode'].toDouble()),
                              style: const TextStyle(fontSize: 20),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Viento: ${_weatherData!['windspeed']} km/h',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton(
                              onPressed: _fetchWeather,
                              child: const Text('Actualizar'),
                            ),
                          ],
                        ),
                      ),
                    ),
        ),
      ),
    );
  }
}
