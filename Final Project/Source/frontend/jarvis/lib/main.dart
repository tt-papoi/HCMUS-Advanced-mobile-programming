import 'package:flutter/material.dart';
import 'package:jarvis/providers/auth_provider.dart';
import 'package:jarvis/views/screens/login_register_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const JarvisApp(),
    ),
  );
}

class JarvisApp extends StatelessWidget {
  const JarvisApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Jarvis',
      debugShowCheckedModeBanner: false,
      home: LoginRegisterScreen(),
    );
  }
}
