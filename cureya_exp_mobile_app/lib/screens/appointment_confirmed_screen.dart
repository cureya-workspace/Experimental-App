import 'package:cureya_exp_mobile_app/screens/appointments_history_screen.dart';
import 'package:flutter/material.dart';

class AppointmentConfirmationScreen extends StatelessWidget {
  const AppointmentConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Card(
                  elevation: 0,
                  color: Color.fromRGBO(72, 187, 120, 1),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(54))),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(Icons.check, size: 64, color: Colors.white),
                  ),
                ),
                const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Appointment Added in Queue!",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(
                      height: 12,
                    ),
                    Text(
                      "Shortly you’ll receive a call from us, please confirm your appointment. Thank you!",
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                const SizedBox(),
                Column(
                  children: [
                    MaterialButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                    const AppointmentHistoryScreen()));
                      },
                      child: const Text("See Appointments",
                          style: TextStyle(color: Colors.green)),
                    ),
                    MaterialButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: const Text("Book Another",
                          style: TextStyle(color: Colors.green)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
