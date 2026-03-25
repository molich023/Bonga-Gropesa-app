// lib/screens/redeem_screen.dart
Future<void> _redeemGRO(BuildContext context, int amount) async {
  // Check if user is KYC-verified
  final isVerified = await _checkKYCStatus();
  if (!isVerified) {
    Navigator.pushNamed(context, '/kyc');
    return;
  }
  // Proceed with redemption...
}
// lib/screens/redeem_screen.dart
class RedeemScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Redeem GRO')),
      body: Center(
        child: Column(
          children: [
            Text('100 GRO = 50 MB Safaricom Data'),
            ElevatedButton(
              onPressed: () => _redeemGRO(context, 100),
              child: Text('Redeem'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _redeemGRO(BuildContext context, int amount) async {
    final response = await http.post(
      Uri.parse('https://your-netlify-site.netlify.app/.netlify/functions/redeem-gro'),
      body: jsonEncode({
        'userAddress': '0xUserWalletAddress',
        'amount': amount,
        'phoneNumber': '+254712345678',
      }),
    );
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Redemption successful! Check your phone.')),
      );
    }
  }
}
