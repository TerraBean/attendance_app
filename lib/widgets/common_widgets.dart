// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final String hintText;
  final String labelText;
  final TextEditingController? controller; // Add the controller parameter
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final IconData prefixIcon;
  final TextInputType? keyboardType;

  const InputField({
    Key? key,
    required this.hintText,
    required this.labelText,
    this.controller, // Make the controller optional
    this.onChanged,
    this.validator,
    required this.prefixIcon,
    this.keyboardType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller, // Use the controller here
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        prefixIcon: Icon(prefixIcon),
      ),
      onChanged: onChanged,
      validator: validator,
      keyboardType: keyboardType,
    );
  }
}


class AuthButton extends StatelessWidget {
  final String text;
  final Function() onPressed;
  final bool isLoading;

  const AuthButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            padding: const EdgeInsets.symmetric(vertical: 18),
            textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          child: isLoading
              ? const CircularProgressIndicator(
                  color: Colors.white,
                )
              : Text(
                  text,
                  style: const TextStyle(color: Colors.white),
                ),
        ),
      ),
    );
  }
}

class MessageDisplay extends StatelessWidget {
  final String message;

  const MessageDisplay({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        style: const TextStyle(color: Colors.red),
      ),
    );
  }
}
