import 'dart:convert';
import 'package:flutter/cupertino.dart';

void prettyPrint(String title, jsonData) {
  JsonEncoder encoder = const JsonEncoder.withIndent('  ');
  String prettyprint = encoder.convert(jsonData);
  debugPrint("$title $prettyprint");
}
