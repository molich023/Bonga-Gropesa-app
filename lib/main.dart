
// lib/main.dart
import 'package:flutter/material.dart';
import 'package:bonga_gropesa/screens/chat_screen.dart';
import 'package:bonga_gropesa/screens/rewards_screen.dart';
import 'package:bonga_gropesa/screens/profile_screen.dart';
import 'package:bonga_gropesa/screens/kyc_screen.dart';

void main() {
  runApp(const BongaApp());
}

class BongaApp extends StatelessWidget {
  const BongaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bonga + GroPesa',
      theme: ThemeData(primarySwatch: Colors.green),
      initialRoute: '/chat',
      routes: {
        '/chat': (context) => const ChatScreen(),
        '/rewards': (context) => const RewardsScreen(userAddress: '0xUserAddress'),
        '/profile': (context) => const ProfileScreen(userAddress: '0xUserAddress'),
        '/kyc': (context) => const KYCScreen(),
      },
    );
  }
}
