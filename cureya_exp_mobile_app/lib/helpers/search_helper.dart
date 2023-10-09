import 'package:cureya_exp_mobile_app/constants/constants.dart';
import 'package:cureya_exp_mobile_app/models/diagnostic_center.dart';
import 'package:cureya_exp_mobile_app/models/global_test.dart';
import 'package:cureya_exp_mobile_app/services/http_service_singleton.dart';

class SearchHelper {
  static performSearch(String? pincode, String? city,
      List<GlobalDiagnosisTest> searchTestList) async {
    Map<String, dynamic> body = {};
    List<String> searchTestIdList = searchTestList.map((e) => e.id).toList();


    print("VALs: $pincode $city");

    if (pincode != '') {
      body['pincode'] = pincode;
    } else {
      body['city'] = city;
    }

    body['tests'] = searchTestIdList;
    var response = await HttpServiceSingleton().makeRequest(
        url: '$BASE_URI/search',
        method: HTTPMethod.POST,
        headers: {'content-type': 'application/json'},
        body: body,
        includeAuthCredentials: true);
    
    return response;
  }
}
