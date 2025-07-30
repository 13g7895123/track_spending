import 'package:flutter/material.dart';

class TagListScreen extends StatelessWidget {
  const TagListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('標籤管理'),
      ),
      body: const Center(
        child: Text('標籤管理功能開發中...'),
      ),
    );
  }
}