import 'package:cureya_exp_mobile_app/components/appbar.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DiagnosticCenterScreen extends StatelessWidget {
  final Map searchResult;
  const DiagnosticCenterScreen({super.key, required this.searchResult});

  _getCost() {
    var total = 0;

    for (var ele in searchResult['DCTest']) {
      total = ele['cust_price'] + total;
    }

    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding:  const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomAppBar(
                      title: searchResult['name'],
                      description:
                          'Book an appointment in ${searchResult['name']}'),
                  const SizedBox(height: 18),
                  const Text('Address',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: const Color.fromRGBO(247, 250, 252, 200),
                        borderRadius: BorderRadius.circular(10)),
                    child: Text(searchResult['address']),
                  ),
                  const SizedBox(height: 18),
                  const Text('Your Tests',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: const Color.fromRGBO(247, 250, 252, 200),
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      children: [
                        ...searchResult['DCTest']
                            .map<Widget>((e) => Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(e['global_diagnosis_test']
                                          ['test_name']),
                                      Text('Rs. ${e['cust_price'].toString()}')
                                    ]))
                            .toList(),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(),
                            Text("Rs. ${_getCost()}")
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: double.maxFinite,
                child: MaterialButton(
                    elevation: 0,
                    textColor: Colors.white,
                    color: const Color.fromRGBO(72, 187, 120, 1),
                    child: const Text("Book an Appointment"),
                    onPressed: () {
                      showDialog(context: context, builder: (context) => Dialog(
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(height: 10,),
                              const Text("Contact Us", style: TextStyle(fontSize: 20)),
                              const SizedBox(height: 24,),
                              ...searchResult['phone'].split(',').map((e)=> ListTile(
                                onTap: () async {
                                  var url = Uri.parse('tel:$e');
                                  if ((await canLaunchUrl(url))) {
                                    await launchUrl(url);
                                  }
                                },
                                title: Text(e),
                              )),
                              TextButton(onPressed: () {
                                Navigator.pop(context);
                              }, child: const Text("Cancel"))
                            ],
                          ),
                        ),
                      ));
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
