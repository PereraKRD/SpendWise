import 'package:flutter/material.dart';
import 'package:spendwise/common/color_extension.dart';

InputDecoration buildInputDecoration(String label, IconData suffixIcon) {
  return InputDecoration(
    fillColor: TColor.white,
    filled: true,
    enabledBorder: const OutlineInputBorder(
      borderSide: BorderSide(
        color: Color(0x35949494),
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: TColor.primary.withOpacity(0.5)),
    ),
    icon: Icon(
      suffixIcon,
      color: TColor.primary.withOpacity(0.7),
    ),
    labelStyle: TextStyle(
      color: TColor.primary.withOpacity(0.5),
    ),
    labelText: label,
    border: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
    ),
  );
}
