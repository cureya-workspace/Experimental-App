import 'package:cureya_exp_mobile_app/constants/constants.dart';
import 'package:cureya_exp_mobile_app/services/http_service_singleton.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthHelper {
  static const _storage = FlutterSecureStorage();


  static login(email, password) async {
    final loginRes = await HttpServiceSingleton().makeRequest(
        url: '$BASE_URI/auth/login',
        method: HTTPMethod.POST,
        headers: {'content-type': 'application/json'},
        body: {'email': email, 'password': password});
    
    
    if (kDebugMode) {
      print("DATA $loginRes");
    }

    _storage.write(key: 'Authorization', value: loginRes['token']);
  }
}
