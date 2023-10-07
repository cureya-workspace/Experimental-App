import 'package:cureya_exp_mobile_app/models/global_test.dart';

class SearchQuery {
  String? city;
  String? pincode;
  List<GlobalDiagnosisTest> globalDiagnosisTestList = [];
  
  SearchQuery({this.city, this.pincode});
}