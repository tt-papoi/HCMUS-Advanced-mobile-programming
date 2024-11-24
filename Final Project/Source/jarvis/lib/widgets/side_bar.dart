import 'package:flutter/material.dart';
import 'package:jarvis/utils/fade_route.dart';
import 'package:jarvis/views/screens/all_chats_screen.dart';
import 'package:jarvis/views/screens/mybot_screen.dart';
import 'package:jarvis/views/screens/profile_screen.dart';
import 'package:jarvis/views/screens/subscribe_screen.dart';
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
            Container(
              margin: const EdgeInsets.all(10),
              child: const TokenUsageCard(),
            ),

            _buildListTile(
              icon: CustomIcons.robot,
              title: 'My bots',
              customOnTap: () {
                _navigateTo(context, const MybotScreen());
              },
            ),
            // navigate to all chats screen
            _buildListTile(
              icon: Icons.chat_outlined,
              title: 'All chats',
              customOnTap: () => _navigateTo(context, const AllChatsScreen()),
            ),

            // navigate to Profile screen
            _buildListTile(
              icon: Icons.person_outline,
              title: 'Profile',
              customOnTap: () {
                _navigateTo(context, const ProfileScreen());
              },
            ),

            // navigate to Subcribe screen
            _buildListTile(
              icon: Icons.assistant_rounded,
              title: 'Subscribe',
              customOnTap: () {
                _navigateTo(context, const SubscribeScreen());
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

  Widget _buildListTile({
    required IconData icon,
    required String title,
    required VoidCallback customOnTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        size: 22,
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      onTap: customOnTap,
    );
  }
}
