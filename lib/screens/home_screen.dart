import 'package:flutter/material.dart';
import 'gender_predictor_screen.dart';
import 'random_user_screen.dart';
import 'universities_screen.dart';
import 'weather_screen.dart';
import 'pokemon_screen.dart';
import 'wordpress_news_screen.dart';
import 'about_screen.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback toggleTheme;
  final ThemeMode themeMode;
  
  const HomeScreen({super.key, required this.toggleTheme, required this.themeMode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Caja de Herramientas'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(themeMode == ThemeMode.light ? Icons.dark_mode : Icons.light_mode),
            onPressed: toggleTheme,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            ClipOval(
              child: Image.asset(
                'assets/foto.png',
                height: 200,
                width: 200,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 200,
                    width: 200,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.orange,
                    ),
                    child: const Icon(
                      Icons.build,
                      size: 100,
                      color: Colors.white,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Caja de Herramientas',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            _buildMenuButton(context, 'Predecir Género', Icons.person, const GenderPredictorScreen()),
            _buildMenuButton(context, 'Usuario Aleatorio', Icons.account_circle, const RandomUserScreen()),
            _buildMenuButton(context, 'Universidades por País', Icons.school, const UniversitiesScreen()),
            _buildMenuButton(context, 'Clima en RD', Icons.wb_sunny, const WeatherScreen()),
            _buildMenuButton(context, 'Pokémon', Icons.catching_pokemon, const PokemonScreen()),
            _buildMenuButton(context, 'Noticias WordPress', Icons.article, const WordpressNewsScreen()),
            _buildMenuButton(context, 'Acerca de', Icons.info, const AboutScreen()),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context, String title, IconData icon, Widget screen) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => screen),
          );
        },
        icon: Icon(icon),
        label: Text(title),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(16),
          alignment: Alignment.centerLeft,
        ),
      ),
    );
  }
}
