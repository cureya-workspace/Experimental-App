import 'package:cureya_exp_mobile_app/models/global_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchTestListNotifier extends StateNotifier<List<GlobalDiagnosisTest>> {
  SearchTestListNotifier(): super([]);
  
  void addSearchTest(GlobalDiagnosisTest gdc) {
    print("Updated");
    state = [...state, gdc];
    state = state;
  }

  void clearSearchTest() {
    state = [];
  }

  void removeSearchTest(GlobalDiagnosisTest gdc) {
    var abc = state.where((element) => element.id != gdc.id).toList();
    state = abc;
  }

}

final searchTestProvider = StateNotifierProvider<SearchTestListNotifier, List<GlobalDiagnosisTest>>((ref) => SearchTestListNotifier());
