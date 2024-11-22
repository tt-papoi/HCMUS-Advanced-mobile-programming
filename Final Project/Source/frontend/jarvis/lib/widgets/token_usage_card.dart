import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:jarvis/providers/token_provider.dart';
import 'package:jarvis/widgets/icons.dart';

class TokenUsageCard extends StatelessWidget {
  const TokenUsageCard({super.key});

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
        final int totalTokens = tokenUsage['totalTokens'] ?? 0;
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
              const Row(
                children: [
                  // Profile Icon
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.blueAccent,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  SizedBox(width: 12.0),
                  // User Info
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'trantien4868',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4.0),
                      Text(
                        'trantien4868@gmail.com',
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12.0),
              // Token Usage and Progress Bar
              Row(
                children: [
                  const Text(
                    'Token Usage',
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Icon(CustomIcons.coins,
                      size: 14.0, color: Colors.deepOrange[800]),
                ],
              ),
              const SizedBox(height: 6.0),
              // Progress bar with token count
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(unlimited
                      ? 'Unlimited'
                      : '$availableTokens'), // Unlimited or token count
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
                  Text(unlimited
                      ? '∞'
                      : '$totalTokens'), // Max token or infinity
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
