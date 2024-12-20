import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final String bgColor;
  final String txtColor;

  const CustomTextButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.bgColor = "0x336C6C6C",
    this.txtColor = "0xFFFFFFFF",
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 24),
        backgroundColor: Color(int.parse(bgColor)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: Color(int.parse(txtColor)),
            fontSize: 16,
            height: 1.0,
          ),
        ),
      ),
    );
  }
}
