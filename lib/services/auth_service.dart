// lib/services/auth_service.dart
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web3dart/web3dart.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';

class AuthService {
  static const String _walletAddressKey = 'walletAddress';
  static const String _privateKeyKey = 'privateKey';

  // Connect wallet via WalletConnect
  Future<String?> connectWallet() async {
    final session = await WalletConnect(
      bridge: 'https://bridge.walletconnect.org',
      clientMeta: const PeerMeta(
        name: 'Bonga App',
        description: 'Connect your wallet to earn GRO',
        url: 'https://bonga.app',
        icons: ['https://bonga.app/logo.png'],
      ),
    ).createSession(
      onDisplayUri: (uri) => print('WalletConnect URI: $uri'),
    );
    final walletAddress = session.accounts.first;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_walletAddressKey, walletAddress);
    return walletAddress;
  }

  // Get saved wallet address
  Future<String?> getWalletAddress() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_walletAddressKey);
  }

  // Save private key (encrypted)
  Future<void> savePrivateKey(String privateKey) async {
    final prefs = await SharedPreferences.getInstance();
    // Note: In production, encrypt the private key before saving!
    await prefs.setString(_privateKeyKey, privateKey);
  }

  // Get saved private key
  Future<String?> getPrivateKey() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_privateKeyKey);
  }

  // Clear auth data
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_walletAddressKey);
    await prefs.remove(_privateKeyKey);
  }

  // Get Web3Client instance
  Future<Web3Client> getWeb3Client() async {
    final rpcUrl = 'https://polygon-rpc.com/';
    return Web3Client(rpcUrl, http.Client());
  }

  // Get GRO contract instance
  Future<DeployedContract> getGROContract(Web3Client client) async {
    return DeployedContract(
      ContractAbi.fromJson(
        '''[
          {
            "inputs": [],
            "name": "balanceOf",
            "outputs": [{"name": "", "type": "uint256"}],
            "stateMutability": "view",
            "type": "function"
          }
        ]''',
        'GRO',
      ),
      EthereumAddress.fromHex('0xYourGROContractAddress'),
    );
  }
}
