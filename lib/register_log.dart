import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RegisterLog extends StatefulWidget {
  const RegisterLog({super.key});

  @override
  State<RegisterLog> createState() => RegisterLogState();

  static void updateList() {}
}

// Get a reference to the firestore
final db = FirebaseFirestore.instance;

// Format currency used in strings
final oCcy = NumberFormat("#,##0.00", "en_US");

Future<List<Map<String, dynamic>>> getReg(String register) async {
  final Query<Map<String, dynamic>> colRef =
      db.collection(register).orderBy('Date', descending: true).limit(10);

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
              Container(
                padding: const EdgeInsets.all(8.0),
                child: SegmentedButton(
                  segments: const <ButtonSegment<String>>[
                    ButtonSegment(
                      value: "Register_1",
                      label: Text("Register 1"),
                    ),
                    ButtonSegment(
                      value: "Register_2",
                      label: Text("Register 2"),
                    ),
                  ],
                  selected: <String>{regType},
                  onSelectionChanged: (Set<String> newSelection) {
                    setState(() {
                      regType = newSelection.first;
                      updateList(regType);
                    });
                  },
                ),
              )
            ],
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                setState(() {
                  future = getReg(regType);
                });
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

                  final dateTime = reg['Date']?.toDate();
                  final formattedDate = dateTime != null
                      ? DateFormat('MM/dd/yyyy - HH:mm:ss').format(dateTime)
                      : 'Unknown Date';

                  return ExpansionTile(
                      title: Text(formattedDate),
                      childrenPadding: const EdgeInsets.only(bottom: 5.0),
                      children: [
                        DataTable(
                          columns: const [
                            DataColumn(label: Text('Denomination')),
                            DataColumn(label: Text('Amount')),
                          ],
                          rows: [
                            DataRow(
                              cells: [
                                const DataCell(Text('Quarters')),
                                DataCell(Text(
                                    '\$${oCcy.format(reg['Quarters'] ?? 0)}')),
                              ],
                            ),
                            DataRow(
                              cells: [
                                const DataCell(Text('Dimes')),
                                DataCell(Text(
                                    '\$${oCcy.format(reg['Dimes'] ?? 0)}')),
                              ],
                            ),
                            DataRow(
                              cells: [
                                const DataCell(Text('Nickels')),
                                DataCell(Text(
                                    '\$${oCcy.format(reg['Nickels'] ?? 0)}')),
                              ],
                            ),
                            DataRow(
                              cells: [
                                const DataCell(Text('Pennies')),
                                DataCell(Text(
                                    '\$${oCcy.format(reg['Pennies'] ?? 0)}')),
                              ],
                            ),
                            DataRow(
                              cells: [
                                const DataCell(Text('Twenties')),
                                DataCell(Text(
                                    '\$${oCcy.format(reg['Twenties'] ?? 0)}')),
                              ],
                            ),
                            DataRow(
                              cells: [
                                const DataCell(Text('Tens')),
                                DataCell(
                                    Text('\$${oCcy.format(reg['Tens'] ?? 0)}')),
                              ],
                            ),
                            DataRow(
                              cells: [
                                const DataCell(Text('Fives')),
                                DataCell(Text(
                                    '\$${oCcy.format(reg['Fives'] ?? 0)}')),
                              ],
                            ),
                            DataRow(
                              cells: [
                                const DataCell(Text('Ones')),
                                DataCell(
                                    Text('\$${oCcy.format(reg['Ones'] ?? 0)}')),
                              ],
                            ),
                            DataRow(
                              cells: [
                                const DataCell(Text('Extra')),
                                DataCell(Text(
                                    '\$${oCcy.format(reg['Extra'] ?? 0)}')),
                              ],
                            ),
                            DataRow(
                              cells: [
                                const DataCell(Text('Total')),
                                DataCell(Text(
                                    '\$${oCcy.format(reg['Total'] ?? 0)}')),
                              ],
                            ),
                            DataRow(
                              cells: [
                                const DataCell(Text('Cash Sales')),
                                DataCell(Text(
                                    '\$${(reg['CashSales'] ?? 0).toStringAsFixed(2)}')),
                              ],
                            ),
                          ],
                        ),
                      ]);
                }),
                physics: const AlwaysScrollableScrollPhysics(),
              ),
            ),
          )
        ]);
      },
    );
  }
}
