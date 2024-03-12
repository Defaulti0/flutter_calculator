import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'supabase_client.dart';

final supabase = SupabaseClientInstance.instance;


void main() {
  runApp(const RegisterCalc());
}

class RegisterCalc extends StatelessWidget {
  const RegisterCalc({super.key});

  static final _defaultLightScheme = ColorScheme.fromSwatch(primarySwatch: Colors.blue, brightness: Brightness.dark);
  static final _defaultDarkScheme = ColorScheme.fromSwatch(primarySwatch: Colors.blue);

  @override
  Widget build(BuildContext context) {

    return DynamicColorBuilder(
      builder: (ColorScheme? lightColorScheme, ColorScheme? darkColorScheme) {
      return MaterialApp(
        theme: ThemeData(
          colorScheme: lightColorScheme ?? _defaultLightScheme,
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          colorScheme: darkColorScheme ?? _defaultDarkScheme,
          useMaterial3: true,
        ),
        themeMode: ThemeMode.dark,
        home: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              bottom: const TabBar(
                tabs: [
                  Tab(icon: Icon(Icons.one_k)),
                  Tab(icon: Icon(Icons.two_k)),
                ],
              ),
              title: const Text('Register Calculator'),
            ),
            body: const TabBarView(
              children: [
                Column(
                  // test
                ),
                Column(

                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}