import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TestScreen extends StatelessWidget {
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Test')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => context.go('/test/detail'),
          child: const Text('Sang màn hình 2'),
        ),
      ),
    );
  }
}

class TestDetailScreen extends StatelessWidget {
  const TestDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Test Detail')),
      body: const Center(child: Text('Màn hình 2 — đơn giản nhất')),
    );
  }
}