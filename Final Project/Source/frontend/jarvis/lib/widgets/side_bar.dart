import 'package:flutter/material.dart';
import 'package:jarvis/widgets/icons.dart';
import 'package:jarvis/widgets/token_usage_card.dart';

class SideBar extends StatelessWidget {
  const SideBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            const TokenUsageCard(),
            Column(
              children: [
                Row(
                  children: [
                    const SizedBox(width: 10.0),
                    _buildExploreContainer(),
                    const SizedBox(width: 10.0),
                    _buildMyBotContainer(),
                    const SizedBox(width: 10.0),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            _buildListTile(icon: Icons.chat_outlined, title: 'All chats'),
            _buildListTile(icon: Icons.handyman_outlined, title: 'AI Tools'),
            _buildListTile(icon: Icons.person_outline, title: 'Profile'),
            _buildListTile(icon: Icons.settings, title: 'Settings'),
          ],
        ),
      ),
    );
  }

  Widget _buildExploreContainer() {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(12.0),
        onTap: () {
          // Handler
        },
        child: _buildContainer(
          icon: CustomIcons.search,
          text: 'Explore',
          trailingIcon: Icons.arrow_forward_ios,
        ),
      ),
    );
  }

  Widget _buildMyBotContainer() {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(12.0),
        onTap: () {
          // Handler
        },
        child: _buildContainer(
          icon: CustomIcons.robot,
          text: 'My bots',
          trailingIcon: Icons.add,
        ),
      ),
    );
  }

  Widget _buildContainer(
      {required IconData icon,
      required String text,
      required IconData trailingIcon}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(10, 0, 0, 0),
        borderRadius: BorderRadius.circular(12.0),
      ),
      padding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon),
          const SizedBox(height: 8.0),
          Row(
            children: [
              Text(
                text,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Icon(
                trailingIcon,
                size: 15.0,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildListTile({required IconData icon, required String title}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      onTap: () {
        // Handle your onTap here
      },
    );
  }
}
