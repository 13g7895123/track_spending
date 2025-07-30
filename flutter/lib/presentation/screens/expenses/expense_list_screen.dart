import 'package:flutter/material.dart';

class ExpenseListScreen extends StatelessWidget {
  const ExpenseListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('支出列表'),
      ),
      body: const Center(
        child: Text('支出列表功能開發中...'),
      ),
    );
  }
}