
import 'package:flutter/material.dart';
import 'views/input_page.dart';

void main() {
  runApp(const KalkulatorBMI());
}

class KalkulatorBMI extends StatelessWidget {
  const KalkulatorBMI({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kalkulator BMI',
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: const Color(0xFFF5F7F5),
        useMaterial3: true,
      ),
      home: const InputPage(),
    );
  }
}
