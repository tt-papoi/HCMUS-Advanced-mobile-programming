import 'package:flutter/material.dart';
import 'package:jarvis/utils/fade_route.dart';
import 'package:jarvis/views/all_chats_screen.dart';
import 'package:jarvis/views/explore_screen.dart';
import 'package:jarvis/views/mybot_screen.dart';
import 'package:jarvis/views/profile_screen.dart';
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

            _buildExploreAndMyBotRow(context),
            const SizedBox(height: 10.0),

            // navigate to all chats screen
            _buildListTile(
              icon: Icons.chat_outlined,
              title: 'All chats',
              customOnTap: () => _navigateTo(context, AllChatsScreen()),
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

  Widget _buildExploreAndMyBotRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        children: [
          _buildExploreContainer(context),
          const SizedBox(width: 10.0),
          _buildMyBotContainer(context),
        ],
      ),
    );
  }

  Widget _buildExploreContainer(BuildContext context) {
    return _buildContainer(
      icon: CustomIcons.search,
      text: 'Explore',
      trailingIcon: Icons.arrow_forward_ios,
      onTap: () {
        _navigateTo(context, const ExploreScreen());
      },
    );
  }

  Widget _buildMyBotContainer(BuildContext context) {
    return _buildContainer(
      icon: CustomIcons.robot,
      text: 'My bots',
      trailingIcon: Icons.add,
      onTap: () => _navigateTo(context, const MybotScreen()),
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
            color: const Color.fromARGB(15, 0, 0, 0),
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
