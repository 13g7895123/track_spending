import 'package:flutter/material.dart';

class AddTagScreen extends StatelessWidget {
  const AddTagScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('新增標籤'),
      ),
      body: const Center(
        child: Text('新增標籤功能開發中...'),
      ),
    );
  }
}