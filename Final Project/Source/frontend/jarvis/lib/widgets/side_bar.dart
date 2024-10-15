// ignore: unnecessary_import
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jarvis/utils/fade_route.dart';
import 'package:jarvis/views/all_chats_screen.dart';
import 'package:jarvis/widgets/icons.dart';
import 'package:jarvis/widgets/token_usage_card.dart';

class SideBar extends StatelessWidget {
  const SideBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            const TokenUsageCard(),
            _buildExploreAndMyBotRow(),
            const SizedBox(height: 10.0),

            // navigate to all chats screen
            _buildListTile(
              icon: Icons.chat_outlined,
              title: 'All chats',
              customOnTap: () => _navigateTo(context, AllChatsScreen()),
            ),

            // navigate to AI Tools screen
            _buildListTile(
              icon: Icons.handyman_outlined,
              title: 'AI Tools',
              customOnTap: () {
                // Add your navigation logic here
              },
            ),

            // navigate to Profile screen
            _buildListTile(
              icon: Icons.person_outline,
              title: 'Profile',
              customOnTap: () {
                // Add your navigation logic here
              },
            ),

            // navigate to Settings screen
            _buildListTile(
              icon: Icons.settings,
              title: 'Settings',
              customOnTap: () {
                // Add your navigation logic here
              },
            ),
          ],
        ),
      ),
    );
  }

  void _navigateTo(BuildContext context, Widget screen) {
    Navigator.pop(context);
    Navigator.push(
      context,
      FadeRoute(page: screen),
    );
  }

  Widget _buildExploreAndMyBotRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        children: [
          _buildExploreContainer(),
          const SizedBox(width: 10.0),
          _buildMyBotContainer(),
        ],
      ),
    );
  }

  Widget _buildExploreContainer() {
    return _buildContainer(
      icon: CustomIcons.search,
      text: 'Explore',
      trailingIcon: Icons.arrow_forward_ios,
      onTap: () {
        // Add your logic here
      },
    );
  }

  Widget _buildMyBotContainer() {
    return _buildContainer(
      icon: CustomIcons.robot,
      text: 'My bots',
      trailingIcon: Icons.add,
      onTap: () {
        // Add your logic here
      },
    );
  }

  Widget _buildContainer(
      {required IconData icon,
      required String text,
      required IconData trailingIcon,
      required VoidCallback onTap}) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(12.0),
        onTap: onTap,
        child: Container(
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
        ),
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    required VoidCallback customOnTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      onTap: customOnTap,
    );
  }
}
