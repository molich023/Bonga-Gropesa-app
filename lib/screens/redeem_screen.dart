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
