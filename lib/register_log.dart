import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterLog extends StatefulWidget {
  const RegisterLog({super.key});

  @override
  State<RegisterLog> createState() => RegisterLogState();
}

// Get a reference your Supabase client
final supabase = Supabase.instance.client;

// Format currency used in strings
final oCcy = NumberFormat("#,##0.00", "en_US");

// Input: Integer to select data from
// NOTE: To be changed to Firestore Collection
Future<List<Map<String, dynamic>>> getReg1() async {
  final response = await supabase
      .from('register1')
      .select()
      .order('dateTime', ascending: false)
      .range(0, 9);
  return response;
}

class RegisterLogState extends State<RegisterLog> {

  var future1 = getReg1();

  void updateList1() {
    setState(() {
      future1 = getReg1();
    });
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
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
              final formattedDate =
                  '${dateTime.month}/${dateTime.day}/${dateTime.year}'
                  ' - ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}';

              return Column(
                children: [
                  ExpansionTile(
                    title: Text(formattedDate),
                    children: [
                      Text(
                          'Pennies: \$${oCcy.format(reg1['pennies'])}'),
                      Text(
                          'Nickels: \$${oCcy.format(reg1['nickels'])}'),
                      Text(
                          'Dimes: \$${oCcy.format(reg1['dimes'])}'),
                      Text(
                          'Quarters: \$${oCcy.format(reg1['quarters'])}'),
                      Text(
                          'Ones: \$${oCcy.format(reg1['ones'])}'),
                      Text(
                          'Fives: \$${oCcy.format(reg1['fives'])}'),
                      Text(
                          'Tens: \$${oCcy.format(reg1['tens'])}'),
                      Text(
                          'Twenties: \$${oCcy.format(reg1['twenties'])}'),
                      Text(
                          'Extra: \$${oCcy.format(reg1['extra'])}'),
                      Text('Status: ${reg1['status']}'),
                      Text(
                          'Total: \$${reg1['total']?.toStringAsFixed(2)}'),
                      Text(
                          'Cash Sales: \$${reg1['cashSales']?.toStringAsFixed(2)}'),
                    ],
                  ),
                ],
              );
            }),
            physics: const AlwaysScrollableScrollPhysics(),
          ),
        );
      },
    );
  }
}