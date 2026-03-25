// lib/services/rewards_service.dart
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RewardsService {
  // Earn GRO for sending messages
  Future<void> earnForMessages(int messageCount) async {
    final prefs = await SharedPreferences.getInstance();
    final pendingGRO = prefs.getInt('pendingGRO') ?? 0;
    final newGRO = pendingGRO + (messageCount ~/ 10); // 0.1 GRO per 10 messages
    await prefs.setInt('pendingGRO', newGRO);
  }

  // Earn GRO for daily login
  Future<void> earnForDailyLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final lastLogin = prefs.getString('lastLoginDate');
    final today = DateTime.now().toIso8601String().substring(0, 10);
    if (lastLogin != today) {
      final pendingGRO = prefs.getInt('pendingGRO') ?? 0;
      await prefs.setInt('pendingGRO', pendingGRO + 1); // 1 GRO/day
      await prefs.setString('lastLoginDate', today);
    }
  }

  // Earn GRO for referrals
  Future<void> earnForReferral() async {
    final prefs = await SharedPreferences.getInstance();
    final pendingGRO = prefs.getInt('pendingGRO') ?? 0;
    await prefs.setInt('pendingGRO', pendingGRO + 10); // 10 GRO per referral
  }

  // Sync pending GRO with blockchain
  Future<void> syncPendingGRO(String userAddress) async {
    final prefs = await SharedPreferences.getInstance();
    final pendingGRO = prefs.getInt('pendingGRO') ?? 0;
    if (pendingGRO > 0) {
      final response = await http.post(
        Uri.parse('https://your-netlify-site.netlify.app/.netlify/functions/sync-gro'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userAddress': userAddress,
          'pendingGRO': pendingGRO,
        }),
      );
      if (response.statusCode == 200) {
        await prefs.setInt('pendingGRO', 0);
        final totalEarned = prefs.getInt('totalEarnedGRO') ?? 0;
        await prefs.setInt('totalEarnedGRO', totalEarned + pendingGRO);
      }
    }
  }

  // Get pending GRO rewards
  Future<int> getPendingGRO() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('pendingGRO') ?? 0;
  }

  // Get total GRO earned
  Future<int> getTotalEarnedGRO() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('totalEarnedGRO') ?? 0;
  }
}
