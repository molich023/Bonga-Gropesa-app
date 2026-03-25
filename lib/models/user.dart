// lib/models/user.dart
class User {
  final String walletAddress;
  final String? username;
  final String? phoneNumber;
  final int groBalance;
  final bool isKYCVerified;

  User({
    required this.walletAddress,
    this.username,
    this.phoneNumber,
    this.groBalance = 0,
    this.isKYCVerified = false,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      walletAddress: json['walletAddress'],
      username: json['username'],
      phoneNumber: json['phoneNumber'],
      groBalance: json['groBalance'] ?? 0,
      isKYCVerified: json['isKYCVerified'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'walletAddress': walletAddress,
      'username': username,
      'phoneNumber': phoneNumber,
      'groBalance': groBalance,
      'isKYCVerified': isKYCVerified,
    };
  }
}
