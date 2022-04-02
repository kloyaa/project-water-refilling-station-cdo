import 'package:app/common/radius.dart';
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
      color: hasError ? Colors.red : textFieldStyle.color,
    ),
    controller: controller,
    focusNode: focusNode,
    obscureText: obscureText ?? false,
    decoration: InputDecoration(
      filled: true,
      fillColor: color,
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      labelText: labelText,
      focusedBorder: OutlineInputBorder(
        borderRadius: kDefaultRadius,
        borderSide: BorderSide(
          color: hasError ? Colors.red : Colors.transparent,
          width: 0.8,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: kDefaultRadius,
        borderSide: BorderSide(
          color: hasError ? Colors.red : Colors.transparent,
          width: 0.8,
        ),
      ),
      floatingLabelStyle: textFieldStyle.copyWith(
        color: hasError ? Colors.red : textFieldStyle.color,
      ),
      hintStyle: textFieldStyle.copyWith(
        color: hasError ? Colors.red : textFieldStyle.color,
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
      color: hasError ? Colors.red : textFieldStyle.color,
    ),
    controller: controller,
    focusNode: focusNode,
    keyboardType: TextInputType.number,
    decoration: InputDecoration(
      filled: true,
      fillColor: color,
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      labelText: labelText,
      focusedBorder: OutlineInputBorder(
        borderRadius: kDefaultRadius,
        borderSide: BorderSide(
          color: hasError ? Colors.red : Colors.transparent,
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
        color: hasError ? Colors.red : textFieldStyle.color,
      ),
      hintStyle: textFieldStyle.copyWith(
        color: hasError ? Colors.red : textFieldStyle.color,
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
      color: hasError ? Colors.red : textFieldStyle.color,
    ),
    controller: controller,
    focusNode: focusNode,
    maxLines: 5,
    maxLength: 255,
    keyboardType: TextInputType.multiline,
    decoration: InputDecoration(
      filled: true,
      fillColor: color,
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      alignLabelWithHint: true,
      labelText: labelText,
      focusedBorder: OutlineInputBorder(
        borderRadius: kDefaultRadius,
        borderSide: BorderSide(
          color: hasError ? Colors.red : Colors.transparent,
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
        color: hasError ? Colors.red : textFieldStyle.color,
      ),
      hintStyle: textFieldStyle.copyWith(
        color: hasError ? Colors.red : textFieldStyle.color,
      ),
    ),
  );
}
