// lib/screens/rewards_screen.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RewardsScreen extends StatefulWidget {
  final String userAddress;

  const RewardsScreen({Key? key, required this.userAddress}) : super(key: key);

  @override
  _RewardsScreenState createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen> {
  int _pendingGRO = 0;
  int _totalEarned = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRewards();
  }

  Future<void> _loadRewards() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _pendingGRO = prefs.getInt('pendingGRO') ?? 0;
      _totalEarned = prefs.getInt('totalEarnedGRO') ?? 0;
      _isLoading = false;
    });
  }

  Future<void> _claimRewards() async {
    setState(() => _isLoading = true);
    try {
      final response = await http.post(
        Uri.parse('https://your-netlify-site.netlify.app/.netlify/functions/sync-gro'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userAddress': widget.userAddress,
          'pendingGRO': _pendingGRO,
        }),
      );
      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('pendingGRO', 0);
        await prefs.setInt('totalEarnedGRO', _totalEarned + _pendingGRO);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Rewards claimed successfully!')),
        );
        _loadRewards();
      } else {
        throw Exception('Failed to claim rewards');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GroPesa Rewards'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadRewards,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const Text(
                            'Pending GRO Rewards',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '$_pendingGRO GRO',
                            style: const TextStyle(fontSize: 24, color: Colors.green),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _pendingGRO > 0 ? _claimRewards : null,
                            child: const Text('Claim Rewards'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const Text(
                            'Total GRO Earned',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '$_totalEarned GRO',
                            style: const TextStyle(fontSize: 24, color: Colors.blue),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'How to Earn GRO:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '• Send messages: 0.1 GRO per 10 messages\n'
                    '• Daily login: 1 GRO\n'
                    '• Invite friends: 10 GRO per referral\n'
                    '• Stake GRO: Up to 7% APY',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
    );
  }
}
