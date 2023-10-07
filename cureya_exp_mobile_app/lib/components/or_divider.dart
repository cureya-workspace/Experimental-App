import 'package:flutter/material.dart';

class OrDivider extends StatelessWidget {
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        const Divider(
          color: Color.fromRGBO(233, 233, 233, 1),
        ),
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            color: Colors.white,
            child: const Text("OR", 
              style: TextStyle(
                color: Color.fromRGBO(179, 179, 179, 1),
              ),
            ))
      ],
    );
  }
}
