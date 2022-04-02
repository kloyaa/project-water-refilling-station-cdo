import 'package:app/common/radius.dart';
import 'package:app/const/colors.dart';
import 'package:flutter/material.dart';

TextField inputTextField(
    {required String labelText,
    required TextStyle textFieldStyle,
    required TextStyle hintStyleStyle,
    required TextEditingController controller,
    required color,
    obscureText,
    focusNode,
    hasError}) {
  return TextField(
    style: textFieldStyle.copyWith(
      color: hasError ? Colors.redAccent : textFieldStyle.color,
      fontWeight: FontWeight.bold,
    ),
    controller: controller,
    focusNode: focusNode,
    obscureText: obscureText ?? false,
    decoration: InputDecoration(
      contentPadding: const EdgeInsets.all(25.0),
      filled: true,
      fillColor: color,
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      labelText: labelText,
      focusedBorder: const OutlineInputBorder(
        borderRadius: kDefaultRadius,
        borderSide: BorderSide(
          color: Colors.transparent,
          width: 0.8,
        ),
      ),
      enabledBorder: const OutlineInputBorder(
        borderRadius: kDefaultRadius,
        borderSide: BorderSide(
          color: Colors.transparent,
          width: 0.8,
        ),
      ),
      floatingLabelStyle: textFieldStyle.copyWith(
        color: hasError ? Colors.redAccent : textFieldStyle.color,
        height: 5,
        fontWeight: FontWeight.bold,
      ),
      hintStyle: textFieldStyle.copyWith(
        color: hasError ? Colors.redAccent : kPrimary,
      ),
    ),
  );
}

TextField inputNumberTextField({
  required String labelText,
  required TextStyle textFieldStyle,
  required TextStyle hintStyleStyle,
  required TextEditingController controller,
  required color,
  focusNode,
  hasError,
}) {
  return TextField(
    style: textFieldStyle.copyWith(
      color: hasError ? Colors.redAccent : textFieldStyle.color,
      fontWeight: FontWeight.bold,
    ),
    controller: controller,
    focusNode: focusNode,
    keyboardType: TextInputType.number,
    decoration: InputDecoration(
      contentPadding: const EdgeInsets.all(25.0),
      filled: true,
      fillColor: color,
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      labelText: labelText,
      focusedBorder: const OutlineInputBorder(
        borderRadius: kDefaultRadius,
        borderSide: BorderSide(
          color: Colors.transparent,
          width: 0.8,
        ),
      ),
      enabledBorder: const OutlineInputBorder(
        borderRadius: kDefaultRadius,
        borderSide: BorderSide(
          color: Colors.transparent,
          width: 0.8,
        ),
      ),
      floatingLabelStyle: textFieldStyle.copyWith(
        color: hasError ? Colors.redAccent : textFieldStyle.color,
        height: 5,
        fontWeight: FontWeight.bold,
      ),
      hintStyle: textFieldStyle.copyWith(
        color: hasError ? Colors.redAccent : kPrimary,
      ),
    ),
  );
}

TextField inputTextArea({
  required String labelText,
  required TextStyle textFieldStyle,
  required TextStyle hintStyleStyle,
  required TextEditingController controller,
  required color,
  focusNode,
  hasError,
}) {
  return TextField(
    style: textFieldStyle.copyWith(
      color: hasError ? Colors.redAccent : textFieldStyle.color,
      fontWeight: FontWeight.bold,
    ),
    controller: controller,
    focusNode: focusNode,
    maxLines: 3,
    keyboardType: TextInputType.multiline,
    decoration: InputDecoration(
      contentPadding: const EdgeInsets.all(25.0),
      filled: true,
      fillColor: color,
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      alignLabelWithHint: true,
      labelText: labelText,
      focusedBorder: const OutlineInputBorder(
        borderRadius: kDefaultRadius,
        borderSide: BorderSide(
          color: Colors.transparent,
          width: 0.8,
        ),
      ),
      enabledBorder: const OutlineInputBorder(
        borderRadius: kDefaultRadius,
        borderSide: BorderSide(
          color: Colors.transparent,
          width: 0.8,
        ),
      ),
      floatingLabelStyle: textFieldStyle.copyWith(
        color: hasError ? Colors.redAccent : textFieldStyle.color,
        height: 5,
        fontWeight: FontWeight.bold,
      ),
      hintStyle: textFieldStyle.copyWith(
        color: hasError ? Colors.redAccent : kPrimary,
      ),
    ),
  );
}
