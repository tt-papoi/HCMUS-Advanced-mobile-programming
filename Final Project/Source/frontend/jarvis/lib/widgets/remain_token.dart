import 'package:flutter/material.dart';
import 'package:jarvis/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:jarvis/providers/token_provider.dart';
import 'package:jarvis/widgets/icons.dart';

class RemainToken extends StatefulWidget {
  const RemainToken({super.key});

  @override
  State<RemainToken> createState() => _RemainTokenState();
}

class _RemainTokenState extends State<RemainToken> {
  @override
  void initState() {
    super.initState();

    _checkAndUpdateTokens();
  }

  Future<void> _checkAndUpdateTokens() async {
    final tokenProvider = Provider.of<TokenProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    try {
      await authProvider.ensureValidToken();
    } catch (e) {
      //print('Error fetching chats: $e');
    }
    final accessToken = authProvider.accessToken;
    if (accessToken != null) {
      await tokenProvider.fetchTokenUsage(accessToken); // Gọi API
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TokenProvider>(
      builder: (context, tokenProvider, child) {
        final tokenUsage = tokenProvider.tokenUsage;

        if (tokenUsage == null) {
          return const CircularProgressIndicator(); // Hiển thị loading khi chưa có dữ liệu
        }
        int tokenCount = tokenUsage['availableTokens'] ?? 0;

        return Container(
          height: 25,
          alignment: const Alignment(0, 0),
          padding: const EdgeInsets.all(0),
          margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: const Color.fromARGB(15, 0, 0, 0),
          ),
          child: Row(
            children: [
              const SizedBox(width: 10),
              Text(
                style: const TextStyle(
                    color: Colors.black87, fontWeight: FontWeight.bold),
                '$tokenCount', // Hiển thị số token còn lại
              ),
              const SizedBox(width: 5),
              Icon(CustomIcons.coins, size: 10, color: Colors.deepOrange[800]),
              const SizedBox(width: 10),
            ],
          ),
        );
      },
    );
  }
}
