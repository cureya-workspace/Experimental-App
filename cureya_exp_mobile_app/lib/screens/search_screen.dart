import 'package:cureya_exp_mobile_app/components/appbar.dart';
import 'package:cureya_exp_mobile_app/components/global_diagnosis_test_list_tile.dart';
import 'package:cureya_exp_mobile_app/components/or_divider.dart';
import 'package:cureya_exp_mobile_app/components/search_tests.dart';
import 'package:cureya_exp_mobile_app/constants/constants.dart';
import 'package:cureya_exp_mobile_app/context/search_tests_provider.dart';
import 'package:cureya_exp_mobile_app/models/global_test.dart';
import 'package:cureya_exp_mobile_app/screens/add_tests_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const CustomAppBar(
                    title: 'Search Diagnostic Center',
                    description: 'Search Diagnostic Centers near you!'),
                const SizedBox(height: 16),
                const Text("Add Location",
                    style:
                        TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                const SizedBox(height: 8),
                AddLocation(),
                const SizedBox(height: 16),
                const Divider(
                  height: 0,
                  color: Color.fromRGBO(233, 233, 233, 1),
                ),
                const SizedBox(height: 16),
                const Text("Your Tests",
                    style:
                        TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.maxFinite,
                  child: MaterialButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const AddTestScreen()));
                    },
                    color: const Color.fromRGBO(72, 187, 120, 1),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    textColor: Colors.white,
                    child: const Text("Add Test", textAlign: TextAlign.center),
                  ),
                ),
                const SizedBox(height: 8),
                const Expanded(child: SearchTestList()),
                SizedBox(
                  width: double.maxFinite,
                  child: MaterialButton(
                    onPressed: () {},
                    color: const Color.fromRGBO(72, 187, 120, 1),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    textColor: Colors.white,
                    child: const Text("Proceed to Search",
                        textAlign: TextAlign.center),
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}

class AddLocation extends ConsumerWidget {
  AddLocation({super.key}) : super();
  String? pincode = '';
  String? city = '';
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AutofillGroup(
      child: Column(
        children: [
          Container(
            height: 42,
            decoration: BoxDecoration(
                color: const Color.fromRGBO(243, 243, 243, 1),
                borderRadius: BorderRadius.circular(10)),
            child: Center(
              child: TextFormField(
                maxLength: 6,
                keyboardType: TextInputType.number,
                validator: (String? val) {
                  if (val!.isEmpty) {
                    return "Cannot be empty";
                  }
                  if (!RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      .hasMatch(val)) {
                    return "Please provide valid email";
                  }
                },
                onSaved: (newValue) {
                  pincode = newValue;
                },
                style: const TextStyle(fontSize: 14),
                decoration: const InputDecoration(
                    counterText: "",
                    hintText: 'Pincode',
                    hintStyle: TextStyle(color: Colors.black, fontSize: 14),
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 14.3)),
              ),
            ),
          ),
          const SizedBox(height: 22, child: OrDivider()),
          Container(
            height: 42,
            decoration: BoxDecoration(
                color: const Color.fromRGBO(243, 243, 243, 1),
                borderRadius: BorderRadius.circular(10)),
            child: Center(
              child: TextFormField(
                style: const TextStyle(fontSize: 14),
                decoration: const InputDecoration(
                    counterText: "",
                    hintText: 'City',
                    hintStyle: TextStyle(color: Colors.black, fontSize: 14),
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 14.3)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}