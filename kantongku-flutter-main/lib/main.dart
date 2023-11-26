import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kantongku/component/material_style.dart';
import 'package:kantongku/ui/navbar/navbar.dart';
import 'package:kantongku/ui/login/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  initializeDateFormatting('ID');
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: GlobalMaterialAppStyle.materialApp(context),
      home: Scaffold(
        body: FutureBuilder(
            future: SharedPreferences.getInstance(),
            builder: (context, prefs) {
              var dataPrefs = prefs.data;
              if (prefs.hasData) {
                if (dataPrefs!.getString('id') != null) {
                  return const Navbar(); // User Home Page
                } else {
                  return const LoginPage(); // Login Page
                }
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                ); // Login Page
              }
            }),
      ),
    );
  }
}
