import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterLog extends StatefulWidget {
  const RegisterLog({super.key});

  @override
  State<RegisterLog> createState() => RegisterLogState();
}

// Get a reference your Supabase client
// final supabase = Supabase.instance.client;

// Get a reference to the firestore
final db = FirebaseFirestore.instance;

// Format currency used in strings
final oCcy = NumberFormat("#,##0.00", "en_US");

// Input: Integer to select data from
// NOTE: To be changed to Firestore Collection
Future<List<Map<String, dynamic>>> getReg(bool reg1) async {
  final regCol, regData;
  if (!reg1) {
    regCol = db.collection("Register_2");
  } else {
    regCol = db.collection("Register_1");
  }

  final querySnap = await regCol.limit(10).get();
  debugPrint(querySnap.doc.id);

  return querySnap;
  // final response = await supabase
  //     .from('register1')
  //     .select()
  //     .order('dateTime', ascending: false)
  //     .range(0, 9);
  // return response;
}

class RegisterLogState extends State<RegisterLog> {
  var future = getReg(false);

  void updateList(bool reg1) {
    if (!reg1) {
      setState(() {
        future = getReg(false);
      });
    } else {
      setState(() {
        future = getReg(true);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: db.collection('Register_1').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }

        final documents = snapshot.data!.docs;

        return ListView.builder(
          itemCount: documents.length,
          itemBuilder: (context, index) {
            final docData = documents[index].data();

            return ExpansionTile(
              title: Text(docData.toString()),
              children: [
                ListTile(
                  title: Text(docData.toString()),
                ),
                // Add more ListTile or custom widgets for detailed information
              ],
            );
          },
        );
      },
    );
    // FutureBuilder<List<Map<String, dynamic>>>(
    //   future: future,
    //   builder: (context, snapshot) {
    //     if (!snapshot.hasData) {
    //       return const Center(child: CircularProgressIndicator());
    //     }
    //     final reg1Data = snapshot.data!;

    //     return RefreshIndicator(
    //       onRefresh: () async {
    //         // this needs to be based on a function
    //         updateList(false);
    //         ScaffoldMessenger.of(context).showSnackBar(
    //           const SnackBar(
    //             content: Text("Refreshed Register 1 Log"),
    //           ),
    //         );
    //       },
    //       child: ListView.builder(
    //         itemCount: reg1Data.length,
    //         itemBuilder: ((context, index) {
    //           final reg1 = reg1Data[index];

    //           final dateTime = DateTime.parse(reg1['dateTime']);
    //           final formattedDate =
    //               '${dateTime.month}/${dateTime.day}/${dateTime.year}'
    //               ' - ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}';

    //           return Column(
    //             children: [
    //               ExpansionTile(
    //                 title: Text(formattedDate),
    //                 children: [
    //                   Text('Pennies: \$${oCcy.format(reg1['pennies'])}'),
    //                   Text('Nickels: \$${oCcy.format(reg1['nickels'])}'),
    //                   Text('Dimes: \$${oCcy.format(reg1['dimes'])}'),
    //                   Text('Quarters: \$${oCcy.format(reg1['quarters'])}'),
    //                   Text('Ones: \$${oCcy.format(reg1['ones'])}'),
    //                   Text('Fives: \$${oCcy.format(reg1['fives'])}'),
    //                   Text('Tens: \$${oCcy.format(reg1['tens'])}'),
    //                   Text('Twenties: \$${oCcy.format(reg1['twenties'])}'),
    //                   Text('Extra: \$${oCcy.format(reg1['extra'])}'),
    //                   Text('Status: ${reg1['status']}'),
    //                   Text('Total: \$${reg1['total']?.toStringAsFixed(2)}'),
    //                   Text(
    //                       'Cash Sales: \$${reg1['cashSales']?.toStringAsFixed(2)}'),
    //                 ],
    //               ),
    //             ],
    //           );
    //         }),
    //         physics: const AlwaysScrollableScrollPhysics(),
    //       ),
    //     );
    //   },
    // );
  }
}
