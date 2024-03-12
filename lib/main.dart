import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/services.dart';
import 'supabase_client.dart';

final supabase = SupabaseClientInstance.instance;

void main() {
  runApp(const RegCalc());
}

class RegCalc extends StatefulWidget{
  const RegCalc({super.key});

  @override
  State<RegCalc> createState() => _RegCalcState();
}

Future<List<Map<String, dynamic>>> getReg1() async {
  // final supabase = SupabaseClientInstance.instance;

  final response = await supabase
                      .from('register1')
                      .select();
  return response;
}

Future<List<Map<String, dynamic>>> getReg2() async {
  // final supabase = SupabaseClientInstance.instance;

  final response = await supabase
                      .from('register2')
                      .select();
  return response;
}

double calcPenny(int inputPenny){
  return inputPenny * 0.01;
}

double calcQuarter(int inputQuarter){
  return inputQuarter * 0.25;
}

class _RegCalcState extends State<RegCalc> {
  static final _defaultLightScheme = ColorScheme.fromSwatch(primarySwatch: Colors.blue, brightness: Brightness.dark);
  static final _defaultDarkScheme = ColorScheme.fromSwatch(primarySwatch: Colors.blue);

  late TextEditingController penni = TextEditingController();
  late TextEditingController dimes = TextEditingController();
  late TextEditingController nickl = TextEditingController();
  late TextEditingController quart = TextEditingController();
  late TextEditingController penni2 = TextEditingController();
  late TextEditingController dimes2 = TextEditingController();
  late TextEditingController nickl2 = TextEditingController();
  late TextEditingController quart2 = TextEditingController();
  late TextEditingController ones = TextEditingController();
  late TextEditingController fives = TextEditingController();
  late TextEditingController tens = TextEditingController();
  late TextEditingController twents = TextEditingController();
  late TextEditingController ones2 = TextEditingController();
  late TextEditingController fives2 = TextEditingController();
  late TextEditingController tens2 = TextEditingController();
  late TextEditingController twent2 = TextEditingController();  
  // add late TextEditingController bills = TextEditingController(); here
  
  final _future = getReg1();

  static const regDefault = 317.50;

  @override
  void dispose() {
    penni.dispose();
    dimes.dispose();
    nickl.dispose();
    quart.dispose();
    penni2.dispose();
    dimes2.dispose();
    nickl2.dispose();
    quart2.dispose();
    ones.dispose();
    fives.dispose();
    tens.dispose();
    twents.dispose();
    ones2.dispose();
    fives2.dispose();
    tens2.dispose();
    twent2.dispose();

    // add bills.dispose(); here
    super.dispose();
  }


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
        home: DefaultTabController(
          length: 2,
          child: Scaffold(
            // Put floating icon to show last 10 register values per register
            appBar: AppBar(
              bottom: const TabBar(
                tabs: [
                  Tab(icon: Icon(Icons.one_k)),
                  Tab(icon: Icon(Icons.two_k)),
                ],
              ),
              title: const Text('Register Calculator'),
            ),
            body: TabBarView(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Flexible(
                          child: Text("Quarters: "),
                        ),
                        Flexible(
                          flex: 2,
                          child: TextFormField(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Enter # of quarters',
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            controller: quart,
                            onChanged: (String value) async {
                              calcQuarter(int.parse(quart.text));
                            },
                          ),
                        ),
                        const Flexible(
                          child: Text("Quarter Calc Result"),
                          ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Flexible(
                          child: Text("Dimes: "),
                        ),
                        Flexible(
                          flex: 2,
                          child: TextFormField(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Enter # of dimes',
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            controller: dimes,
                          ),
                        ),
                        const Flexible(
                          child: Text("Dime Calc Result"),
                          ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Flexible(
                          child: Text("Nickels: "),
                        ),
                        Flexible(
                          flex: 2,
                          child: TextFormField(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Enter # of nickels',
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            controller: nickl,
                          ),
                        ),
                        const Flexible(
                          child: Text("Nickel Calc Result"),
                          ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Flexible(
                          child: Text("Pennies: "),
                        ),
                        Flexible(
                          flex: 2,
                          child: TextFormField(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Enter # of pennies',
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            controller: penni,
                            onChanged: (value) {},
                          ),
                        ),
                        const Flexible(
                          child: Text("Penny Calc Result"),
                          ),
                      ],
                    ),
                    
                    // ======= bills =======
                    

                    ElevatedButton(
                      onPressed: () {}, 
                      child: const Text("Submit Change"),
                    )
                    // put submit button here
                  ],
                ),

                // other tab
                const Text("Register 2"),
             ],
            ),
          ),
        ),
      );
    });
  }
}