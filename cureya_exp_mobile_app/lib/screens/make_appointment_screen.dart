import 'package:cureya_exp_mobile_app/components/appbar.dart';
import 'package:cureya_exp_mobile_app/models/diagnostic_center.dart';
import 'package:flutter/material.dart';

class MakeAppointmentScreen extends StatelessWidget {
  final DiagnosticCenter diagnosticCenter;
  final List testList;
  String slot = 'morning';

  MakeAppointmentScreen(
      {super.key, required this.diagnosticCenter, required this.testList});

  _getCost() {
    var total = 0;

    for (var ele in testList) {
      total = ele['cust_price'] + total;
    }

    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomAppBar(
                title: "Book an appointment",
                description: "Book an appointment in selected diagnostic center!"),
            const SizedBox(height: 12),
            const Text(
              "Your Tests",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.start,
            ),
            AppointmentTestList(testList: testList, cost: _getCost()),
            const SizedBox(height: 12),
            const Text(
              "Select Time Slot",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 12),
            SelectSlotButton(
                slot: slot,
                onChange: (slot) {
                  slot = slot;
                }),
            const SizedBox(height: 12),
            const Text(
              "Select Date",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 12),
            MaterialButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) => DatePickerDialog(
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(DateTime.now().year,
                              DateTime.now().month, DateTime.now().day + 2),
                          helpText: 'Select Date'));
                },
                child: Text("Select Date")),
              ],
            ),
            SizedBox(
              width: double.maxFinite,
              child: MaterialButton(
                onPressed: () {},
                elevation: 0,
                textColor: Colors.white,
                color: const Color.fromRGBO(72, 187, 120, 1),
                child: const Text("Proceed"),
              ),
            )
          ],
        ),
      ),
    ));
  }
}

class AppointmentTestList extends StatelessWidget {
  final List testList;
  final cost;
  const AppointmentTestList(
      {super.key, required this.testList, required this.cost});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey[100],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          ...testList
              .map((e) => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(e['global_diagnosis_test']['test_name']),
                      Text('Rs. ${e['cust_price']}')
                    ],
                  ))
              .toList(),
          const Divider(),
          Text(
            "Rs. ${this.cost}",
            style: const TextStyle(fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}

class SelectSlotButton extends StatelessWidget {
  final String slot;
  final Function onChange;
  const SelectSlotButton(
      {super.key, required this.onChange(String slot), required this.slot});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey[100], borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: [
          Flexible(
              child: SizedBox(
            width: double.maxFinite,
            child: MaterialButton(
              onPressed: () {
                onChange('morning');
              },
              textColor: slot == 'morning' ? Colors.green : null,
              child: const Text("Morning"),
            ),
          )),
          Flexible(
              child: SizedBox(
            width: double.maxFinite,
            child: MaterialButton(
              onPressed: () {
                onChange('afternoon');
              },
              textColor: slot == 'afternoon' ? Colors.green : null,
              child: const Text("Afternoon"),
            ),
          )),
          Flexible(
              child: SizedBox(
            width: double.maxFinite,
            child: MaterialButton(
              onPressed: () {
                onChange('evening');
              },
              textColor: slot == 'evening' ? Colors.green : null,
              child: const Text("Evening"),
            ),
          ))
        ],
      ),
    );
  }
}
