// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';
import 'package:cureya_exp_mobile_app/context/search_tests_provider.dart';
import 'package:cureya_exp_mobile_app/models/global_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GlobalDiagnosisTestListTile extends StatelessWidget {
  final GlobalDiagnosisTest diagnosisTest;
  const GlobalDiagnosisTestListTile(
      this.diagnosisTest,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      var addedTests = ref.watch(searchTestProvider);
      GlobalDiagnosisTest? currentDcTest = addedTests
          .firstWhereOrNull((element) => element.id == diagnosisTest.id);

      return ListTile(
        title: Text(diagnosisTest.testName),
        subtitle: Text(diagnosisTest.attribute ?? 'None'),
        onTap: currentDcTest != null ? () {
           showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: const Text("Delete from Search"),
                    content: Text(
                        "Delete ${diagnosisTest.testName} ${diagnosisTest.attribute ?? ''} from Search?"),
                    actions: [
                      MaterialButton(
                          onPressed: () {
                            ref
                                .read(searchTestProvider.notifier)
                                .removeSearchTest(diagnosisTest);
                            Navigator.pop(context);
                          },
                          child: const Text("Yes")),
                      MaterialButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("No"))
                    ],
                  ));
        } : () {
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: const Text("Add to Search"),
                    content: Text(
                        "Add ${diagnosisTest.testName} ${diagnosisTest.attribute ?? ''} to Search?"),
                    actions: [
                      MaterialButton(
                          onPressed: () {
                            ref
                                .read(searchTestProvider.notifier)
                                .addSearchTest(diagnosisTest);
                            Navigator.pop(context);
                          },
                          child: const Text("Yes")),
                      MaterialButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("No"))
                    ],
                  ));
        },
        // ignore: unnecessary_null_comparison
        trailing: currentDcTest != null ? const Text("Added") : null,
      );
    });
  }
}