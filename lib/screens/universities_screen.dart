import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class UniversitiesScreen extends StatefulWidget {
  const UniversitiesScreen({super.key});

  @override
  State<UniversitiesScreen> createState() => _UniversitiesScreenState();
}

class _UniversitiesScreenState extends State<UniversitiesScreen> {
  final TextEditingController _countryController = TextEditingController();
  List<dynamic> _universities = [];
  bool _isLoading = false;

  Future<void> _fetchUniversities() async {
    if (_countryController.text.isEmpty) {
      return;
    }

    setState(() {
      _isLoading = true;
      _universities = [];
    });

    try {
      final country = _countryController.text.replaceAll(' ', '+');
      final response = await http.get(
        Uri.parse('https://adamix.net/proxy.php?country=$country'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _universities = data;
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

  Future<void> _launchUrl(String url) async {
    if (url.isNotEmpty && !url.startsWith('http')) {
      url = 'http://$url';
    }
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Universidades por País'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _countryController,
              decoration: const InputDecoration(
                labelText: 'Nombre del país en inglés',
                hintText: 'Ej: Dominican Republic',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _fetchUniversities,
              child: const Text('Buscar Universidades'),
            ),
            const SizedBox(height: 16),
            if (_isLoading)
              const CircularProgressIndicator()
            else if (_universities.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: _universities.length,
                  itemBuilder: (context, index) {
                    final uni = _universities[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      child: ListTile(
                        title: Text(uni['name'] ?? ''),
                        subtitle: Text(uni['domains'] != null && uni['domains'].isNotEmpty 
                            ? uni['domains'][0] 
                            : ''),
                        trailing: const Icon(Icons.open_in_new),
                        onTap: () {
                          if (uni['web_pages'] != null && uni['web_pages'].isNotEmpty) {
                            _launchUrl(uni['web_pages'][0]);
                          }
                        },
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
