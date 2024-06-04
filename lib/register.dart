import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:register_calculator/register_log.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';


class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => RegisterState();
}

//NOTE: To be replaced with Firestore
// Get a reference your Supabase client
final supabase = Supabase.instance.client;

// Need to condense into a single function(?)
double calcPenny(int inputPenny) {
  return inputPenny * 0.01;
}

double calcNickel(int inputNickel) {
  return inputNickel * 0.05;
}

double calcDime(int inputDime) {
  return inputDime * 0.10;
}

double calcQuarter(int inputQuarter) {
  return inputQuarter * 0.25;
}

double calcOne(int inputOne) {
  return inputOne * 1;
}

double calcFive(int inputFive) {
  return inputFive * 5;
}

double calcTen(int inputTen) {
  return inputTen * 10;
}

double calcTwenty(int inputTwenty) {
  return inputTwenty * 20;
}

double findSum(
    String penniVal,
    String nickeVal,
    String dimesVal,
    String quartVal,
    String onesVal,
    String fiveVal,
    String tensVal,
    String twenVal,
    String extraVal) {

  return double.parse(penniVal) +
      double.parse(nickeVal) +
      double.parse(dimesVal) +
      double.parse(quartVal) +
      double.parse(onesVal) +
      double.parse(fiveVal) +
      double.parse(tensVal) +
      double.parse(twenVal) +
      double.parse(extraVal);
}

void checkReg1(
    String penniVal,
    String nickeVal,
    String dimesVal,
    String quartVal,
    String onesVal,
    String fiveVal,
    String tensVal,
    String twenVal,
    String extraVal,
    String cSales) {
  double regConst = 317.50;
  String isExact = "";
  double sum = findSum(penniVal, nickeVal, dimesVal, quartVal, onesVal, fiveVal,
      tensVal, twenVal, extraVal);

  if (sum > regConst) {
    isExact = "Over";
  } else if (sum < regConst) {
    isExact = "Under";
  } else {
    isExact = "Correct";
  }

  if (sum == 0){
    // do nothing
  } else {
    sendReg1(penniVal, nickeVal, dimesVal, quartVal, onesVal, fiveVal, tensVal,
        twenVal, extraVal, isExact, sum, cSales);
  }

}

Future<void> sendReg1(
    String penniVal, String nickeVal, String dimesVal, String quartVal,
    String onesVal, String fiveVal, String tensVal, String twenVal,
    String extraVal, String isExact, double sum, String cashSalesVal
    ) async {
  await supabase.from('register1').insert({
    'dateTime': DateTime.now().toIso8601String(),
    'pennies': double.parse(penniVal),
    'nickels': double.parse(nickeVal),
    'dimes': double.parse(dimesVal),
    'quarters': double.parse(quartVal),
    'ones': double.parse(onesVal),
    'fives': double.parse(fiveVal),
    'tens': double.parse(tensVal),
    'twenties': double.parse(twenVal),
    'extra': double.parse(extraVal),
    'status': isExact,
    'total': sum,
    'cashSales': double.parse(cashSalesVal.substring(1)),
  });
}

class RegisterState extends State<Register> with SingleTickerProviderStateMixin{
  String penniVal = "0.00";
  String nickeVal = "0.00";
  String dimesVal = "0.00";
  String quartVal = "0.00";
  String onesVal = "0.00";
  String fiveVal = "0.00";
  String tensVal = "0.00";
  String twenVal = "0.00";
  String extraVal = "0.00";
  String total = "0.00";
  String cashSalesVal = "0.00";
  String totalAfterCS = "0.00";

  void calcCashSales1(String tCashVal, String csInput) {
    String cleanedCsInput = csInput.replaceAll(RegExp(r'[^\d.]'), '');

    setState(() {
      totalAfterCS = (double.parse(tCashVal) - double.parse(cleanedCsInput))
          .toStringAsFixed(2);
    });
  }

  var future1 = getReg1();

  late TextEditingController penni = TextEditingController();
  late TextEditingController dimes = TextEditingController();
  late TextEditingController nickl = TextEditingController();
  late TextEditingController quart = TextEditingController();
  late TextEditingController ones = TextEditingController();
  late TextEditingController fives = TextEditingController();
  late TextEditingController tens = TextEditingController();
  late TextEditingController twents = TextEditingController();
  late TextEditingController extra = TextEditingController(text: "\$0");
  late TextEditingController cashSales = TextEditingController(text: "\$0");

  @override
  void dispose() {
    penni.dispose();
    dimes.dispose();
    nickl.dispose();
    quart.dispose();
    ones.dispose();
    fives.dispose();
    tens.dispose();
    twents.dispose();
    extra.dispose();
    super.dispose();
  }

  void updateText(String textController, int currType) {
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
        case 16:
          extraVal = textController;
          break;
      }

      total = findSum(penniVal, nickeVal, dimesVal, quartVal, onesVal, fiveVal,
              tensVal, twenVal, extraVal)
          .toStringAsFixed(2);

      calcCashSales1(total, cashSales.text);
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
                        symbol: '\$',
                        decimalDigits: 2,
                      ),
                    ],
                    controller: cashSales,
                    onChanged: (String value) async {
                      if (cashSales.text == "") {
                        calcCashSales1(total, "0");
                      } else {
                        calcCashSales1(
                            total, cashSales.text.substring(1));
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
                      if (quart.text == "") {
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
                      if (dimes.text == "") {
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
                      if (nickl.text == "") {
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
                      if (penni.text == "") {
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
                      if (twents.text == "") {
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
                      if (tens.text == "") {
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
                      if (fives.text == "") {
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
                      if (ones.text == "") {
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
                      hintText: '0.00',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      CurrencyTextInputFormatter(
                        locale: 'en_US',
                        symbol: '\$',
                        decimalDigits: 2,
                      ),
                    ],
                    controller: extra,
                    onChanged: (String value) async {
                      if (extra.text == "") {
                        updateText("0", 16);
                      } else {
                        updateText(extra.text.substring(1), 16);
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
                Flexible(child: Text("Total: \$$total")),
                Flexible(
                    child:
                        Text("After Cash Sales: \$$totalAfterCS"))
              ],
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  checkReg1(
                      penniVal,
                      nickeVal,
                      dimesVal,
                      quartVal,
                      onesVal,
                      fiveVal,
                      tensVal,
                      twenVal,
                      extraVal,
                      cashSales.text);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Updated Register 1 Log"),
                    ),
                  );
                  RegisterLogState().updateList1();
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
    );
  }
}
