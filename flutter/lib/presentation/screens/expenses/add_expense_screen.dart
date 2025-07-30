import 'package:flutter/material.dart';

class AddExpenseScreen extends StatelessWidget {
  const AddExpenseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('新增支出'),
      ),
      body: const Center(
        child: Text('新增支出功能開發中...'),
      ),
    );
  }
}