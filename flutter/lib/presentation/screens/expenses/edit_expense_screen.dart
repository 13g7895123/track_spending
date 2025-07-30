import 'package:flutter/material.dart';

class EditExpenseScreen extends StatelessWidget {
  final String expenseId;
  
  const EditExpenseScreen({super.key, required this.expenseId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('編輯支出'),
      ),
      body: Center(
        child: Text('編輯支出功能開發中...\n支出ID: $expenseId'),
      ),
    );
  }
}