import 'package:cureya_exp_mobile_app/context/search_tests_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddedTests extends StatelessWidget {
  const AddedTests({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        var gdc = ref.watch(searchTestProvider);
        return MaterialButton(
          color: const Color.fromRGBO(72, 187, 120, 1),
          onPressed: () {},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Your Tests ${gdc.length}"),
            ],
          ),
        );
      },
    );
  }
}
