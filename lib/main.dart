
import 'package:flutter/material.dart';

void main() {
  runApp(const CeciliaGeniusApp());
}

class CeciliaGeniusApp extends StatelessWidget {
  const CeciliaGeniusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cécilia Genius',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF080D2B),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6750E8),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 35),
              const Center(
                child: Icon(
                  Icons.calculate_rounded,
                  size: 85,
                  color: Color(0xFF35D5FF),
                ),
              ),
              const SizedBox(height: 18),
              const Center(
                child: Text(
                  'CÉCILIA GENIUS',
                  style: TextStyle(
                    fontSize: 29,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const Center(
                child: Text(
                  'Think. Learn. Achieve.',
                  style: TextStyle(color: Color(0xFF35D5FF)),
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                'Your mathematics laboratory',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  children: const [
                    FeatureCard(Icons.calculate, 'Calculator'),
                    FeatureCard(Icons.show_chart, 'Graphing'),
                    FeatureCard(Icons.functions, 'Equations'),
                    FeatureCard(Icons.grid_on, 'Matrices'),
                    FeatureCard(Icons.analytics, 'Statistics'),
                    FeatureCard(Icons.school, 'Calculus'),
                    FeatureCard(Icons.architecture, 'Geometry'),
                    FeatureCard(Icons.science, 'Gaussian elimination'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;

  const FeatureCard(this.icon, this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF171F4A),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ModulePage(title: title),
            ),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 36, color: const Color(0xFF35D5FF)),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ModulePage extends StatelessWidget {
  final String title;

  const ModulePage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text(
          '$title module',
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
