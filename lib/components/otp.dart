import 'package:flutter/material.dart';

class CustomOTP extends StatefulWidget {
  final List<TextEditingController> controllers;
  final String errorMessage;
  final Function(String) onChanged;
  final VoidCallback? onPressed;

  const CustomOTP({
    super.key,
    required this.controllers,
    required this.errorMessage,
    required this.onChanged,
    required this.onPressed,
  });

  @override
  _CustomOTPState createState() => _CustomOTPState();
}

class _CustomOTPState extends State<CustomOTP> {
  bool _isInputCorrect = true;

  void _validateInput(String value, int index) {
    setState(() {
      _isInputCorrect = RegExp(r'^[0-9]$').hasMatch(value);
    });

    widget.onChanged(value);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            4,
            (index) {
              return SizedBox(
                width: 72,
                height: 72,
                child: TextField(
                  controller: widget.controllers[index],
                  style: const TextStyle(color: Colors.white),
                  cursorColor: Colors.white,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    hintText: '0',
                    hintStyle: const TextStyle(color: Color(0xFF939393)),
                    fillColor: const Color(0x1A6C6C6C),
                    filled: true,
                    counterText: '',
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: _isInputCorrect
                            ? Colors.white
                            : const Color(0xFF7D3D3D),
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onChanged: (value) => _validateInput(value, index),
                  textAlignVertical: TextAlignVertical.center,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  maxLength: 1,
                ),
              );
            },
          ),
        ),
        Visibility(
          visible: !_isInputCorrect,
          child: Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(top: 0, right: 8),
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
