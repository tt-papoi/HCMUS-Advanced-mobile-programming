import 'package:flutter/material.dart';
import 'package:jarvis/providers/auth_provider.dart';
import 'package:jarvis/utils/fade_route.dart';
import 'package:jarvis/views/screens/login_register_screen.dart';
import 'package:jarvis/views/screens/support_screen.dart';
import 'package:jarvis/widgets/token_usage_card.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late AuthProvider authProvider;

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);
  }

  int currentToken = 30;
  final int maxToken = 50;

  void _logout(BuildContext context) {
    authProvider.logout();
    Navigator.pushAndRemoveUntil(
      context,
      FadeRoute(page: const LoginRegisterScreen()),
      (route) => false,
    );
  }

  void _changePassword(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('Change Password',
              style: TextStyle(color: Colors.black87, fontSize: 20)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(
                  hintText: 'Email',
                  hintStyle: const TextStyle(
                      color: Colors.black45, fontWeight: FontWeight.normal),
                  filled: true,
                  fillColor: const Color.fromARGB(15, 0, 0, 0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  hintText: 'New Password',
                  hintStyle: const TextStyle(
                      color: Colors.black45, fontWeight: FontWeight.normal),
                  filled: true,
                  fillColor: const Color.fromARGB(15, 0, 0, 0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
                obscureText: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child:
                  const Text('Cancel', style: TextStyle(color: Colors.black54)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent, elevation: 0),
              onPressed: () {
                // Xử lý logic đổi mật khẩu tại đây
                Navigator.pop(context);
              },
              child: const Text(
                'Change Password',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        shadowColor: Colors.white,
        backgroundColor: Colors.white,
        title: const Text(
          "Profile",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TokenUsageCard(),
            const SizedBox(height: 20),
            const Text(
              "Account",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),
            ListTile(
              tileColor: const Color.fromARGB(10, 0, 0, 0),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              leading: const Icon(Icons.logout, color: Colors.blueAccent),
              title: const Text(
                'Log out',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54),
              ),
              onTap: () => _logout(context),
            ),
            const Divider(
              indent: 0,
              thickness: 0,
              endIndent: 0,
              height: 0,
            ),
            ListTile(
              tileColor: const Color.fromARGB(10, 0, 0, 0),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              leading: const Icon(Icons.lock, color: Colors.blueAccent),
              title: const Text(
                'Change Password',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54),
              ),
              onTap: () => _changePassword(context),
            ),
            const SizedBox(height: 20),
            const Text(
              "Support",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),
            ListTile(
              tileColor: const Color.fromARGB(10, 0, 0, 0),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(12),
                  topLeft: Radius.circular(12),
                ),
              ),
              leading: const Icon(Icons.settings, color: Colors.blueAccent),
              title: const Text(
                'Settings',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54),
              ),
              onTap: () => (context),
            ),
            const Divider(
              indent: 0,
              thickness: 0,
              endIndent: 0,
              height: 0,
            ),
            ListTile(
              tileColor: const Color.fromARGB(10, 0, 0, 0),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              leading: const Icon(Icons.help, color: Colors.blueAccent),
              title: const Text(
                'Help',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54),
              ),
              onTap: () => Navigator.push(
                  context, FadeRoute(page: const SupportScreen())),
            ),
            const SizedBox(height: 20),
            const Text(
              "About",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),
            ListTile(
              tileColor: const Color.fromARGB(10, 0, 0, 0),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              leading: const Icon(Icons.privacy_tip, color: Colors.blueAccent),
              title: const Text(
                'Privacy Policy',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54),
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: Colors.white,
                      title: const Text(
                        'Privacy Policy',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      content:
                          const Text('Privacy Policy and other information.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Close',
                            style: TextStyle(color: Colors.black54),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            const Divider(
              indent: 0,
              thickness: 0,
              endIndent: 0,
              height: 0,
            ),
            ListTile(
              tileColor: const Color.fromARGB(10, 0, 0, 0),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              leading: Image.asset(
                "lib/assets/icons/logo_blueAccent.png",
                height: 20,
                width: 20,
              ),
              title: const Text(
                'Version',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54),
              ),
              trailing: const Text(
                "1.0.0",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
