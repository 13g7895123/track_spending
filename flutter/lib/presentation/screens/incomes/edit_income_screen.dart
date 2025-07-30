import 'package:flutter/material.dart';

class EditIncomeScreen extends StatelessWidget {
  final String incomeId;
  
  const EditIncomeScreen({super.key, required this.incomeId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('編輯收入'),
      ),
      body: Center(
        child: Text('編輯收入功能開發中...\n收入ID: $incomeId'),
      ),
    );
  }
}