import 'package:flutter/material.dart';

class SubscribeScreen extends StatefulWidget {
  const SubscribeScreen({super.key});

  @override
  State<SubscribeScreen> createState() => _SubscribeScreenState();
}

class _SubscribeScreenState extends State<SubscribeScreen> {
  String _selectedOption = 'Yearly';

  void _selectOption(String option) {
    setState(() {
      _selectedOption = option;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black45),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            const Text(
              'Subscribe to Jarvis',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            // Description
            const Text(
              'Subscribe to send more messages without daily limits, access exclusive bots like GPT-4-Turbo and Claude-3-Opus, and more.',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 15),
            // Discount information
            const Text(
              'Enjoy 33% off with a yearly Jarvis subscription.',
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 20),
            // Yearly and Monthly Options
            _buildPricingOption(
              context,
              title: 'Yearly',
              price: '\$79.99/yr',
              isSelected: _selectedOption == 'Yearly',
              onTap: () => _selectOption('Yearly'),
            ),
            const SizedBox(height: 15),
            _buildPricingOption(
              context,
              title: 'Monthly',
              price: '\$9.99/mo',
              isSelected: _selectedOption == 'Monthly',
              onTap: () => _selectOption('Monthly'),
            ),
            const SizedBox(height: 10),
            // Enhanced ExpansionTile for "What's included?"
            ExpansionTile(
              title: const Text(
                'What\'s included?',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              children: [
                _buildIncludedItem(
                    'Send and receive far more messages each month'),
                _buildIncludedItem(
                    'Access exclusive bots, including GPT-4-Turbo'),
                _buildIncludedItem(
                    'Unlock each bot\'s maximum input size and chat history'),
                _buildIncludedItem('.....................'),
              ],
            ),
            const Spacer(),
            // Subscribe Button
            InkWell(
              borderRadius: BorderRadius.circular(50),
              onTap: () {
                setState(() {});
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(50),
                ),
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: const Center(
                  child: Text(
                    "Subscribe to Jarvis",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildPricingOption(BuildContext context,
      {required String title,
      required String price,
      required bool isSelected,
      required VoidCallback onTap}) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.shade50 : Colors.white,
          border: Border.all(
            color: isSelected ? Colors.blueAccent : Colors.black12,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.check_circle : Icons.circle_outlined,
              color: isSelected ? Colors.blueAccent : Colors.black26,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.blueAccent : Colors.black87,
                ),
              ),
            ),
            Text(
              price,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIncludedItem(String text) {
    return ListTile(
      leading: const Icon(Icons.check, color: Colors.blueAccent),
      title: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black87,
        ),
      ),
    );
  }
}
