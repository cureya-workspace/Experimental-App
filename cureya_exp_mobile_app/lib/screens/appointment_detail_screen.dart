import 'package:cureya_exp_mobile_app/components/appbar.dart';
import 'package:cureya_exp_mobile_app/helpers/appointment_helper.dart';
import 'package:cureya_exp_mobile_app/screens/diagnostic_center_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppointmentDetailScreen extends StatelessWidget {
  final String appointmentId;
  const AppointmentDetailScreen({super.key, required this.appointmentId});

  _getTotal(List e) {
    int? total = 0;
    for (var element in e) {
      total = (total! + element['dc_test']['cust_price']) as int?;
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
        children: [
          CustomAppBar(
              title: 'Appointment Details',
              description: 'Track your appointment'),
          const SizedBox(height: 12),
          Expanded(
              child: FutureBuilder(
                  future:
                      AppointmentHelper.fetchAppointmentWithId(appointmentId),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return const Center(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.error_outline),
                          Text("Something went wrong")
                        ],
                      ));
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Appointment details
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 12),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.grey[100]),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("Appointment Date"),
                                  Text(DateFormat.yMMMMd().format(
                                      DateTime.parse(
                                          snapshot.data!['visit_date']))),
                                ],
                              ),
                              const SizedBox(
                                height: 16,
                                child: Divider(),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("Appointment Slot"),
                                  Text("${snapshot.data!['slot']}"),
                                ],
                              ),
                              const SizedBox(
                                height: 16,
                                child: Divider(),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("Appointment Type"),
                                  Text(snapshot.data!['is_home_visit']
                                      ? 'Home Visit'
                                      : 'Walk In'),
                                ],
                              ),
                              const SizedBox(
                                height: 16,
                                child: Divider(),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("Status"),
                                  Text("${snapshot.data!['status']}"),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text("Your Tests",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 12),
                          decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              ...snapshot.data!['AppointmentDiagnosisTest']
                                  .map<Widget>((e) => Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                                "${e['dc_test']['global_diagnosis_test']['test_name']}"),
                                            Text(
                                                'Rs. ${e['dc_test']['cust_price'].toString()}')
                                          ]))
                                  .toList(),
                              const Divider(),
                              Text(
                                  "Rs. ${_getTotal(snapshot.data!['AppointmentDiagnosisTest'])}")
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text("Diagnostic Center Details",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.grey[100]),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          Text(
                              "${snapshot.data!['diagnostic_centre']['name']} (${snapshot.data!['diagnostic_centre']['city']})",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(
                            height: 6,
                          ),
                          Text(
                              "${snapshot.data!['diagnostic_centre']['address']}")
                            ],
                          ),
                        )
                      ],
                    );
                  })),
        ],
      ),
    )));
  }
}
