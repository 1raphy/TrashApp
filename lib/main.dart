import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(BankSampahApp());
}

class BankSampahApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bank Sampah',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFF4CAF50),
          secondary: Color(0xFF81C784),
        ),
        scaffoldBackgroundColor: Colors.white,
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.black87),
          labelLarge: TextStyle(color: Colors.white),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF4CAF50),
            padding: EdgeInsets.symmetric(vertical: 15),
            textStyle: TextStyle(fontSize: 16),
          ),
        ),
        useMaterial3: true, // opsional agar konsisten dengan Material 3
      ),
      home: LoginScreen(),
    );
  }
}
