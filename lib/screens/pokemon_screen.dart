import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';

class PokemonScreen extends StatefulWidget {
  const PokemonScreen({super.key});

  @override
  State<PokemonScreen> createState() => _PokemonScreenState();
}

class _PokemonScreenState extends State<PokemonScreen> {
  final TextEditingController _pokemonController = TextEditingController();
  Map<String, dynamic>? _pokemonData;
  bool _isLoading = false;
  final AudioPlayer _audioPlayer = AudioPlayer();

  Future<void> _fetchPokemon() async {
    if (_pokemonController.text.isEmpty) {
      return;
    }

    setState(() {
      _isLoading = true;
      _pokemonData = null;
    });

    try {
      final pokemonName = _pokemonController.text.toLowerCase().trim();
      final response = await http.get(
        Uri.parse('https://pokeapi.co/api/v2/pokemon/$pokemonName'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _pokemonData = data;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Pokémon no encontrado')),
          );
        }
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _playSound() async {
    if (_pokemonData != null && _pokemonData!['cries'] != null) {
      final soundUrl = _pokemonData!['cries']['latest'];
      if (soundUrl != null) {
        await _audioPlayer.play(UrlSource(soundUrl));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokémon'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _pokemonController,
              decoration: const InputDecoration(
                labelText: 'Nombre del Pokémon',
                hintText: 'Ej: pikachu',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _fetchPokemon,
              child: const Text('Buscar'),
            ),
            const SizedBox(height: 32),
            if (_isLoading)
              const CircularProgressIndicator()
            else if (_pokemonData != null)
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      Image.network(
                        _pokemonData!['sprites']['front_default'] ?? '',
                        height: 150,
                        width: 150,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.catching_pokemon, size: 150);
                        },
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _pokemonData!['name'].toString().toUpperCase(),
                        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Experiencia Base: ${_pokemonData!['base_experience']}',
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Habilidades:',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      ...(_pokemonData!['abilities'] as List).map((ability) {
                        return Text(
                          '- ${ability['ability']['name']}',
                          style: const TextStyle(fontSize: 16),
                        );
                      }),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: _playSound,
                        icon: const Icon(Icons.volume_up),
                        label: const Text('Reproducir Sonido'),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
