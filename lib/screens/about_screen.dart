import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Acerca de'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 40),
              ClipOval(
                child: Image.asset(
                  'assets/foto.png',
                  height: 160,
                  width: 160,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 160,
                      width: 160,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey,
                      ),
                      child: const Icon(Icons.person, size: 80, color: Colors.white),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Jose M. Taveras',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Desarrollador Móvil',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
              const SizedBox(height: 32),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.email),
                        title: const Text('Email'),
                        subtitle: const Text('jose.taveras@example.com'),
                        onTap: () => _launchUrl('mailto:jose.taveras@example.com'),
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.phone),
                        title: const Text('Teléfono'),
                        subtitle: const Text('+1 (809) 000-0000'),
                        onTap: () => _launchUrl('tel:+18090000000'),
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.code),
                        title: const Text('GitHub'),
                        subtitle: const Text('github.com/josemtaveras'),
                        onTap: () => _launchUrl('https://github.com/josemtaveras'),
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.business),
                        title: const Text('LinkedIn'),
                        subtitle: const Text('linkedin.com/in/josemtaveras'),
                        onTap: () => _launchUrl('https://linkedin.com/in/josemtaveras'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Disponible para trabajos freelance',
                style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
