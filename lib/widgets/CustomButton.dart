import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isLoading;
  const CustomButton({super.key, required this.label, required this.onPressed, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width > 600 ? 600 : MediaQuery.sizeOf(context).width;
    return ElevatedButton(
      onPressed: isLoading ? () {} : onPressed,
      style: ButtonStyle(
        shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(width*0.05), side: const BorderSide(color: Colors.white))),
        padding: MaterialStatePropertyAll(EdgeInsets.symmetric(vertical: width*0.025, horizontal: width*0.05)),
        textStyle: MaterialStatePropertyAll(TextStyle(fontSize: width*0.1))
      ),
      child: isLoading
        ? const  CircularProgressIndicator()
        : Text(label, style: const TextStyle(fontFamily: 'Kalnia')),
    );
  }
}