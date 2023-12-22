import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final TextInputType keyboardType;
  final bool isObsecured;
  final TextEditingController controller;
  const CustomTextField({super.key, required this.label, required this.keyboardType, required this.isObsecured, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: isObsecured,
      style: const TextStyle(fontSize: 20),
      keyboardType: keyboardType,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: Divider.createBorderSide(context, color: Colors.white),
          borderRadius: BorderRadius.circular(160),
        ),
        labelText: label,
        labelStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        contentPadding: const EdgeInsets.all(16)
      ),
    );
  }
}