import 'package:flutter/material.dart';
import 'package:jarvis/utils/fade_route.dart';
import 'package:jarvis/views/home_screen.dart';

class LoginRegisterScreen extends StatefulWidget {
  const LoginRegisterScreen({super.key});

  @override
  LoginRegisterScreenState createState() => LoginRegisterScreenState();
}

class LoginRegisterScreenState extends State<LoginRegisterScreen> {
  bool isLogin = true;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 40),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 10),
                  Text(
                    'Jarvis',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Sign-in with google
              ElevatedButton.icon(
                onPressed: () {},
                label: const Text('Sign in with Google'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.white,
                  elevation: 0,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  side: const BorderSide(color: Colors.grey),
                ),
              ),
              const Divider(height: 50, thickness: 1),

              // Switch button login-signup
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: const Color.fromARGB(148, 68, 137, 255)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildToggleButton('Login', isLogin),
                    _buildToggleButton('Register', !isLogin),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              if (!isLogin)
                _buildTextField('Username', 'Enter your username', false,
                    usernameController),
              _buildTextField(
                  'Email', 'Enter your email address', false, emailController),
              _buildTextField(
                  'Password', 'Enter your password', true, passwordController),
              const SizedBox(height: 20),

              // Login button
              ElevatedButton(
                onPressed: () {
                  if (isLogin) {
                    Navigator.push(context, FadeRoute(page: HomeScreen()));
                  } else {}
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  elevation: 0,
                ),
                child: Text(
                  isLogin ? 'Login' : 'Register',
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String hint, bool isPassword,
      TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          hintStyle: const TextStyle(color: Colors.black38),
          labelText: label,
          labelStyle: const TextStyle(
              color: Colors.black54, fontWeight: FontWeight.bold),
          hintText: hint,
          filled: true,
          fillColor: const Color.fromARGB(10, 0, 0, 0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildToggleButton(String text, bool isActive) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
        child: ElevatedButton(
          onPressed: () {
            setState(() {
              isLogin = text == 'Login';
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor:
                isActive ? Colors.blueAccent : const Color.fromARGB(0, 0, 0, 0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            elevation: 0,
          ),
          child: Text(
            text,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
