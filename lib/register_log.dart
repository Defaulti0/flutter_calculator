import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterLog extends StatefulWidget {
  const RegisterLog({super.key});

  @override
  State<RegisterLog> createState() => RegisterLogState();
}

// Get a reference to the firestore
final db = FirebaseFirestore.instance;

// Format currency used in strings
final oCcy = NumberFormat("#,##0.00", "en_US");

Future<List<Map<String, dynamic>>> getReg(String register) async {
  final Query<Map<String, dynamic>> colRef = db.collection(register).limit(10);

  final snapshot = await colRef.get();
  // Parse documents
  final docs = snapshot.docs.map((doc) => doc.data()).toList();

  return docs;
}

class RegisterLogState extends State<RegisterLog> {
  String regType = "Register_1";
  Future<List<Map<String, dynamic>>>? future;

  @override
  void initState() {
    super.initState();
    future = getReg(regType);
  }

  void updateList(String reg1) {
    setState(() {
      regType = reg1;
      future = getReg(regType);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: future,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final regData = snapshot.data!;

        return Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DropdownButton<String>(
                items: const [
                  DropdownMenuItem(
                    value: "Register_1",
                    child: Text("Register 1"),
                  ),
                  DropdownMenuItem(
                    value: "Register_2",
                    child: Text("Register 2"),
                  ),
                ],
                value: regType,
                onChanged: (value) {
                  setState(() {
                    regType = value!;
                    updateList(regType);
                  });
                },
              ),
            ],
          ),
          RefreshIndicator(
            onRefresh: () async {
              future = getReg(regType);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Refreshed Register Log"),
                ),
              );
            },
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: regData.length,
              itemBuilder: ((context, index) {
                final reg = regData[index];

                final dateTime = reg['Date'].toDate();
                final formattedDate =
                    DateFormat('MM/dd/yyyy - HH:mm:ss').format(dateTime);

                return ExpansionTile(
                  title: Text(formattedDate),
                  children: [
                    Text('Pennies: \$${oCcy.format(reg['Pennies'])}'),
                    Text('Nickels: \$${oCcy.format(reg['Nickels'])}'),
                    Text('Dimes: \$${oCcy.format(reg['Dimes'])}'),
                    Text('Quarters: \$${oCcy.format(reg['Quarters'])}'),
                    Text('Ones: \$${oCcy.format(reg['Ones'])}'),
                    Text('Fives: \$${oCcy.format(reg['Fives'])}'),
                    Text('Tens: \$${oCcy.format(reg['Tens'])}'),
                    Text('Twenties: \$${oCcy.format(reg['Twenties'])}'),
                    Text('Extra: \$${oCcy.format(reg['Extra'])}'),
                    Text('Status: ${reg['Status']}'),
                    Text('Total: \$${reg['Total']?.toStringAsFixed(2)}'),
                    Text(
                        'Cash Sales: \$${reg['CashSales']?.toStringAsFixed(2)}'),
                  ],
                );
              }),
              physics: const AlwaysScrollableScrollPhysics(),
            ),
          ),
        ]);
      },
    );
  }
}
