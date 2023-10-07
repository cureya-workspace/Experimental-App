import 'package:cureya_exp_mobile_app/components/global_diagnosis_test_list_tile.dart';
import 'package:cureya_exp_mobile_app/context/search_tests_provider.dart';
import 'package:cureya_exp_mobile_app/models/global_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchTestList extends StatelessWidget {
  const SearchTestList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      List<GlobalDiagnosisTest> list = ref.watch(searchTestProvider);

      return ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, index) {
            return GlobalDiagnosisTestListTile(list[index]);
          });
    });
  }
}
