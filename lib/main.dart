
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
    if (title == 'Calculator') {
      return const CalculatorPage();
    }

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text(
          '$title module coming soon',
          style: const TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String display = '0';
  double? firstNumber;
  String? operation;
  bool newNumber = true;

  void press(String key) {
    setState(() {
      if (key == 'AC') {
        display = '0';
        firstNumber = null;
        operation = null;
        newNumber = true;
        return;
      }

      if (key == '⌫') {
        if (!newNumber && display.length > 1) {
          display = display.substring(0, display.length - 1);
        } else {
          display = '0';
        }
        return;
      }

      if (key == '±') {
        if (display != '0') {
          display = display.startsWith('-')
              ? display.substring(1)
              : '-$display';
        }
        return;
      }

      if (key == '%') {
        display = _format(_number / 100);
        return;
      }

      if (key == '.') {
        if (newNumber) {
          display = '0.';
          newNumber = false;
        } else if (!display.contains('.')) {
          display += '.';
        }
        return;
      }

      if (['+', '−', '×', '÷'].contains(key)) {
        firstNumber = _number;
        operation = key;
        newNumber = true;
        return;
      }

      if (key == '=') {
        if (firstNumber != null && operation != null) {
          final second = _number;
          double result = 0;

          switch (operation) {
            case '+':
              result = firstNumber! + second;
              break;
            case '−':
              result = firstNumber! - second;
              break;
            case '×':
              result = firstNumber! * second;
              break;
            case '÷':
              if (second == 0) {
                display = 'Error';
                firstNumber = null;
                operation = null;
                newNumber = true;
                return;
              }
              result = firstNumber! / second;
              break;
          }

          display = _format(result);
          firstNumber = null;
          operation = null;
          newNumber = true;
        }
        return;
      }

      if (RegExp(r'^[0-9]$').hasMatch(key)) {
        if (newNumber || display == '0' || display == 'Error') {
          display = key;
          newNumber = false;
        } else if (display.length < 15) {
          display += key;
        }
      }
    });
  }

  double get _number => double.tryParse(display) ?? 0;

  String _format(double value) {
    if (!value.isFinite) return 'Error';
    if (value.abs() < 1e-10) return '0';
    if (value.abs() < 1e12 && value == value.roundToDouble()) {
      return value.toInt().toString();
    }
    return value.toStringAsPrecision(10);
  }

  Widget calculatorButton(String label) {
    final isOperator = ['÷', '×', '−', '+', '='].contains(label);

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: ElevatedButton(
          onPressed: () => press(label),
          style: ElevatedButton.styleFrom(
            backgroundColor: isOperator
                ? const Color(0xFF6F70E8)
                : const Color(0xFF252B40),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final rows = [
      ['AC', '±', '%', '÷'],
      ['7', '8', '9', '×'],
      ['4', '5', '6', '−'],
      ['1', '2', '3', '+'],
      ['0', '.', '⌫', '='],
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Scientific Calculator'),
      ),
      backgroundColor: const Color(0xFF101522),
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              alignment: Alignment.centerRight,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  display,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 52,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ...rows.map(
              (row) => Row(
                children: row.map(calculatorButton).toList(),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
