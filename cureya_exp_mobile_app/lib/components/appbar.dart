import 'package:cureya_exp_mobile_app/components/logout_button.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  final String title;
  final String description;
  bool? showLogoutButton;

  CustomAppBar(
      {super.key,
      required this.title,
      required this.description,
      this.showLogoutButton});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      overflow: TextOverflow.clip,
                      style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: Color.fromRGBO(45, 55, 72, 1))),
                  Text(description,
                      style: const TextStyle(
                          fontSize: 12, color: Color.fromRGBO(45, 55, 72, 1))),
                ],
              ),
            ),
            showLogoutButton != null && showLogoutButton == true
                ? const LogoutButton()
                : const SizedBox()
          ],
        ),
        const Divider(
            height: 14, thickness: 0.9, color: Color.fromRGBO(45, 55, 72, 1))
      ],
    );
  }
}
