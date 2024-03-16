import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';

Future<void> main() async {
  await Supabase.initialize(
    url: 'https://gcsoenjtznqmxcmakolu.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imdjc29lbmp0em5xbXhjbWFrb2x1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTAxMjkyNjUsImV4cCI6MjAyNTcwNTI2NX0.uu2sjs07cps91Aeuhh3TDsukZH-Hn-oG94saoxXmXEM',
  );

  runApp(
    const RegCalc()
  );
}

// Get a reference your Supabase client
final supabase = Supabase.instance.client;

// final supabase = SupabaseClientInstance.instance;

class RegCalc extends StatefulWidget{
  const RegCalc({super.key});

  @override
  State<RegCalc> createState() => _RegCalcState();
}

Future<List<Map<String, dynamic>>> getReg1() async {

  final response = await supabase
                      .from('register1')
                      .select()
                      .order('dateTime', ascending: false)
                      .range(0,9);
  return response;
}

Future<List<Map<String, dynamic>>> getReg2() async {

  final response = await supabase
                      .from('register2')
                      .select()
                      .order('dateTime', ascending: false)
                      .range(0,9);
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

double findSum(String penniVal, String nickeVal, String dimesVal, 
  String quartVal, String onesVal, String fiveVal, String tensVal, 
  String twenVal, String extraVal){

  return double.parse(penniVal) + double.parse(nickeVal) + 
    double.parse(dimesVal) + double.parse(quartVal) + double.parse(onesVal) + 
    double.parse(fiveVal) + double.parse(tensVal) + double.parse(twenVal) +
    double.parse(extraVal);
}

void checkReg1(String penniVal, String nickeVal, String dimesVal, 
  String quartVal, String onesVal, String fiveVal, String tensVal, 
  String twenVal, String extraVal, String cSales){
  
  double regConst = 317.50;
  String isExact = "";
  double sum = findSum(penniVal, nickeVal, dimesVal, quartVal, onesVal, 
    fiveVal, tensVal, twenVal, extraVal);
  
  if (sum > regConst){
    isExact = "Over";
  } else if (sum < regConst){
    isExact = "Under";
  } else {
    isExact = "Correct";
  }

  sendReg1(penniVal, nickeVal, dimesVal, quartVal, onesVal, fiveVal, 
    tensVal, twenVal, extraVal, isExact, sum, cSales);
}

Future<void> sendReg1(String penniVal, String nickeVal, String dimesVal, 
  String quartVal, String onesVal, String fiveVal, String tensVal, 
  String twenVal, String extraVal, String isExact, double sum, String cashSalesVal) async {
  
  await supabase
      .from('register1')
      .insert({
        'dateTime': DateTime.now().toIso8601String(),
        'pennies': double.parse(penniVal), 
        'nickels': double.parse(nickeVal),
        'dimes': double.parse(dimesVal),
        'quarters': double.parse(quartVal),
        'ones': double.parse(onesVal),
        'fives': double.parse(fiveVal),
        'tens': double.parse(tensVal),
        'twenties': double.parse(twenVal),
        'extra_bills': double.parse(extraVal),
        'Status': isExact,
        'total': sum,
        'cashSales': double.parse(cashSalesVal.substring(1)),
      });
}

void checkReg2(String penniVal, String nickeVal, String dimesVal, 
  String quartVal, String onesVal, String fiveVal, String tensVal, 
  String twenVal, String extraVal, String cashSalesVal2){
  
  double regConst = 317.50;
  String isExact = "";
  double sum = findSum(penniVal, nickeVal, dimesVal, quartVal, onesVal, 
    fiveVal, tensVal, twenVal, extraVal);
  
  if (sum > regConst){
    isExact = "Over";
  } else if (sum < regConst){
    isExact = "Under";
  } else {
    isExact = "Correct";
  }

  sendReg2(penniVal, nickeVal, dimesVal, quartVal, onesVal, fiveVal, 
    tensVal, twenVal, extraVal, isExact, sum, cashSalesVal2);
}

Future<void> sendReg2(String penniVal, String nickeVal, String dimesVal, 
  String quartVal, String onesVal, String fiveVal, String tensVal, 
  String twenVal, String extraVal, String isExact, double sum, String cashSalesVal) async {

  await supabase
      .from('register2')
      .insert({
        'dateTime': DateTime.now().toIso8601String(),
        'pennies': double.parse(penniVal), 
        'nickels': double.parse(nickeVal),
        'dimes': double.parse(dimesVal),
        'quarters': double.parse(quartVal),
        'ones': double.parse(onesVal),
        'fives': double.parse(fiveVal),
        'tens': double.parse(tensVal),
        'twenties': double.parse(twenVal),
        'extra_bills': double.parse(extraVal),
        'Status': isExact,
        'total': sum,
        'cashSales': double.parse(cashSalesVal.substring(1)),
      });
}


class _RegCalcState extends State<RegCalc> with SingleTickerProviderStateMixin {
  static final _defaultLightScheme = ColorScheme.fromSwatch(
    primarySwatch: Colors.blue, brightness: Brightness.dark);
  static final _defaultDarkScheme = ColorScheme.fromSwatch(
    primarySwatch: Colors.blue);

  var future1 = getReg1();
  var future2 = getReg2();

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
  late TextEditingController extra = TextEditingController(text: "0");
  late TextEditingController extra2 = TextEditingController(text: "0");
  late TextEditingController cashSales = TextEditingController(text: "\$0");
  late TextEditingController cashSales2 = TextEditingController(text: "\$0");
  
  String penniVal = "0.00";
  String nickeVal = "0.00";
  String dimesVal = "0.00";
  String quartVal = "0.00";
  String onesVal = "0.00";
  String fiveVal = "0.00";
  String tensVal = "0.00";
  String twenVal = "0.00";
  String penniVal2 = "0.00";
  String nickeVal2 = "0.00";
  String dimesVal2 = "0.00";
  String quartVal2 = "0.00";
  String onesVal2 = "0.00";
  String fiveVal2 = "0.00";
  String tensVal2 = "0.00";
  String twenVal2 = "0.00";
  String extraVal = "0.00";
  String extraVal2 = "0.00";
  String total = "0.00";
  String total2 = "0.00";
  String cashSalesVal = "0.00";
  String cashSalesVal2 = "0.00";
  String totalAfterCS = "0.00";
  String totalAfterCS2 = "0.00";
  
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
    extra.dispose();
    extra2.dispose();
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
        case 16:
          extraVal = textController;
          break;
        case 17:
          extraVal2 = textController;
          break;
      }

      total = findSum(penniVal, nickeVal, dimesVal, quartVal, onesVal, fiveVal, 
        tensVal, twenVal, extraVal).toStringAsFixed(2);
      total2 = findSum(penniVal2, nickeVal2, dimesVal2, quartVal2, onesVal2, 
        fiveVal2, tensVal2, twenVal2, extraVal2).toStringAsFixed(2);

      calcCashSales1(total, cashSales.text);
      calcCashSales2(total2, cashSales2.text);
    });
  }

  void calcCashSales1(String tCashVal, String csInput){
    String cleanedCsInput = csInput.replaceAll(RegExp(r'[^\d.]'), ''); 

    setState(() {
      totalAfterCS = (double.parse(tCashVal) - double.parse(cleanedCsInput)).toStringAsFixed(2);
    });
  }

  void calcCashSales2(String tCashVal, String csInput){
    String cleanedCsInput = csInput.replaceAll(RegExp(r'[^\d.]'), ''); 

    setState(() {
      totalAfterCS2 = (double.parse(tCashVal) - double.parse(cleanedCsInput)).toStringAsFixed(2);
    });
  }

  void updateList1() {
    setState(() {
      future1 = getReg1();
    });
  }

  void updateList2() {
    setState(() {
      future2 = getReg2();
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
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
        home: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            bottom: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(
                  text: "Register 1",
                  icon: Icon(Icons.one_k)
                ),
                Tab(
                  text: "Register 2",
                  icon: Icon(Icons.two_k)
                ),
                Tab(
                  text: "Register 1 Log",
                  icon: Icon(Icons.history)
                ),
                Tab(
                  text: "Register 2 Log",
                  icon: Icon(Icons.history)
                ),
              ],
            ),
            title: const Text('Register Calculator'),
          ),
          body: Builder(
            builder: (BuildContext context){
            return TabBarView(
              controller: _tabController,
              children: [
                SingleChildScrollView(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Flexible(
                              flex: 1,
                              child: Text("Cash Sales:"),
                            ),
                            Expanded(
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: '0.00',
                                ),
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  CurrencyTextInputFormatter(
                                    locale: 'en_US',
                                    symbol:'\$',
                                    decimalDigits: 2,
                                  ),
                                ],
                                controller: cashSales,
                                onChanged: (String value) async {
                                  if (cashSales.text == ""){
                                    calcCashSales1(total, "0");
                                  } else {
                                    calcCashSales1(total, cashSales.text.substring(1));
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Flexible(
                              flex: 1,
                              child: Text("Quarters: "),
                            ),
                            Expanded(
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: '25¢',
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
                              flex: 1,
                              child: Text("Result: \$$quartVal"),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Flexible(
                              flex: 1,
                              child: Text("Dimes: "),
                            ),
                            Expanded(
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: '10¢',
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
                              flex: 1,
                              child: Text("Result: \$$dimesVal"),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Flexible(
                              flex: 1,
                              child: Text("Nickels: "),
                            ),
                            Expanded(
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: '5¢',
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
                              flex: 1,
                              child: Text("Result: \$$nickeVal"),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Flexible(
                              flex: 1,
                              child: Text("Pennies: "),
                            ),
                            Expanded(
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: '1¢',
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
                              flex: 1,
                              child: Text("Result: \$$penniVal"),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Flexible(
                              flex: 1,
                              child: Text("Twenties: "),
                            ),
                            Expanded(
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: '\$20',
                                ),
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                controller: twents,
                                onChanged: (String value) async {
                                  if (twents.text == ""){
                                    updateText("0", 7);
                                  } else {
                                    updateText(twents.text, 7);
                                  }
                                },
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: Text("Result: \$$twenVal"),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Flexible(
                              flex: 1,
                              child: Text("Tens: "),
                            ),
                            Expanded(
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: '\$10',
                                ),
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                controller: tens,
                                onChanged: (String value) async {
                                  if (tens.text == ""){
                                    updateText("0", 6);
                                  } else {
                                    updateText(tens.text, 6);
                                  }
                                },
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: Text("Result: \$$tensVal"),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Flexible(
                              flex: 1,
                              child: Text("Fives: "),
                            ),
                            Expanded(
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: '\$5',
                                ),
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                controller: fives,
                                onChanged: (String value) async {
                                  if (fives.text == ""){
                                    updateText("0", 5);
                                  } else {
                                    updateText(fives.text, 5);
                                  }
                                },
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: Text("Result: \$$fiveVal"),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Flexible(
                              flex: 1,
                              child: Text("Ones: "),
                            ),
                            Expanded(
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: '\$1',
                                ),
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                controller: ones,
                                onChanged: (String value) async {
                                  if (ones.text == ""){
                                    updateText("0", 4);
                                  } else {
                                    updateText(ones.text, 4);
                                  }
                                },
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: Text("Result: \$$onesVal"),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Flexible(
                              flex: 1,
                              child: Text("Extra Money: "),
                            ),
                            Expanded(
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: '\$ Extras',
                                ),
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                controller: extra,
                                onChanged: (String value) async {
                                  if (extra.text == ""){
                                    updateText("0", 16);
                                  } else {
                                    updateText(extra.text, 16);
                                  }
                                },
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: Text("Result: \$$extraVal"),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Flexible(
                              child: Text("Total: \$$total")
                            ),
                            Flexible(
                              child: Text("After Cash Sales: \$$totalAfterCS")
                            )
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            try {
                              checkReg1(penniVal, nickeVal, dimesVal, quartVal, 
                                onesVal, fiveVal, tensVal, twenVal, extraVal, cashSales.text);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Updated Register 1 Log"),
                                ),
                              );
                              updateList1();
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("An Error Has Occurred"),
                                ),
                              );
                            }
                          },
                          child: const Text("Submit Change"),
                        ),
                      ],
                    ),
                  ),
                ),
                // other tab
                SingleChildScrollView(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Flexible(
                              flex: 1,
                              child: Text("Cash Sales:"),
                            ),
                            Expanded(
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: '0.00',
                                ),
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  CurrencyTextInputFormatter(
                                    locale: 'en_US',
                                    symbol:'\$',
                                    decimalDigits: 2,
                                  ),
                                ],
                                controller: cashSales2,
                                onChanged: (String value) async {
                                  if (cashSales2.text == ""){
                                    calcCashSales2(total, "0");
                                  } else {
                                    calcCashSales2(total, cashSales2.text.substring(1));
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Flexible(
                              flex: 1,
                              child: Text("Quarters: "),
                            ),
                            Expanded(
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: '25¢',
                                ),
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                controller: quart2,
                                onChanged: (String value) async {
                                  if (quart2.text == ""){
                                    updateText("0", 11);
                                  } else {
                                    updateText(quart2.text, 11);
                                  }
                                },
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: Text("Result: \$$quartVal2"),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Flexible(
                              flex: 1,
                              child: Text("Dimes: "),
                            ),
                            Expanded(
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: '10¢',
                                ),
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                controller: dimes2,
                                onChanged: (String value) async {
                                  if (dimes2.text == ""){
                                    updateText("0", 10);
                                  } else {
                                    updateText(dimes2.text, 10);
                                  }
                                },
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: Text("Result: \$$dimesVal2"),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Flexible(
                              flex: 1,
                              child: Text("Nickels: "),
                            ),
                            Expanded(
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: '5¢',
                                ),
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                controller: nickl2,
                                onChanged: (String value) async {
                                  if (nickl2.text == ""){
                                    updateText("0", 9);
                                  } else {
                                    updateText(nickl2.text, 9);
                                  }
                                },
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: Text("Result: \$$nickeVal2"),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Flexible(
                              flex: 1,
                              child: Text("Pennies: "),
                            ),
                            Expanded(
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: '1¢',
                                ),
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                controller: penni2,
                                onChanged: (String value) async {
                                  if (penni2.text == ""){
                                    updateText("0", 8);
                                  } else {
                                    updateText(penni2.text, 8);
                                  }
                                },
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: Text("Result: \$$penniVal2"),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Flexible(
                              flex: 1,
                              child: Text("Twenties: "),
                            ),
                            Expanded(
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: '\$20',
                                ),
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                controller: twent2,
                                onChanged: (String value) async {
                                  if (twent2.text == ""){
                                    updateText("0", 15);
                                  } else {
                                    updateText(twent2.text, 15);
                                  }
                                },
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: Text("Result: \$$twenVal2"),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Flexible(
                              flex: 1,
                              child: Text("Tens: "),
                            ),
                            Expanded(
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: '\$10',
                                ),
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                controller: tens2,
                                onChanged: (String value) async {
                                  if (tens2.text == ""){
                                    updateText("0", 14);
                                  } else {
                                    updateText(tens2.text, 14);
                                  }
                                },
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: Text("Result: \$$tensVal2"),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Flexible(
                              flex: 1,
                              child: Text("Fives: "),
                            ),
                            Expanded(
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: '\$5',
                                ),
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                controller: fives2,
                                onChanged: (String value) async {
                                  if (fives2.text == ""){
                                    updateText("0", 13);
                                  } else {
                                    updateText(fives2.text, 13);
                                  }
                                },
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: Text("Result: \$$fiveVal2"),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Flexible(
                              flex: 1,
                              child: Text("Ones: "),
                            ),
                            Expanded(
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: '\$1',
                                ),
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                controller: ones2,
                                onChanged: (String value) async {
                                  if (ones2.text == ""){
                                    updateText("0", 12);
                                  } else {
                                    updateText(ones2.text, 12);
                                  }
                                },
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: Text("Result: \$$onesVal2"),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Flexible(
                              flex: 1,
                              child: Text("Extra Money: "),
                            ),
                            Expanded(
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: '\$ Extras',
                                ),
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                controller: extra2,
                                onChanged: (String value) async {
                                  if (extra2.text == ""){
                                    updateText("0", 17);
                                  } else {
                                    updateText(extra2.text, 17);
                                  }
                                },
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: Text("Result: \$$extraVal2"),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Flexible(
                              child: Text("Total: \$$total2")
                            ),
                            Flexible(
                              child: Text("After Cash Sales: \$$totalAfterCS2")
                            )
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            try {
                              checkReg2(penniVal, nickeVal, dimesVal, quartVal, 
                                onesVal, fiveVal, tensVal, twenVal, extraVal, cashSales2.text);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Updated Register 2 Log"),
                                ),
                              );
                              updateList2();
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("An Error Has Occurred"),
                                ),
                              );
                            }
                          },
                          child: const Text("Submit Change"),
                        ),
                      ],
                    ),
                  ),
                ),
                FutureBuilder<List<Map<String, dynamic>>>(
                  future: future1, 
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final reg1Data = snapshot.data!;

                    return RefreshIndicator(
                      onRefresh: () async {
                        updateList1();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Refreshed Register 1 Log"),
                          ),
                        );
                      },
                      child: ListView.builder(
                        itemCount: reg1Data.length,
                        itemBuilder: ((context, index) {
                          final reg1 = reg1Data[index];

                          final dateTime = DateTime.parse(reg1['dateTime']);
                          final formattedDate = '${dateTime.month}/${dateTime.day}/${dateTime.year}'
                          ' - ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}';
                          
                          return Column(
                            children: [
                              ExpansionTile(
                                title: Text(formattedDate),
                                children: [
                                  Text('Pennies: ${reg1['pennies']}'),
                                  Text('Nickels: ${reg1['nickels']}'),
                                  Text('Dimes: ${reg1['dimes']}'),
                                  Text('Quarters: ${reg1['quarters']}'),
                                  Text('Ones: ${reg1['ones']}'),
                                  Text('Fives: ${reg1['fives']}'),
                                  Text('Tens: ${reg1['tens']}'),
                                  Text('Twenties: ${reg1['twenties']}'),
                                  Text('Extra: ${reg1['extra']}'),
                                  Text('Status: ${reg1['status']}'),
                                  Text('Total: \$${reg1['total']?.toStringAsFixed(2)}'),
                                  Text('Cash Sales: \$${reg1['cashSales']?.toStringAsFixed(2)}'),
                                ],
                              ),
                            ],
                          );
                        }),
                        physics: const AlwaysScrollableScrollPhysics(),
                      ),
                    ); 
                  },
                ),
                FutureBuilder<List<Map<String, dynamic>>>(
                  future: future2, 
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final reg2Data = snapshot.data!;
                    return RefreshIndicator(
                      onRefresh: () async {
                        updateList2();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Refreshed Register 2 Log"),
                          ),
                        );
                      },
                      child: ListView.builder(
                        itemCount: reg2Data.length,
                        itemBuilder: ((context, index) {
                          final reg2 = reg2Data[index];

                          final dateTime = DateTime.parse(reg2['dateTime']);
                          final formattedDate = '${dateTime.month}/${dateTime.day}/${dateTime.year}'
                          ' - ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}';
                          

                          return Column(
                            children: [
                              ExpansionTile(
                                title: Text(formattedDate),
                                children: [
                                  Text('Pennies: ${reg2['pennies']}'),
                                  Text('Nickels: ${reg2['nickels']}'),
                                  Text('Dimes: ${reg2['dimes']}'),
                                  Text('Quarters: ${reg2['quarters']}'),
                                  Text('Ones: ${reg2['ones']}'),
                                  Text('Fives: ${reg2['fives']}'),
                                  Text('Tens: ${reg2['tens']}'),
                                  Text('Twenties: ${reg2['twenties']}'),
                                  Text('Extra: ${reg2['extra']}'),
                                  Text('Status: ${reg2['status']}'),
                                  Text('Total: \$${reg2['total']?.toStringAsFixed(2)}'),
                                  Text('Cash Sales: \$${reg2['cashSales']?.toStringAsFixed(2)}'),
                                ],
                              ),
                            ],
                          );
                        }),
                      )
                    );
                  },
                ),
              ],
            );
            },
          ),
        ),
      );
    });
  }
}