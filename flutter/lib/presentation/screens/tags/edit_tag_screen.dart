import 'package:flutter/material.dart';

class EditTagScreen extends StatelessWidget {
  final String tagId;
  
  const EditTagScreen({super.key, required this.tagId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('編輯標籤'),
      ),
      body: Center(
        child: Text('編輯標籤功能開發中...\n標籤ID: $tagId'),
      ),
    );
  }
}