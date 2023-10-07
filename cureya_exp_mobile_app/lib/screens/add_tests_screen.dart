import 'package:cureya_exp_mobile_app/components/added_tests_indicator.dart';
import 'package:cureya_exp_mobile_app/components/appbar.dart';
import 'package:cureya_exp_mobile_app/components/global_diagnosis_test_list_tile.dart';
import 'package:cureya_exp_mobile_app/context/search_tests_provider.dart';
import 'package:cureya_exp_mobile_app/helpers/global_test_helper.dart';
import 'package:cureya_exp_mobile_app/models/global_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddTestScreen extends StatefulWidget {
  const AddTestScreen({super.key});

  @override
  State<AddTestScreen> createState() => _AddTestScreenState();
}

class _AddTestScreenState extends State<AddTestScreen> {
  final ScrollController _scrollController = ScrollController();
  List<GlobalDiagnosisTest> _diagnosisTestList = [];
  final TextEditingController _textEditingController = TextEditingController();
  String searchQuery = '';
  bool isLoading = false;
  int page = 1;

  @override
  void initState() {
    super.initState();
    _textEditingController.addListener(() {
      if (_textEditingController.text == ':clear_results') {
        _textEditingController.text = '';
        setState(() {
          _diagnosisTestList = [];
        });
      }
    });
    _scrollController.addListener(() {
      // Listen if more
      if (_scrollController.offset >=
          _scrollController.position.maxScrollExtent) {
        page++;
        _fetch(page);
        print('len ${_diagnosisTestList.length} $page');
      }
    });
  }

  _fetch([page = 1]) async {
    try {
      print('CALLED');
      var data = await GlobalTestHelper.searchGlobalTests(searchQuery, page);
      if (data['paging']['next'] != null) {
        setState(() {
          if (_diagnosisTestList.length == 0) {
            _diagnosisTestList = data['data'];
          } else if (_diagnosisTestList.length > 0) {
            for (var gDiagnosisTest in data['data']) {
              _diagnosisTestList.add(gDiagnosisTest);
            }
          }
        });
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Could not fetch items"),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    _textEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            const CustomAppBar(
                title: 'Search Tests',
                description: 'Add the tests which you want to conduct'),
            const SizedBox(height: 6),
            Row(
              children: [
                Flexible(
                  child: Container(
                    height: 42,
                    decoration: BoxDecoration(
                        color: const Color.fromRGBO(243, 243, 243, 1),
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                      child: TextFormField(
                        onChanged: (String val) {
                          if (val.length >= 3) {
                            setState(() {
                              page = 1;
                              searchQuery = val;
                              _diagnosisTestList = [];
                            });
                          }
                        },
                        controller: _textEditingController,
                        style: const TextStyle(fontSize: 14),
                        decoration: const InputDecoration(
                            counterText: "",
                            hintText: 'Search Test',
                            hintStyle:
                                TextStyle(color: Colors.black, fontSize: 14),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 14.3)),
                      ),
                    ),
                  ),
                ),
                IconButton(
                    splashColor: Colors.transparent,
                    onPressed: _fetch,
                    icon: const Icon(Icons.search_outlined))
              ],
            ),
            Expanded(
                child: ListView.builder(
                    controller: _scrollController,
                    itemCount: _diagnosisTestList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GlobalDiagnosisTestListTile(
                          _diagnosisTestList[index]);
                    })),
            const AddedTests ()
          ],
        ),
      )),
    );
  }
}