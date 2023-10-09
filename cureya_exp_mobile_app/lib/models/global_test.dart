// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

@immutable
class GlobalDiagnosisTest {
  late String id;
  late String testCode;
  late String testName;
  String? attribute;
  String? createdAt;
  String? updatedAt;

  GlobalDiagnosisTest({
    required this.id,
    required this.testCode,
    required this.testName,
    this.attribute,
    this.createdAt,
    this.updatedAt,
  });

  GlobalDiagnosisTest.fromMap(Map globalDiagnosisTest) {
    id = globalDiagnosisTest['id'];
    testCode = globalDiagnosisTest['test_code'];
    testName = globalDiagnosisTest['test_name'];
    attribute = globalDiagnosisTest['attribute'];
    createdAt = globalDiagnosisTest['createdAt'];
    updatedAt = globalDiagnosisTest['updatedAt'];
  }
}