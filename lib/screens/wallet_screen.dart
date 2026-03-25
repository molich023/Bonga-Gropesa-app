// lib/screens/wallet_screen.dart
import 'package:flutter/material.dart';
import 'package:web3dart/web3dart.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';

class WalletScreen extends StatefulWidget {
  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  String? _walletAddress;
  BigInt _groBalance = BigInt.zero;
  final _walletConnect = WalletConnect(
    bridge: 'https://bridge.walletconnect.org',
    clientMeta: const PeerMeta(
      name: 'Bonga App',
      description: 'Connect your wallet to earn GRO',
      url: 'https://bonga.app',
      icons: ['https://bonga.app/logo.png'],
    ),
  );

  Future<void> _connectWallet() async {
    final session = await _walletConnect.createSession(
      onDisplayUri: (uri) => print('WalletConnect URI: $uri'),
    );
    final ethereumAddress = session.accounts.first;
    setState(() => _walletAddress = ethereumAddress);

    // Fetch GRO balance
    final client = Web3Client(
      'https://polygon-rpc.com/',
      Client(),
    );
    final groContract = DeployedContract(
      ContractAbi.fromJson(
        '[{"inputs":[{"name":"account","type":"address"}],"name":"balanceOf","outputs":[{"name":"","type":"uint256"}],"stateMutability":"view","type":"function"}]',
        'GRO',
      ),
      EthereumAddress.fromHex('0xYourGROContractAddress'),
    );
    final balance = await client.call(
      contract: groContract,
      function: groContract.function('balanceOf'),
      params: [EthereumAddress.fromHex(ethereumAddress!)],
    );
    setState(() => _groBalance = balance.first as BigInt);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Bonga Wallet')),
      body: Center(
        child: Column(
          children: [
            if (_walletAddress == null)
              ElevatedButton(
                onPressed: _connectWallet,
                child: Text('Connect Wallet'),
              )
            else ...[
              Text('Wallet: ${_walletAddress!.substring(0, 6)}...'),
              Text('GRO Balance: ${_groBalance / BigInt.from(1e18)}'),
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/redeem'),
                child: Text('Redeem GRO'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
