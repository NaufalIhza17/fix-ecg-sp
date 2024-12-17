import 'package:flutter/material.dart';

class CustomInput extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final String errorMessage;
  final Function(String) onChanged;
  final String type;
  final VoidCallback? onPressed;

  const CustomInput({
    super.key,
    required this.controller,
    required this.hintText,
    required this.errorMessage,
    required this.onChanged,
    required this.type,
    required this.onPressed,
  });

  @override
  _CustomInputState createState() => _CustomInputState();
}

class _CustomInputState extends State<CustomInput> {
  bool _isInputCorrect = false;

  void _validateInput(String value) {
    setState(() {
      if (widget.type == 'phoneNumber') {
        _isInputCorrect = RegExp(r'^[0-9]+$').hasMatch(value);
      } else if (widget.type == 'email') {
        _isInputCorrect = value.contains('@') && value.length >= 5;
      } else {
        _isInputCorrect = value.isNotEmpty && value.length >= 5;
      }
    });
    widget.onChanged(value);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: widget.controller,
          style: const TextStyle(color: Colors.white),
          cursorColor: Colors.white,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            hintText: widget.hintText,
            hintStyle: const TextStyle(color: Color(0xFF939393)),
            fillColor: const Color(0x1A6C6C6C),
            filled: true,
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: _isInputCorrect ? Colors.white : const Color(0xFF7D3D3D),
              ),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          onChanged: _validateInput,
        ),
        Visibility(
          visible: !_isInputCorrect,
          child: Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(top: 10, right: 8),
              child: Text(
                widget.errorMessage,
                style: const TextStyle(
                  color: Color(0xFF7D3D3D),
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 24,
        ),
        ElevatedButton(
          onPressed: widget.onPressed,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 13),
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: const Center(
            child: Text(
              'Send Code',
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                height: 1.0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
