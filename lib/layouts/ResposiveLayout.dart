import 'package:flutter/material.dart';
import 'package:momenta_share/utils/dimensions.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget webLayout;
  final Widget mobileLayout;
  const ResponsiveLayout({super.key, required this.webLayout, required this.mobileLayout});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return constraints.maxWidth >= webScreenWidth ? webLayout : mobileLayout;
    });
  }
}