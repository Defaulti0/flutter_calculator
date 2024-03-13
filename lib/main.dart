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

double calcNickel(int inputNickel){
  return inputNickel * 0.05;
}

double calcDime(int inputDime){
  return inputDime * 0.10;
}

double calcQuarter(int inputQuarter){
  return inputQuarter * 0.25;
}

double calcOne(int inputOne){
  return inputOne * 1;
}

double calcFive(int inputFive){
  return inputFive * 5;
}

double calcTen(int inputTen){
  return inputTen * 10;
}

double calcTwenty(int inputTwenty){
  return inputTwenty * 20;
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
  
  String penniVal = "";
  String nickeVal = "";
  String dimesVal = "";
  String quartVal = "";
  String onesVal = "";
  String fiveVal = "";
  String tensVal = "";
  String twenVal = "";
  String penniVal2 = "";
  String nickeVal2 = "";
  String dimesVal2 = "";
  String quartVal2 = "";
  String onesVal2 = "";
  String fiveVal2 = "";
  String tensVal2 = "";
  String twenVal2 = "";

  // final _future = getReg1();

  // static const regDefault = 317.50;

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
    super.dispose();
  }


  void updateText(String textController, int currType){
    setState(() {
      switch (currType) {
        case 0:
          penniVal = calcPenny(int.parse(textController)).toStringAsFixed(2);
          break;
        case 1:
          nickeVal = calcNickel(int.parse(textController)).toStringAsFixed(2);
          break;
        case 2:
          dimesVal = calcDime(int.parse(textController)).toStringAsFixed(2);
          break;
        case 3:
          quartVal = calcQuarter(int.parse(textController)).toStringAsFixed(2);
          break;
        case 4:
          onesVal = calcOne(int.parse(textController)).toStringAsFixed(2);
          break;
        case 5:
          fiveVal = calcFive(int.parse(textController)).toStringAsFixed(2);
          break;
        case 6:
          tensVal = calcTen(int.parse(textController)).toStringAsFixed(2);
          break;
        case 7:
          twenVal = calcTwenty(int.parse(textController)).toStringAsFixed(2);
          break;
        case 8:
          penniVal2 = calcPenny(int.parse(textController)).toStringAsFixed(2);
          break;
        case 9:
          nickeVal2 = calcNickel(int.parse(textController)).toStringAsFixed(2);
          break;
        case 10:
          dimesVal2 = calcDime(int.parse(textController)).toStringAsFixed(2);
          break;
        case 11:
          quartVal2 = calcQuarter(int.parse(textController)).toStringAsFixed(2);
          break;
        case 12:
          onesVal2 = calcOne(int.parse(textController)).toStringAsFixed(2);
          break;
        case 13:
          fiveVal2 = calcFive(int.parse(textController)).toStringAsFixed(2);
          break;
        case 14:
          tensVal2 = calcTen(int.parse(textController)).toStringAsFixed(2);
          break;
        case 15:
          twenVal2 = calcTwenty(int.parse(textController)).toStringAsFixed(2);
          break;
      }
      
    });
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
                              if (quart.text == ""){
                                updateText("0", 3);
                              } else {
                                updateText(quart.text, 3);
                              }
                            },
                          ),
                        ),
                        Flexible(
                          child: Text("Result: \$$quartVal"),
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
                            onChanged: (String value) async {
                              if (dimes.text == ""){
                                updateText("0", 2);
                              } else {
                                updateText(dimes.text, 2);
                              }
                            },
                          ),
                        ),
                        Flexible(
                          child: Text("Result: \$$dimesVal"),
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
                            onChanged: (String value) async {
                              if (nickl.text == ""){
                                updateText("0", 1);
                              } else {
                                updateText(nickl.text, 1);
                              }
                            },
                          ),
                        ),
                        Flexible(
                          child: Text("Result: \$$nickeVal"),
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
                            onChanged: (String value) async {
                              if (penni.text == ""){
                                updateText("0", 0);
                              } else {
                                updateText(penni.text, 0);
                              }
                            },
                          ),
                        ),
                        Flexible(
                          child: Text("Result: \$$penniVal"),
                        ),
                      ],
                    ),
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
                              if (quart.text == ""){
                                updateText("0", 3);
                              } else {
                                updateText(quart.text, 3);
                              }
                            },
                          ),
                        ),
                        Flexible(
                          child: Text("Result: \$$quartVal"),
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
                            onChanged: (String value) async {
                              if (dimes.text == ""){
                                updateText("0", 2);
                              } else {
                                updateText(dimes.text, 2);
                              }
                            },
                          ),
                        ),
                        Flexible(
                          child: Text("Result: \$$dimesVal"),
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
                            onChanged: (String value) async {
                              if (nickl.text == ""){
                                updateText("0", 1);
                              } else {
                                updateText(nickl.text, 1);
                              }
                            },
                          ),
                        ),
                        Flexible(
                          child: Text("Result: \$$nickeVal"),
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
                              hintText: 'Enter # of ones',
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            controller: ones,
                            onChanged: (String value) async {
                              if (ones.text == ""){
                                updateText("0", 0);
                              } else {
                                updateText(ones.text, 4);
                              }
                            },
                          ),
                        ),
                        Flexible(
                          child: Text("Result: \$$onesVal"),
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