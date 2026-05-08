import 'dart:async';
import 'dart:math';
import 'package:flutter/cupertino.dart';

void main() => runApp(const CupertinoApp(
      home: SplashScreen(),
      theme: CupertinoThemeData(brightness: Brightness.dark),
      debugShowCheckedModeBanner: false,
    ));

// --- PANTALLA DE INICIO (SPLASH SCREEN) ---
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Temporizador de 5 segundos para navegar a la calculadora
    Timer(const Duration(seconds: 5), () {
      Navigator.of(context).pushReplacement(
        CupertinoPageRoute(builder: (_) => const ScientificCalculator()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: const Color(0xFF121212),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo del castor
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: CupertinoColors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Image.asset(
                'assets/logocetis.png',
                height: 150,
                errorBuilder: (context, error, stackTrace) => 
                  const Icon(CupertinoIcons.capsule_fill, size: 100, color: Color(0xFF6B0D0D)),
              ),
            ),
            const SizedBox(height: 40),
            // Información del estudiante
            const Text(
              "SAORI ALEJANDRA DE LOS SANTOS SOLEDAD",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: CupertinoColors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "6A Programación • Vespertino",
              style: TextStyle(
                color: Color(0xFF6B0D0D),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Text(
              "CETis 131 - Reynosa",
              style: TextStyle(
                color: CupertinoColors.systemGrey,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 50),
            const CupertinoActivityIndicator(radius: 12, color: Color(0xFF6B0D0D)),
          ],
        ),
      ),
    );
  }
}

// --- CALCULADORA CIENTÍFICA ---
class ScientificCalculator extends StatefulWidget {
  const ScientificCalculator({super.key});
  @override
  State<ScientificCalculator> createState() => _ScientificCalculatorState();
}

class _ScientificCalculatorState extends State<ScientificCalculator> {
  String _display = '0';
  double _firstValue = 0;
  String _operator = '';
  bool _shouldReset = false;

  // Color rojo personalizado solicitado
  final Color _brandRed = const Color.fromARGB(255, 107, 13, 13);

  void _onPressed(String text) {
    setState(() {
      if (text == 'AC') {
        _display = '0';
        _firstValue = 0;
        _operator = '';
      } else if (['sin', 'cos', 'tan', 'log', 'ln', '√', 'x²', 'π', 'e'].contains(text)) {
        _calculateScientific(text);
      } else if (['+', '-', '×', '÷', '^'].contains(text)) {
        _firstValue = double.tryParse(_display) ?? 0;
        _operator = text;
        _shouldReset = true;
      } else if (text == '=') {
        _calculateResult();
      } else {
        if (_display == '0' || _shouldReset) {
          _display = text;
          _shouldReset = false;
        } else {
          _display += text;
        }
      }
    });
  }

  void _calculateScientific(String func) {
    double val = double.tryParse(_display) ?? 0;
    switch (func) {
      case 'sin': _display = sin(val * pi / 180).toStringAsFixed(4); break;
      case 'cos': _display = cos(val * pi / 180).toStringAsFixed(4); break;
      case 'tan': _display = tan(val * pi / 180).toStringAsFixed(4); break;
      case 'log': _display = val > 0 ? (log(val) / ln10).toStringAsFixed(4) : 'Error'; break;
      case 'ln': _display = val > 0 ? log(val).toStringAsFixed(4) : 'Error'; break;
      case '√': _display = sqrt(val).toStringAsFixed(4); break;
      case 'x²': _display = pow(val, 2).toString(); break;
      case 'π': _display = pi.toStringAsFixed(6); break;
      case 'e': _display = e.toStringAsFixed(6); break;
    }
    _shouldReset = true;
  }

  void _calculateResult() {
    double secondValue = double.tryParse(_display) ?? 0;
    switch (_operator) {
      case '+': _display = (_firstValue + secondValue).toString(); break;
      case '-': _display = (_firstValue - secondValue).toString(); break;
      case '×': _display = (_firstValue * secondValue).toString(); break;
      case '÷': _display = secondValue != 0 ? (_firstValue / secondValue).toString() : 'Error'; break;
      case '^': _display = pow(_firstValue, secondValue).toString(); break;
    }
    _operator = '';
    _shouldReset = true;
  }

