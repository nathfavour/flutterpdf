import 'package:flutter/material.dart';
import 'screens/pdf_home_screen.dart';
import 'screens/pdf_dashboard_screen.dart';
import 'screens/pdf_preview_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter PDF Reader',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => const PdfDashboardScreen(),
        '/preview': (context) => const PdfPreviewScreen(),
      },
    );
  }
}

void main() {
  runApp(const MyApp());
}
