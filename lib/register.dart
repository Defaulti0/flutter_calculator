import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:intl/intl.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => RegisterState();
}

// Get a reference to the Firestore client
final db = FirebaseFirestore.instance;

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
  double sum = findSum(registerList);

  if (sum != 0) {
    if (!isReg1) {
      sendReg(registerList, sum, cashSales, isReg1);
    } else {
      sendReg(registerList, sum, cashSales, isReg1);
    }
  }
}

Future<void> sendReg(
    List registerList, double totalSum, String cashSales, bool isReg1) async {
  final docData = {
    'Date': DateTime.now(),
    'Pennies': registerList[7],
    'Nickels': registerList[5],
    'Dimes': registerList[6],
    'Quarters': registerList[4],
    'Ones': registerList[3],
    'Fives': registerList[2],
    'Tens': registerList[1],
    'Twenties': registerList[0],
    'Extra': registerList[8],
    'Total': totalSum,
    'CashSales': double.parse(cashSales.substring(1)),
  };
  if (!isReg1) {
    db
        .collection("Register_2")
        .add(docData)
        .then((documentSnapshot) => debugPrint(
            "\n\n\nAdded Data with ID: ${documentSnapshot.id}\n\n\n"))
        .onError(
            (error, stackTrace) => debugPrint("An error has ocurred: $error"));
  } else {
    db
        .collection("Register_1")
        .add(docData)
        .then((documentSnapshot) => debugPrint(
            "\n\n\nAdded Data with ID: ${documentSnapshot.id}\n\n\n"))
        .onError(
            (error, stackTrace) => debugPrint("An error has ocurred: $error"));
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
    10: total value (sum of 0 to 8)
    11: total value after cash sales (10 minus 9)
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

  void calcCS(double tCashVal, String csInput) {
    String cleanedCsInput = csInput.replaceAll(RegExp(r'[^\d.]'), '');

    setState(() {
      regList[11] = (tCashVal - double.parse(cleanedCsInput));
    });
  }

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

  void clear() {
    penni.clear();
    dimes.clear();
    nickl.clear();
    quart.clear();
    ones.clear();
    fives.clear();
    tens.clear();
    twents.clear();
    extra.clear();
    cashSales.clear();
    cashSales.text = "\$0.00";
  }

  void resetRegister() {
    setState(() {
      for (var i = 0; i < regList.length; i++) {
        regList[i] = 0.0;
      }
    });
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

      calcCS(regList[10], cashSales.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(2.0),
            margin: const EdgeInsets.all(5.0),
            child: Row(
              children: [
                const Expanded(
                  child: Center(
                      child: Text(
                    "Cash Sales:",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                  )),
                ),
                Expanded(
                  child: Center(
                      child: TextFormField(
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: '0.00',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      CurrencyTextInputFormatter.currency(
                        locale: 'en_US',
                        symbol: '\$',
                        decimalDigits: 2,
                      ),
                    ],
                    controller: cashSales,
                    onChanged: (String value) async {
                      if (cashSales.text == "") {
                        calcCS(regList[10], "0");
                      } else {
                        calcCS(regList[10], cashSales.text.substring(1));
                      }
                    },
                  )),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(2.0),
            margin: const EdgeInsets.all(5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Expanded(
                  child: Center(
                    child: Text(
                      "Quarters: ",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20.0),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: TextFormField(
                      textInputAction: TextInputAction.next,
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
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(2.0),
            margin: const EdgeInsets.all(5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Expanded(
                  child: Center(
                    child: Text(
                      "Dimes: ",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20.0),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: TextFormField(
                      textInputAction: TextInputAction.next,
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
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(2.0),
            margin: const EdgeInsets.all(5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Expanded(
                  child: Center(
                    child: Text(
                      "Nickels: ",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20.0),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: TextFormField(
                      textInputAction: TextInputAction.next,
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
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(2.0),
            margin: const EdgeInsets.all(5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Expanded(
                  child: Center(
                    child: Text(
                      "Pennies: ",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20.0),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: TextFormField(
                      textInputAction: TextInputAction.next,
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
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(2.0),
            margin: const EdgeInsets.all(5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Expanded(
                  child: Center(
                    child: Text(
                      "Twenties: ",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20.0),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: TextFormField(
                      textInputAction: TextInputAction.next,
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
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(2.0),
            margin: const EdgeInsets.all(5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Expanded(
                  child: Center(
                    child: Text(
                      "Tens: ",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20.0),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: TextFormField(
                      textInputAction: TextInputAction.next,
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
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(2.0),
            margin: const EdgeInsets.all(5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Expanded(
                  child: Center(
                    child: Text(
                      "Fives: ",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20.0),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: TextFormField(
                      textInputAction: TextInputAction.next,
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
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(2.0),
            margin: const EdgeInsets.all(5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Expanded(
                  child: Center(
                    child: Text(
                      "Ones: ",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20.0),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: TextFormField(
                      textInputAction: TextInputAction.next,
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
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(2.0),
            margin: const EdgeInsets.all(5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Expanded(
                  child: Center(
                      child: Text(
                    "Extra Money: ",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                  )),
                ),
                Expanded(
                  child: Center(
                    child: TextFormField(
                      textInputAction: TextInputAction.done,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: '0.00',
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        CurrencyTextInputFormatter.currency(
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
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(5.0),
            margin: const EdgeInsets.all(5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Flexible(
                    child: Text(
                  "Total: \$${doubleFormat.format(regList[10])}",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20.0),
                )),
                Flexible(
                    child: Text(
                  "After Sales: \$${doubleFormat.format(regList[11])}",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20.0),
                )),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(5.0),
            margin: const EdgeInsets.all(5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    try {
                      checkReg(regList, cashSales.text, false);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Updated Register 1 Log"),
                        ),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("An Error Has Occurred"),
                        ),
                      );
                    }
                    resetRegister();
                    clear();
                  },
                  child: const Text("Submit to Reg 1"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      checkReg(regList, cashSales.text, false);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Updated Register 2 Log"),
                        ),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("An Error Has Occurred"),
                        ),
                      );
                    }
                    resetRegister();
                    clear();
                  },
                  child: const Text("Submit to Reg 2"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
