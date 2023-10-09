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

 static createAnAccount(credentials) async {
    final res = await HttpServiceSingleton().makeRequest(
        url: '$BASE_URI/user',
        method: HTTPMethod.POST,
        headers: {'content-type': 'application/json'},
        body: credentials);
    
    
    if (kDebugMode) {
      print("DATA $res");
    }

    return res;
  }

  static logout() async {
    final logOutRes = await HttpServiceSingleton().makeRequest(
        url: '$BASE_URI/auth/logout',
        method: HTTPMethod.DELETE,
        includeAuthCredentials: true,
        headers: {'content-type': 'application/json'});
    
    
    if (kDebugMode) {
      print("DATA $logOutRes");
    }

    _storage.delete(key: 'Authorization');
  }

}
