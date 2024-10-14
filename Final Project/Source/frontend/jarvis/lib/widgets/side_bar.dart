import 'package:flutter/material.dart';
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

            // navigate to all chats screen
            _buildListTile(
                icon: Icons.chat_outlined,
                title: 'All chats',
                customOnTap: () {
                  if (Scaffold.of(context).isDrawerOpen) {
                    Scaffold.of(context).closeDrawer();
                  }
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AllChatsScreen()));
                }),

            // navigate to AI Tools screen
            _buildListTile(
                icon: Icons.handyman_outlined,
                title: 'AI Tools',
                customOnTap: () {}),

            // navigate to Profile screen
            _buildListTile(
                icon: Icons.person_outline,
                title: 'Profile',
                customOnTap: () {}),

            // navigate to Settings screen
            _buildListTile(
                icon: Icons.settings, title: 'Settings', customOnTap: () {}),
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

  Widget _buildListTile(
      {required IconData icon,
      required String title,
      required VoidCallback customOnTap}) {
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
