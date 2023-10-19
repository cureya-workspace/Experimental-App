import 'package:cureya_exp_mobile_app/helpers/auth_helper.dart';
import 'package:cureya_exp_mobile_app/screens/appointments_history_screen.dart';
import 'package:flutter/material.dart';

import '../screens/login_screen.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(onPressed: () async {
      try {
        await AuthHelper.logout();
        Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }, 
      iconSize: 20,
      icon: const Icon(Icons.logout_outlined),
    );
  }
}

class AppointmentHistoryButton extends StatelessWidget {
  const AppointmentHistoryButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(onPressed: () async {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const AppointmentHistoryScreen()));
    }, 
      iconSize: 20,
      icon: const Icon(Icons.history),
    );
  }
}