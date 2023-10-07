import 'package:cureya_exp_mobile_app/constants/constants.dart';
import 'package:cureya_exp_mobile_app/models/global_test.dart';
import 'package:cureya_exp_mobile_app/services/http_service_singleton.dart';
import 'package:flutter/foundation.dart';

class GlobalTestHelper {
  static searchGlobalTests(String searchQuery, [page = 1]) async {
    List<GlobalDiagnosisTest> globalDiagnosisTestList = [];

    var response = await HttpServiceSingleton().makeRequest(
        url: '$BASE_URI/global-test?search=$searchQuery&page=$page',
        method: HTTPMethod.GET,
        headers: {},
        includeAuthCredentials: true);

    print(response['data']);
    for (var element in response['data']) {
      globalDiagnosisTestList.add(GlobalDiagnosisTest.fromMap(element));
    }

    if (kDebugMode) {
      print(globalDiagnosisTestList.length);
    }

    response['data'] = globalDiagnosisTestList;
    return response;
  }
}
