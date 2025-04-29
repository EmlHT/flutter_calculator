import 'package:math_expressions/math_expressions.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const Color mainColor = Color.fromARGB(200, 97, 126, 140);
  static const Color backgroundColor = Color.fromARGB(255, 49, 67, 75);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      theme: ThemeData(
        scaffoldBackgroundColor: backgroundColor,
        colorScheme: ColorScheme.fromSeed(seedColor: mainColor),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Calculator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _expression = "";
  String _result = "0";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          backgroundColor: MyApp.mainColor,
          title: Text(
            widget.title,
            style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
          )),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 5.0),
                        child: Text(
                          _expression,
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            fontSize: 30,
                            color: MyApp.mainColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 5.0),
                        child: Text(
                          _result,
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            fontSize: 30,
                            color: MyApp.mainColor,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                const Spacer(),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: EdgeInsets.zero,
                    child: ButtonsDisplay(
                      expression: _expression,
                      onExpressionChanged: (String newExpression) {
                        setState(() {
                          _expression = newExpression;
                        });
                      },
                      onResultChanged: (String newResult) {
                        setState(() {
                          _result = newResult;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ButtonsDisplay extends StatelessWidget {
  final String expression;
  final void Function(String) onExpressionChanged;
  final void Function(String) onResultChanged;

  const ButtonsDisplay(
      {super.key,
      required this.expression,
      required this.onExpressionChanged,
      required this.onResultChanged});

  String evaluateExpression(String expression) {
    Parser p =
        Parser(); // instanciation d'une classe Parser pour parser la String et la convertir ensuite
    Expression exp =
        p.parse(expression); // permet de de traduire en Expression la string
    ContextModel cm =
        ContextModel(); // permet de donner une valeur aux variables (besoin pour evaluate)
    double result = exp.evaluate(EvaluationType.REAL,
        cm); // evalue l'expression avec un resultat reel, pas d'entier ou de matrice.
    return result.toString();
  }

  void _expressionDisplay(String valuePressed) {
    String updatedExpression = expression;

    print("button pressed : $valuePressed");

    switch (valuePressed) {
      case 'C':
        if (updatedExpression.isNotEmpty) {
          updatedExpression =
              updatedExpression.substring(0, updatedExpression.length - 1);
        }
        break;
      case 'AC':
        updatedExpression = '';
        break;
      case '=':
        // expression = updatedExpression.replaceAll('x', '*');
        final calculatedResult = evaluateExpression(expression.replaceAll('x', '*'));
        onResultChanged(calculatedResult);
        break; // appeler l'autre fonction de résultat
      default:
        updatedExpression += valuePressed;
    }

    onExpressionChanged(updatedExpression);
  }

  @override
  Widget build(BuildContext context) {
    final List<String> buttons = [
      '7',
      '8',
      '9',
      'C',
      'AC',
      '4',
      '5',
      '6',
      '+',
      '-',
      '1',
      '2',
      '3',
      'x',
      '/',
      '0',
      '.',
      '00',
      '=',
      '',
    ];

    return Container(
      color: MyApp.mainColor,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return GridView.count(
            crossAxisCount: 5,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio:
                constraints.maxWidth / constraints.maxHeight / 1.2,
            mainAxisSpacing: 0,
            crossAxisSpacing: 0,
            children: buttons.map((label) {
              return TextButton(
                onPressed:
                    label.isNotEmpty ? () => _expressionDisplay(label) : null,
                style: TextButton.styleFrom(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                      side: BorderSide(
                        color: Color.fromARGB(255, 77, 100, 112),
                        width: 1.0,
                      )),
                  backgroundColor: MyApp.mainColor,
                ),
                child: Text(
                  label,
                  style: TextStyle(
                    color: _getTextColor(label),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  Color _getTextColor(String label) {
    if (label == 'C' || label == 'AC') {
      return const Color.fromARGB(255, 184, 26, 26);
    } else if ('+-x/='.contains(label)) {
      return Colors.white;
    } else {
      return const Color.fromARGB(255, 55, 73, 82);
    }
  }
}