  Widget _buildButton(String text, Color color, {Color textColor = CupertinoColors.white, double flex = 1}) {
    return Expanded(
      flex: flex.toInt(),
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: CupertinoButton(
          padding: EdgeInsets.zero,
          color: color,
          borderRadius: BorderRadius.circular(8),
          onPressed: () => _onPressed(text),
          child: Text(text, style: TextStyle(fontSize: 18, color: textColor, fontWeight: FontWeight.w400)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.black,
      child: SafeArea(
        child: Column(
          children: [
            // Encabezado de la calculadora
            Container(
              padding: const EdgeInsets.all(15),
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF1C1C1E),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: CupertinoColors.systemGrey.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      'assets/castor.png',
                      height: 50, width: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => 
                        Icon(CupertinoIcons.person_solid, color: _brandRed, size: 40),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("SAORI ALEJANDRA DE LOS SANTOS SOLEDAD", 
                          style: TextStyle(color: CupertinoColors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                        Text("6A PROGRAMACIÓN - VESPERTINO", 
                          style: TextStyle(color: _brandRed, fontSize: 10, fontWeight: FontWeight.w600)),
                        const Text("CETis 131 - REYNOSA", 
                          style: TextStyle(color: CupertinoColors.systemGrey, fontSize: 10)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            Expanded(
              child: Container(
                alignment: Alignment.bottomRight,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(_display, 
                  style: const TextStyle(fontSize: 50, color: CupertinoColors.white, fontWeight: FontWeight.w200)),
              ),
            ),

            // Teclado
            Padding(
              padding: const EdgeInsets.only(bottom: 10, left: 5, right: 5),
              child: Column(
                children: [
                  Row(children: [
                    _buildButton('sin', const Color(0xFF2C2C2E)),
                    _buildButton('cos', const Color(0xFF2C2C2E)),
                    _buildButton('tan', const Color(0xFF2C2C2E)),
                    _buildButton('^', _brandRed),
                  ]),
                  Row(children: [
                    _buildButton('log', const Color(0xFF2C2C2E)),
                    _buildButton('ln', const Color(0xFF2C2C2E)),
                    _buildButton('π', const Color(0xFF2C2C2E)),
                    _buildButton('e', const Color(0xFF2C2C2E)),
                  ]),
                  Row(children: [
                    _buildButton('AC', CupertinoColors.systemGrey, textColor: CupertinoColors.black),
                    _buildButton('√', CupertinoColors.systemGrey, textColor: CupertinoColors.black),
                    _buildButton('x²', CupertinoColors.systemGrey, textColor: CupertinoColors.black),
                    _buildButton('÷', _brandRed),
                  ]),
                  Row(children: [
                    _buildButton('7', const Color(0xFF3A3A3C)),
                    _buildButton('8', const Color(0xFF3A3A3C)),
                    _buildButton('9', const Color(0xFF3A3A3C)),
                    _buildButton('×', _brandRed),
                  ]),
                  Row(children: [
                    _buildButton('4', const Color(0xFF3A3A3C)),
                    _buildButton('5', const Color(0xFF3A3A3C)),
                    _buildButton('6', const Color(0xFF3A3A3C)),
                    _buildButton('-', _brandRed),
                  ]),
                  Row(children: [
                    _buildButton('1', const Color(0xFF3A3A3C)),
                    _buildButton('2', const Color(0xFF3A3A3C)),
                    _buildButton('3', const Color(0xFF3A3A3C)),
                    _buildButton('+', _brandRed),
                  ]),
                  Row(children: [
                    _buildButton('0', const Color(0xFF3A3A3C), flex: 2),
                    _buildButton('.', const Color(0xFF3A3A3C)),
                    _buildButton('=', _brandRed),
                  ]),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
