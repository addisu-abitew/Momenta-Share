import 'package:flutter/material.dart';

class CustomAppBar extends AppBar {
  final Widget titleWidget;
  CustomAppBar({super.key, required this.titleWidget});

  @override
  Widget? get title => Row(
    children: [
      Image.asset('assets/images/momenta_logo.png', width: 45),
      const SizedBox(width: 7.5),
      titleWidget,
    ],
  );

  @override
  PreferredSizeWidget? get bottom => PreferredSize(
    preferredSize: const Size(double.infinity, 2),
    child: Container(
      color: Colors.grey,
      height: 2,
    ),
  );
}