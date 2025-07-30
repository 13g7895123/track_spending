import 'package:flutter/material.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('數據分析'),
      ),
      body: const Center(
        child: Text('數據分析功能開發中...'),
      ),
    );
  }
}