import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:register_calculator/register_log.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:intl/intl.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => RegisterState();
}

//NOTE: To be replaced with Firestore
// Get a reference your Supabase client
final supabase = Supabase.instance.client;

NumberFormat doubleFormat =
    NumberFormat.decimalPatternDigits(locale: 'en_US', decimalDigits: 2);

double findSum(List registerList) {
  var sum = 0.0;
  registerList[10] = 0.0;

  for (var i = 0; i < registerList.length - 1; i++) {
    sum += registerList[i];
  }

  return sum;
}

void checkReg(List registerList, String cashSales, bool isReg1) {
  double regConst = 317.50;
  String isExact = "";
  double sum = findSum(registerList);

  if (sum > regConst) {
    isExact = "Over";
  } else if (sum < regConst) {
    isExact = "Under";
  } else {
    isExact = "Correct";
  }

  if (sum != 0) {
    if (!isReg1) {
      sendReg(registerList, isExact, sum, cashSales, isReg1);
    } else {
      sendReg(registerList, isExact, sum, cashSales, isReg1);
    }
  }
}

Future<void> sendReg(List registerList, String isExact, double totalSum,
    String cashSales, bool isReg1) async {
  if (!isReg1) {
    await supabase.from('register2').insert({
      'Date': DateTime.now().toIso8601String(),
      'Pennies': registerList[7],
      'Nickels': registerList[5],
      'Dimes': registerList[6],
      'Quarters': registerList[4],
      'Ones': registerList[3],
      'Fives': registerList[2],
      'Tens': registerList[1],
      'Twenties': registerList[0],
      'Extra': registerList[8],
      'Status': isExact,
      'Total': totalSum,
      'CashSales': double.parse(cashSales.substring(1)),
    });
  } else {
    await supabase.from('register1').insert({
      'Date': DateTime.now().toIso8601String(),
      'Pennies': registerList[7],
      'Nickels': registerList[5],
      'Dimes': registerList[6],
      'Quarters': registerList[4],
      'Ones': registerList[3],
      'Fives': registerList[2],
      'Tens': registerList[1],
      'Twenties': registerList[0],
      'Extra': registerList[8],
      'Status': isExact,
      'Total': totalSum,
      'CashSales': double.parse(cashSales.substring(1)),
    });
  }
}

