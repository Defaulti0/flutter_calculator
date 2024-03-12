import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'supabase_client.dart';

final supabase = SupabaseClientInstance.instance;

class ListEmployees extends StatefulWidget {
  const ListEmployees({super.key});

  @override
  State<ListEmployees> createState() => _ListEmployeesState();
}

Future<List<Map<String, dynamic>>> getEmployees() async {
  // final supabase = SupabaseClientInstance.instance;

  final response = await supabase
                      .from('Employees')
                      .select();
  return response;
}

Future<void> addEmployee(TextEditingController fnControl, TextEditingController lnControl, TextEditingController empPinCont, String empType) async {
  // final supabase = SupabaseClientInstance.instance;
  await supabase
      .from('Employees')
      .insert({
        'first_name':fnControl.text, 
        'last_name':lnControl.text, 
        'employee_ID':empPinCont.text,
        'employee_type': empType,   
      });
}

Future<void> deleteEmployee(String empID) async {
  await supabase
      .from('Employees')
      .delete()
      .match({'employee_ID': empID});
}

Future<void> getEmpType() async {
  await supabase
      .from('Employee Type')
      .select();

}

class _ListEmployeesState extends State<ListEmployees> {  
  var _future = getEmployees();
  late TextEditingController fnControl = TextEditingController();
  late TextEditingController lnControl = TextEditingController();
  late TextEditingController empPinCont = TextEditingController();
  late TextEditingController employeetypecontroller = TextEditingController();
  
  
  String empType = 'Regular'; // Default value
  // get list of employee types
  // String emplType = getEmpType();

  @override
  void dispose() {
    fnControl.dispose();
    lnControl.dispose();
    empPinCont.dispose();
    employeetypecontroller.dispose();
    super.dispose();
  }

  void updateList() {
    setState(() {
      _future = getEmployees();
    });
  }
  
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee Management'),
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final employees = snapshot.data!;
          return ListView.builder(
            itemCount: employees.length,
            itemBuilder: ((context, index) {
              final employee = employees[index];
              return Column(
                children: [
                  // Add search bar here?
                  ListTile(
                    leading: IconButton.outlined(
                      onPressed: () {
                        setState(() {
                          // isEditing = true;
                          // if isEditing == true then change Text widgets to TextFields
                        });
                        // change Text childs to textfields, change the delete button to confirmation icon
                      },
                      icon: const Icon(Icons.done),
                    ),
                    title: Text('${employee['first_name']} ${employee['last_name']}'),
                    subtitle: Text('${employee['employee_ID']} \n ${employee['employee_type']}'),
                    isThreeLine: true,
                    trailing: IconButton.outlined(
                      onPressed: () => showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => Dialog(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("Are you sure you want to delete this employee?"),
                                const SizedBox(height: 20),
                                TextButton(
                                  onPressed: () {
                                    deleteEmployee(employee['employee_ID']);
                                    updateList();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Deleted Employee.'),
                                      ),
                                    );
                                    Navigator.pop(context);
                                  }, 
                                child: const Text('Yes')
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  }, 
                                child: const Text('No'),
                                )
                              ],
                            )
                          )
                        )
                      ),
                      icon: const Icon(Icons.delete)
                    ),
                  ),
                ],
              );
            }
          )
        );
      },
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => Dialog(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter the first name',
                  ),
                  controller: fnControl,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter the last name',
                  ),
                  controller: lnControl,
                ),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Select employee type',
                  ),
                  value: empType,
                  items: const [
                    DropdownMenuItem(
                      value: 'Regular',
                      child: Text('Regular'),
                    ),
                    // Add more options as needed
                  ],
                  onChanged: (value) => setState(() => empType = value!),
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter the employee pin',
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  controller: empPinCont,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        addEmployee(fnControl, lnControl, empPinCont, empType);
                        updateList();
                        ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Added Employee.'),
                                      ),
                                    );
                        Navigator.pop(context);
                        dispose();
                      },
                      child: const Text('Add'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      tooltip: 'Add Employee',
      child: const Icon(Icons.add),
    ),
  );
}}