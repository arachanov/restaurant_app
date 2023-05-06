import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'model/user.dart';
import 'home_page.dart';
import 'db/database.dart';

// Providers
// Provider
// StateProvider
// StateNotifier & StateNotifierProvider

final userProvider = StateNotifierProvider<UserNotifier, User>(((ref) => UserNotifier()));

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Restaraunt booking',
      home: MyHomePage(),
    );
  }
}