import 'package:flutter/material.dart';
import 'package:jarvis/providers/auth_provider.dart';
import 'package:jarvis/providers/prompt_provider.dart';
import 'package:jarvis/views/screens/home_screen.dart';
import 'package:jarvis/views/screens/login_register_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => PromptProvider()),
      ],
      child: const JarvisApp(),
    ),
  );
}

class JarvisApp extends StatefulWidget {
  const JarvisApp({super.key});

  @override
  State<JarvisApp> createState() => _JarvisAppState();
}

class _JarvisAppState extends State<JarvisApp> {
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.loadTokens();
    setState(() {
      _isLoggedIn = authProvider.isLoggedIn;
    });
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jarvis',
      debugShowCheckedModeBanner: false,
      home: _isLoggedIn ? HomeScreen() : const LoginRegisterScreen(),
    );
  }
}
