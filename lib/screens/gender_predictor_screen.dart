import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GenderPredictorScreen extends StatefulWidget {
  const GenderPredictorScreen({super.key});

  @override
  State<GenderPredictorScreen> createState() => _GenderPredictorScreenState();
}

class _GenderPredictorScreenState extends State<GenderPredictorScreen> {
  final TextEditingController _nameController = TextEditingController();
  String _gender = '';
  double? _probability;
  bool _isLoading = false;
  Color _backgroundColor = Colors.white;

  Future<void> _predictGender() async {
    if (_nameController.text.isEmpty) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse('https://api.genderize.io/?name=${_nameController.text.trim()}'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _gender = data['gender'] ?? '';
          _probability = data['probability']?.toDouble();
          if (_gender == 'male') {
            _backgroundColor = Colors.blue.shade100;
          } else if (_gender == 'female') {
            _backgroundColor = Colors.pink.shade100;
          } else {
            _backgroundColor = Colors.grey.shade100;
          }
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Predecir Género'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      backgroundColor: _backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nombre',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _predictGender,
              child: const Text('Predecir'),
            ),
            const SizedBox(height: 32),
            if (_isLoading)
              const CircularProgressIndicator()
            else if (_gender.isNotEmpty)
              Column(
                children: [
                  Icon(
                    _gender == 'male' ? Icons.male : Icons.female,
                    size: 100,
                    color: _gender == 'male' ? Colors.blue : Colors.pink,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _gender == 'male' ? 'Masculino' : 'Femenino',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: _gender == 'male' ? Colors.blue.shade800 : Colors.pink.shade800,
                    ),
                  ),
                  if (_probability != null)
                    Text(
                      'Probabilidad: ${(_probability! * 100).toStringAsFixed(1)}%',
                      style: const TextStyle(fontSize: 18),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
