import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  final String title;
  final String description;

  const CustomAppBar({super.key, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w800,
          color: Color.fromRGBO(45, 55, 72, 1)
        )),
        Text(description, style: const TextStyle(
          fontSize: 12,
          color: Color.fromRGBO(45, 55, 72, 1)
        )),
        const Divider(
          height: 14,
          thickness: 0.9,
          color: Color.fromRGBO(45, 55, 72, 1)
        )
      ],
    );
  }
}