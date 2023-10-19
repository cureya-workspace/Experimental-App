// ignore_for_file: no_logic_in_create_state

import 'dart:convert';
import 'dart:io';

import 'package:cureya_exp_mobile_app/components/appbar.dart';
import 'package:cureya_exp_mobile_app/helpers/appointment_helper.dart';
import 'package:cureya_exp_mobile_app/models/diagnostic_center.dart';
import 'package:cureya_exp_mobile_app/screens/appointment_confirmed_screen.dart';
import 'package:flutter/material.dart';

class MakeAppointmentScreen extends StatefulWidget {
  final DiagnosticCenter diagnosticCenter;
  final List testList;

  const MakeAppointmentScreen(
      {super.key, required this.diagnosticCenter, required this.testList});

  @override
  State<MakeAppointmentScreen> createState() => _MakeAppointmentScreenState(
      diagnosticCenter: diagnosticCenter, testList: testList);
}

class _MakeAppointmentScreenState extends State<MakeAppointmentScreen> {
  final DiagnosticCenter diagnosticCenter;
  final List testList;

  Map<String, dynamic> appointmentDetails = {
    'diagnostic_center_id': null,
    'visit_date_time': null,
    'appointment_slot': 'morning'
  };

  // TODO: Add homevisit details.

  _MakeAppointmentScreenState(
      {required this.diagnosticCenter, required this.testList});

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
                    description:
                        "Book an appointment in ${diagnosticCenter.name}"),
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
                    slot: appointmentDetails['appointment_slot'],
                    onChange: (slot) {
                      setState(() {
                        appointmentDetails['appointment_slot'] = slot;
                      });
                    }),
                const SizedBox(height: 12),
                const Text(
                  "Select Date",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.start,
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey[100]),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(appointmentDetails['visit_date_time'] ??
                          "Date not selected!"),
                      MaterialButton(
                          onPressed: () async {
                            DateTime? pickedDate = await showDialog(
                                context: context,
                                builder: (context) => DatePickerDialog(
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime(
                                        DateTime.now().year,
                                        DateTime.now().month,
                                        DateTime.now().day + 2),
                                    helpText: 'Select Date'));

                            setState(() {
                              if (pickedDate != null) {
                                appointmentDetails['visit_date_time'] =
                                    pickedDate.toString().split(' ')[0];
                              }
                            });
                          },
                          child: const Text("Select Date")),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              width: double.maxFinite,
              child: MaterialButton(
                onPressed: () async {
                  try {
                    appointmentDetails['diagnostic_center_id'] =
                        diagnosticCenter.id;

                    if (appointmentDetails['visit_date_time'] == null) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          showCloseIcon: true,
                          backgroundColor: Colors.red,
                          content: Text("Please select visit date time")));
                      return;
                    }

                    var res = await AppointmentHelper.createAppointment(
                        appointmentDetails);
                    await AppointmentHelper.addTestsInAppointment(
                        res['data']['id'],
                        testList.map((e) => e['id'].toString()).toList());

                        // ignore: use_build_context_synchronously
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AppointmentConfirmationScreen()));
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        showCloseIcon: true,
                        backgroundColor: Colors.red,
                        content: Text(e.toString())));
                  }
                },
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
