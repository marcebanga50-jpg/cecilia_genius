
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
  String expression = '';
  String result = '0';
  bool justCalculated = false;

  final List<Map<String, String>> history = [];

  void press(String key) {
    setState(() {
      if (key == 'AC') {
        expression = '';
        result = '0';
        justCalculated = false;
        return;
      }

      if (key == '⌫') {
        if (justCalculated) {
          expression = '';
          result = '0';
          justCalculated = false;
        } else if (expression.isNotEmpty) {
          expression = expression.substring(0, expression.length - 1);
        }
        return;
      }

      if (key == '=') {
        calculate();
        return;
      }

      final isOperator = ['+', '−', '×', '÷'].contains(key);

      if (justCalculated) {
        if (isOperator) {
          expression = result;
        } else {
          expression = '';
        }
        justCalculated = false;
      }

      if (expression.length >= 80) return;

      if (key == '.') {
        final parts = expression.split(RegExp(r'[+\−×÷()]'));
        if (parts.isNotEmpty && parts.last.contains('.')) return;

        if (expression.isEmpty ||
            RegExp(r'[+\−×÷(]$').hasMatch(expression)) {
          expression += '0';
        }
      }

      expression += key;
    });
  }

  void calculate() {
    if (expression.trim().isEmpty) return;

    try {
      final value = ExpressionParser(expression).parse();
      final answer = formatNumber(value);

      setState(() {
        result = answer;
        justCalculated = true;

        history.insert(0, {
          'expression': expression,
          'result': answer,
        });

        if (history.length > 20) {
          history.removeLast();
        }
      });
    } catch (_) {
      setState(() {
        result = 'Erreur';
        justCalculated = false;
      });
    }
  }

  String formatNumber(double value) {
    if (!value.isFinite) return 'Erreur';
    if (value == 0) return '0';

    if (value.abs() < 1e12 &&
        value == value.roundToDouble()) {
      return value.toInt().toString();
    }

    return value.toStringAsPrecision(10);
  }

  void showHistory() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, refreshDialog) {
            return AlertDialog(
              backgroundColor: const Color(0xFF20283A),
              title: const Text(
                'Historique des calculs',
                style: TextStyle(color: Colors.white),
              ),
              content: SizedBox(
                width: double.maxFinite,
                height: 350,
                child: history.isEmpty
                    ? const Center(
                        child: Text(
                          'Aucun calcul enregistré',
                          style: TextStyle(color: Colors.white70),
                        ),
                      )
                    : ListView.builder(
                        itemCount: history.length,
                        itemBuilder: (context, index) {
                          final item = history[index];

                          return ListTile(
                            title: Text(
                              item['expression']!,
                              style: const TextStyle(
                                color: Colors.white70,
                              ),
                            ),
                            subtitle: Text(
                              '= ${item['result']}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                expression = item['expression']!;
                                result = item['result']!;
                                justCalculated = true;
                              });
                              Navigator.pop(dialogContext);
                            },
                          );
                        },
                      ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      history.clear();
                    });
                    refreshDialog(() {});
                  },
                  child: const Text('Effacer historique'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Fermer'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget calculatorButton(String label) {
    final isOperator =
        ['÷', '×', '−', '+', '='].contains(label);

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: ElevatedButton(
          onPressed: () => press(label),
          style: ElevatedButton.styleFrom(
            backgroundColor: isOperator
                ? const Color(0xFF6F70E8)
                : const Color(0xFF252B40),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 17),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 22,
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
      ['AC', '(', ')', '⌫'],
      ['7', '8', '9', '÷'],
      ['4', '5', '6', '×'],
      ['1', '2', '3', '−'],
      ['0', '.', '%', '+'],
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Scientific Calculator'),
        actions: [
          IconButton(
            onPressed: showHistory,
            icon: const Icon(Icons.history),
            tooltip: 'Historique',
          ),
        ],
      ),
      backgroundColor: const Color(0xFF101522),
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 12,
              ),
              alignment: Alignment.centerRight,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                reverse: true,
                child: Text(
                  expression.isEmpty ? '0' : expression,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 30,
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 12,
              ),
              alignment: Alignment.centerRight,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  result,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 18),
            ...rows.map(
              (row) => Row(
                children: row.map(calculatorButton).toList(),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: ElevatedButton(
                      onPressed: () => press('='),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF28A879),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          vertical: 17,
                        ),
                      ),
                      child: const Text(
                        '=',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

class ExpressionParser {
  final String input;
  int position = 0;

  ExpressionParser(String expression)
      : input = expression
            .replaceAll('×', '*')
            .replaceAll('÷', '/')
            .replaceAll('−', '-')
            .replaceAll(' ', '');

  double parse() {
    final value = parseExpression();

    if (position != input.length) {
      throw const FormatException('Expression invalide');
    }

    return value;
  }

  double parseExpression() {
    double value = parseTerm();

    while (position < input.length) {
      if (match('+')) {
        value += parseTerm();
      } else if (match('-')) {
        value -= parseTerm();
      } else {
        break;
      }
    }

    return value;
  }

  double parseTerm() {
    double value = parseUnary();

    while (position < input.length) {
      if (match('*')) {
        value *= parseUnary();
      } else if (match('/')) {
        final divisor = parseUnary();

        if (divisor == 0) {
          throw const FormatException('Division par zéro');
        }

        value /= divisor;
      } else {
        break;
      }
    }

    return value;
  }

  double parseUnary() {
    if (match('+')) return parseUnary();
    if (match('-')) return -parseUnary();

    return parsePrimary();
  }

  double parsePrimary() {
    double value;

    if (match('(')) {
      value = parseExpression();

      if (!match(')')) {
        throw const FormatException('Parenthèse manquante');
      }
    } else {
      value = parseNumber();
    }

    while (match('%')) {
      value /= 100;
    }

    return value;
  }

  double parseNumber() {
    final start = position;
    bool hasDigit = false;

    while (position < input.length &&
        RegExp(r'[0-9]').hasMatch(input[position])) {
      position++;
      hasDigit = true;
    }

    if (position < input.length && input[position] == '.') {
      position++;

      while (position < input.length &&
          RegExp(r'[0-9]').hasMatch(input[position])) {
        position++;
        hasDigit = true;
      }
    }

    if (!hasDigit) {
      throw const FormatException('Nombre invalide');
    }

    return double.parse(input.substring(start, position));
  }

  bool match(String character) {
    if (position < input.length &&
        input[position] == character) {
      position++;
      return true;
    }

    return false;
  }
}
