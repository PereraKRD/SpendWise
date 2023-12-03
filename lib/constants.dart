import 'package:flutter/material.dart';

InputDecoration buildInputDecoration(String label, IconData suffixIcon) {
  return InputDecoration(
    fillColor: const Color(0xAA494A59),
    filled: true,
    enabledBorder: const OutlineInputBorder(
      borderSide: BorderSide(
        color: Color(0x35949494),
      ),
    ),
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white),
    ),
    icon: Icon(
      suffixIcon,
      color: const Color(0xFF949494),
    ),
    labelStyle: const TextStyle(
      color: Color(0xFF949494),
    ),
    labelText: label,
    border: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
    ),
  );
}
