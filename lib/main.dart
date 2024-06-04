import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:register_calculator/register_log.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:register_calculator/register.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


Future<void> main() async {
  await Supabase.initialize(
    url: 'https://gcsoenjtznqmxcmakolu.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imdjc29lbmp0em5xbXhjbWFrb2x1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTAxMjkyNjUsImV4cCI6MjAyNTcwNTI2NX0.uu2sjs07cps91Aeuhh3TDsukZH-Hn-oG94saoxXmXEM',
  );
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const RegMain());
}

class RegMain extends StatefulWidget {
  const RegMain({super.key});

  @override
  State<RegMain> createState() => RegState();
}

class RegState extends State<RegMain> with SingleTickerProviderStateMixin{
  static final _defaultLightScheme = ColorScheme.fromSwatch(
    primarySwatch: Colors.blue, brightness: Brightness.dark);
  static final _defaultDarkScheme =
    ColorScheme.fromSwatch(primarySwatch: Colors.blue);

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  late TabController tabController;

  @override
  void initState(){
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context){
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
        home: Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            bottom: TabBar(
              controller: tabController,
              tabs: const [
                Tab(text: "Register Calc", icon: Icon(Icons.calculate_outlined)),
                Tab(text: "Register Logs", icon: Icon(Icons.history_outlined)),
              ],
            ),
            title: const Text('Register Calculator'),
          ),
          body: Builder(
            builder: (BuildContext context) {
              return TabBarView(
                controller: tabController,
                children: const [
                  Register(),
                  RegisterLog(),
                ],
              );
          }),
        ),
      );
    });
  }
}
