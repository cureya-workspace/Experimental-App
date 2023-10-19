import 'package:cureya_exp_mobile_app/screens/login_screen.dart';
import 'package:cureya_exp_mobile_app/screens/search_result_screen.dart';
import 'package:cureya_exp_mobile_app/screens/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});
  final _storage = const FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _storage.read(key: 'Authorization'),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return SearchScreen();
        } else {
          return const LoginScreen();
        }
      });
  }
}