class RegisterState extends State<Register>
    with SingleTickerProviderStateMixin {
  /*
    Initial list which contains float values for individual denominations,
      the list is as follows:
    0: twenties
    1: tens
    2: fives
    3: ones
    4: quarters
    5: nickels
    6: dimes
    7: pennies
    8: extra money
    9: cash sales
    10: total value (sum of 0-8)
    11: total value after cash sales (10 - 9)
  */
  var regList = [
    0.00,
    0.00,
    0.00,
    0.00,
    0.00,
    0.00,
    0.00,
    0.00,
    0.00,
    0.00,
    0.00,
    0.00,
  ];

  void calcCashSales1(double tCashVal, String csInput) {
    String cleanedCsInput = csInput.replaceAll(RegExp(r'[^\d.]'), '');

    setState(() {
      regList[11] = (tCashVal - double.parse(cleanedCsInput));
    });
  }

  var future1 = getReg1();

  // Want to condense this or at least somehow make it more dynamic?
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

  late List<TextEditingController> textEditList = [
    TextEditingController(text: "\$0"),
  ];

  @override
  void dispose() {
    for (var i = 0; i < textEditList.length - 1; i++) {
      textEditList[i].dispose();
    }
    super.dispose();
  }

  void updateText(String textController, int currType) {
    setState(() {
      switch (currType) {
        case 0:
          regList[7] = double.parse(textController) * 0.01;
          break;
        case 1:
          regList[5] = double.parse(textController) * 0.05;
          break;
        case 2:
          regList[6] = double.parse(textController) * 0.10;
          break;
        case 3:
          regList[4] = double.parse(textController) * 0.25;
          break;
        case 4:
          regList[3] = double.parse(textController) * 1;
          break;
        case 5:
          regList[2] = double.parse(textController) * 5;
          break;
        case 6:
          regList[1] = double.parse(textController) * 10;
          break;
        case 7:
          regList[0] = double.parse(textController) * 20;
          break;
        case 16:
          String cleanedExInput =
              textController.replaceAll(RegExp(r'[^\d.]'), '');
          regList[8] = double.parse(cleanedExInput);
          break;
      }

      regList[10] = findSum(regList);

      calcCashSales1(regList[10], cashSales.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Text("data"),
                Text("data22"),
              ],
            ),
            Column(
              children: [
                TextFormField(
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
                      calcCashSales1(regList[10], "0");
                    } else {
                      calcCashSales1(regList[10], cashSales.text.substring(1));
                    }
                  },
                ),
                TextFormField(
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
                      calcCashSales1(regList[10], "0");
                    } else {
                      calcCashSales1(regList[10], cashSales.text.substring(1));
                    }
                  },
                ),
              ],
            ),
          ],
        ),

        // child: Column(
        //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //   crossAxisAlignment: CrossAxisAlignment.center,
        //   children: [
        //     Row(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: [
        //         const Flexible(
        //           flex: 2,
        //           child: Text("Cash Sales:"),
        //         ),
        //         const SizedBox(
        //           width: 20,
        //         ),
        //         Flexible(
        //           flex: 1,
        //           child: TextFormField(
        //             decoration: const InputDecoration(
        //               border: OutlineInputBorder(),
        //               hintText: '0.00',
        //             ),
        //             keyboardType: TextInputType.number,
        //             inputFormatters: <TextInputFormatter>[
        //               CurrencyTextInputFormatter(
        //                 locale: 'en_US',
        //                 symbol: '\$',
        //                 decimalDigits: 2,
        //               ),
        //             ],
        //             controller: cashSales,
        //             onChanged: (String value) async {
        //               if (cashSales.text == "") {
        //                 calcCashSales1(regList[10], "0");
        //               } else {
        //                 calcCashSales1(
        //                     regList[10], cashSales.text.substring(1));
        //               }
        //             },
        //           ),
        //         ),
        //       ],
        //     ),
        //     Row(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: [
        //         const Flexible(
        //           flex: 2,
        //           child: Text("Quarters: "),
        //         ),
        //         const SizedBox(
        //           width: 20,
        //         ),
        //         Flexible(
        //           flex: 1,
        //           child: TextFormField(
        //             decoration: const InputDecoration(
        //               border: OutlineInputBorder(),
        //               hintText: '25¢',
        //             ),
        //             keyboardType: TextInputType.number,
        //             inputFormatters: <TextInputFormatter>[
        //               FilteringTextInputFormatter.digitsOnly
        //             ],
        //             controller: quart,
        //             onChanged: (String value) async {
        //               if (quart.text == "") {
        //                 updateText("0", 3);
        //               } else {
        //                 updateText(quart.text, 3);
        //               }
        //             },
        //           ),
        //         ),
        //       ],
        //     ),
        //     Row(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: [
        //         const Flexible(
        //           flex: 2,
        //           child: Text("Dimes: "),
        //         ),
        //         const SizedBox(
        //           width: 20,
        //         ),
        //         Flexible(
        //           flex: 1,
        //           child: TextFormField(
        //             decoration: const InputDecoration(
        //               border: OutlineInputBorder(),
        //               hintText: '10¢',
        //             ),
        //             keyboardType: TextInputType.number,
        //             inputFormatters: <TextInputFormatter>[
        //               FilteringTextInputFormatter.digitsOnly
        //             ],
        //             controller: dimes,
        //             onChanged: (String value) async {
        //               if (dimes.text == "") {
        //                 updateText("0", 2);
        //               } else {
        //                 updateText(dimes.text, 2);
        //               }
        //             },
        //           ),
        //         ),
        //       ],
        //     ),
        //     Row(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: [
        //         const Flexible(
        //           flex: 2,
        //           child: Text("Nickels: "),
        //         ),
        //         const SizedBox(
        //           width: 20,
        //         ),
        //         Flexible(
        //           flex: 1,
        //           child: TextFormField(
        //             decoration: const InputDecoration(
        //               border: OutlineInputBorder(),
        //               hintText: '5¢',
        //             ),
        //             keyboardType: TextInputType.number,
        //             inputFormatters: <TextInputFormatter>[
        //               FilteringTextInputFormatter.digitsOnly
        //             ],
        //             controller: nickl,
        //             onChanged: (String value) async {
        //               if (nickl.text == "") {
        //                 updateText("0", 1);
        //               } else {
        //                 updateText(nickl.text, 1);
        //               }
        //             },
        //           ),
        //         ),
        //       ],
        //     ),
        //     Row(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: [
        //         const Flexible(
        //           flex: 2,
        //           child: Text("Pennies: "),
        //         ),
        //         const SizedBox(
        //           width: 20,
        //         ),
        //         Flexible(
        //           flex: 1,
        //           child: TextFormField(
        //             decoration: const InputDecoration(
        //               border: OutlineInputBorder(),
        //               hintText: '1¢',
        //             ),
        //             keyboardType: TextInputType.number,
        //             inputFormatters: <TextInputFormatter>[
        //               FilteringTextInputFormatter.digitsOnly
        //             ],
        //             controller: penni,
        //             onChanged: (String value) async {
        //               if (penni.text == "") {
        //                 updateText("0", 0);
        //               } else {
        //                 updateText(penni.text, 0);
        //               }
        //             },
        //           ),
        //         ),
        //       ],
        //     ),
        //     Row(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: [
        //         const Flexible(
        //           flex: 2,
        //           child: Text("Twenties: "),
        //         ),
        //         const SizedBox(
        //           width: 20,
        //         ),
        //         Flexible(
        //           flex: 1,
        //           child: TextFormField(
        //             decoration: const InputDecoration(
        //               border: OutlineInputBorder(),
        //               hintText: '\$20',
        //             ),
        //             keyboardType: TextInputType.number,
        //             inputFormatters: <TextInputFormatter>[
        //               FilteringTextInputFormatter.digitsOnly
        //             ],
        //             controller: twents,
        //             onChanged: (String value) async {
        //               if (twents.text == "") {
        //                 updateText("0", 7);
        //               } else {
        //                 updateText(twents.text, 7);
        //               }
        //             },
        //           ),
        //         ),
        //       ],
        //     ),
        //     Row(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: [
        //         const Flexible(
        //           flex: 2,
        //           child: Text("Tens: "),
        //         ),
        //         const SizedBox(
        //           width: 20,
        //         ),
        //         Flexible(
        //           flex: 1,
        //           child: TextFormField(
        //             decoration: const InputDecoration(
        //               border: OutlineInputBorder(),
        //               hintText: '\$10',
        //             ),
        //             keyboardType: TextInputType.number,
        //             inputFormatters: <TextInputFormatter>[
        //               FilteringTextInputFormatter.digitsOnly
        //             ],
        //             controller: tens,
        //             onChanged: (String value) async {
        //               if (tens.text == "") {
        //                 updateText("0", 6);
        //               } else {
        //                 updateText(tens.text, 6);
        //               }
        //             },
        //           ),
        //         ),
        //       ],
        //     ),
        //     Row(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: [
        //         const Flexible(
        //           flex: 2,
        //           child: Text("Fives: "),
        //         ),
        //         const SizedBox(
        //           width: 20,
        //         ),
        //         Flexible(
        //           flex: 1,
        //           child: TextFormField(
        //             decoration: const InputDecoration(
        //               border: OutlineInputBorder(),
        //               hintText: '\$5',
        //             ),
        //             keyboardType: TextInputType.number,
        //             inputFormatters: <TextInputFormatter>[
        //               FilteringTextInputFormatter.digitsOnly
        //             ],
        //             controller: fives,
        //             onChanged: (String value) async {
        //               if (fives.text == "") {
        //                 updateText("0", 5);
        //               } else {
        //                 updateText(fives.text, 5);
        //               }
        //             },
        //           ),
        //         ),
        //       ],
        //     ),
        //     Row(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: [
        //         const Flexible(
        //           flex: 2,
        //           child: Text("Ones: "),
        //         ),
        //         const SizedBox(
        //           width: 20,
        //         ),
        //         Flexible(
        //           flex: 1,
        //           child: TextFormField(
        //             decoration: const InputDecoration(
        //               border: OutlineInputBorder(),
        //               hintText: '\$1',
        //             ),
        //             keyboardType: TextInputType.number,
        //             inputFormatters: <TextInputFormatter>[
        //               FilteringTextInputFormatter.digitsOnly
        //             ],
        //             controller: ones,
        //             onChanged: (String value) async {
        //               if (ones.text == "") {
        //                 updateText("0", 4);
        //               } else {
        //                 updateText(ones.text, 4);
        //               }
        //             },
        //           ),
        //         ),
        //       ],
        //     ),
        //     Row(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: [
        //         const Flexible(
        //           flex: 2,
        //           child: Text("Extra Money: "),
        //         ),
        //         const SizedBox(
        //           width: 20,
        //         ),
        //         Flexible(
        //           flex: 1,
        //           child: TextFormField(
        //             decoration: const InputDecoration(
        //               border: OutlineInputBorder(),
        //               hintText: '0.00',
        //             ),
        //             keyboardType: TextInputType.number,
        //             inputFormatters: <TextInputFormatter>[
        //               CurrencyTextInputFormatter(
        //                 locale: 'en_US',
        //                 symbol: '\$',
        //                 decimalDigits: 2,
        //               ),
        //             ],
        //             controller: extra,
        //             onChanged: (String value) async {
        //               if (extra.text == "") {
        //                 updateText("0", 16);
        //               } else {
        //                 updateText(extra.text.substring(1), 16);
        //               }
        //             },
        //           ),
        //         ),
        //       ],
        //     ),
        //     Row(
        //       mainAxisAlignment: MainAxisAlignment.spaceAround,
        //       children: [
        //         Flexible(
        //             child:
        //                 Text("Total: \$${doubleFormat.format(regList[10])}")),
        //         Flexible(
        //             child: Text(
        //                 "After Cash Sales: \$${doubleFormat.format(regList[11])}")),
        //       ],
        //     ),
        //     Row(
        //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //       children: [
        //         ElevatedButton(
        //           onPressed: () async {
        //             try {
        //               checkReg(regList, cashSales.text, true);
        //               ScaffoldMessenger.of(context).showSnackBar(
        //                 const SnackBar(
        //                   content: Text("Updated Register 1 Log"),
        //                 ),
        //               );
        //               RegisterLogState().updateList1();
        //             } catch (e) {
        //               ScaffoldMessenger.of(context).showSnackBar(
        //                 const SnackBar(
        //                   content: Text("An Error Has Occurred"),
        //                 ),
        //               );
        //             }
        //           },
        //           child: const Text("Submit to Reg 1"),
        //         ),
        //         ElevatedButton(
        //           onPressed: () async {
        //             try {
        //               checkReg(regList, cashSales.text, false);
        //               ScaffoldMessenger.of(context).showSnackBar(
        //                 const SnackBar(
        //                   content: Text("Updated Register 2 Log"),
        //                 ),
        //               );
        //               RegisterLogState().updateList1();
        //             } catch (e) {
        //               ScaffoldMessenger.of(context).showSnackBar(
        //                 const SnackBar(
        //                   content: Text("An Error Has Occurred"),
        //                 ),
        //               );
        //             }
        //           },
        //           child: const Text("Submit to Reg 2"),
        //         ),
        //       ],
        //     )
        //   ],
        // ),
      ),
    );
  }
}
