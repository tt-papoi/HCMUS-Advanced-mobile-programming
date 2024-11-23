import 'package:flutter/material.dart';
import 'package:jarvis/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:jarvis/providers/token_provider.dart';
import 'package:jarvis/widgets/icons.dart';

class TokenUsageCard extends StatefulWidget {
  const TokenUsageCard({super.key});

  @override
  State<TokenUsageCard> createState() => _TokenUsageCardState();
}

class _TokenUsageCardState extends State<TokenUsageCard> {
  late AuthProvider authProvider;

  @override
  void initState() {
    init();
    super.initState();
  }

  void init() async {
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    final tokenProvider = Provider.of<TokenProvider>(context, listen: false);
    tokenProvider.fetchTokenUsage(authProvider.accessToken!);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TokenProvider>(
      builder: (context, tokenProvider, child) {
        final tokenUsage = tokenProvider.tokenUsage;

        // Check if token usage is null or empty
        if (tokenUsage == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final int availableTokens = tokenUsage['availableTokens'] ?? 0;
        final int totalTokens = tokenUsage['totalTokens'] ?? 1; // Tránh chia 0
        final bool unlimited = tokenUsage['unlimited'] ?? false;

        return Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: const Color.fromARGB(15, 0, 0, 0),
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header với avatar và thông tin người dùng
              Row(
                children: [
                  const CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.blueAccent,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  const SizedBox(width: 12.0),
                  // Thông tin user
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 150.0, // Giới hạn chiều rộng
                        child: Text(
                          authProvider.username ?? 'User',
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis, // Cắt nếu dài
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      SizedBox(
                        width: 150.0, // Giới hạn chiều rộng
                        child: Text(
                          authProvider.email ?? 'Email',
                          style: const TextStyle(
                            fontSize: 14.0,
                            color: Colors.grey,
                          ),
                          overflow: TextOverflow.ellipsis, // Cắt nếu dài
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12.0),

              // Token Usage và thanh tiến trình
              Row(
                children: [
                  const Text(
                    'Token Usage',
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(CustomIcons.coins,
                      size: 14.0, color: Colors.deepOrange[800]),
                ],
              ),
              const SizedBox(height: 6.0),

              // Thanh tiến trình với giá trị token
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 80.0, // Giới hạn chiều rộng
                    child: Text(
                      unlimited ? 'Unlimited' : '$availableTokens',
                      style: const TextStyle(
                        overflow: TextOverflow.ellipsis, // Cắt nếu dài
                      ),
                      maxLines: 1,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: LinearProgressIndicator(
                        borderRadius: BorderRadius.circular(50.0),
                        value: unlimited ? 1.0 : availableTokens / totalTokens,
                        backgroundColor: Colors.black12,
                        color: Colors.blueAccent,
                        minHeight: 6.0,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 80.0, // Giới hạn chiều rộng
                    child: Text(
                      unlimited ? '∞' : '$totalTokens',
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                        overflow: TextOverflow.ellipsis, // Cắt nếu dài
                      ),
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
