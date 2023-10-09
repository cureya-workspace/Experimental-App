import 'package:cureya_exp_mobile_app/components/appbar.dart';
import 'package:cureya_exp_mobile_app/context/search_tests_provider.dart';
import 'package:cureya_exp_mobile_app/helpers/search_helper.dart';
import 'package:cureya_exp_mobile_app/screens/diagnostic_center_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ignore: must_be_immutable
class SearchResultScreen extends ConsumerWidget {
  String? pincode;
  String? city;
  SearchResultScreen({super.key, this.pincode, this.city});

  @override
  Widget build(BuildContext context, ref) {
    return Scaffold(
      body: SafeArea(
          child: Column(children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 10),
          child: CustomAppBar(
              title: 'Diagnostic Centers',
              description: 'Available for Testing'),
        ),
        Expanded(
            child: FutureBuilder(
          future: SearchHelper.performSearch(
              pincode, city, ref.watch(searchTestProvider)),
          builder: (context, snapshot) {

            if (snapshot.data == null) {
              return const Center(child: Text("Loading"),);
            }

            if (snapshot.hasError) {
              return const Center(child: Text("Something went wrong"),);
            }
            var resData = (snapshot.data as Map)['data'];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: ListView.builder(
                  itemCount: resData.length,
                  itemBuilder: (context, index) {
                    return ResultDiagnosticCenterListTile(
                      diagnosticCenter: resData[index],
                    );
                  }),
            );
          },
        ))
      ])),
    );
  }
}

class ResultDiagnosticCenterListTile extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final diagnosticCenter;
  const ResultDiagnosticCenterListTile(
      {super.key, required this.diagnosticCenter});

  _getCost() {
    var total = 0;

    for (var ele in diagnosticCenter['DCTest']) {
      total = ele['cust_price'] + total;
    }

    return total;
  }

  _showInfo(context) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text(diagnosticCenter['name']),
            content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 4),
                  ...diagnosticCenter['DCTest']
                      .map<Widget>((e) => Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(e['global_diagnosis_test']['test_name']),
                                Text('Rs. ${e['cust_price'].toString()}')
                              ]))
                      .toList(),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [const SizedBox(), Text("Rs. ${_getCost()}")],
                  )
                ]),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('OK'))
            ],
          ));

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      _getAvailabilityString() {
        final searchTests = ref.watch(searchTestProvider).length;
        final availableTests = diagnosticCenter['DCTest'].length;

        return '($availableTests/$searchTests)';
      }

      return ListTile(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => DiagnosticCenterScreen(searchResult: diagnosticCenter)));
        },
        trailing: IconButton(
            onPressed: () {
              _showInfo(context);
            },
            icon: const Icon(Icons.info_outline)),
        title: Text(diagnosticCenter['name'],
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Rs. ${_getCost()}  ${_getAvailabilityString()}'),
            const SizedBox(height: 6),
            Text(diagnosticCenter['city'])
          ],
        ),
      );
    });
  }
}
