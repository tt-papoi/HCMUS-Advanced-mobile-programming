import 'package:flutter/material.dart';
import 'package:jarvis/views/screens/forgot_password_screen.dart';
import 'package:jarvis/utils/fade_route.dart';
import 'package:jarvis/views/screens/home_screen.dart';

class LoginRegisterScreen extends StatefulWidget {
  const LoginRegisterScreen({super.key});

  @override
  State<LoginRegisterScreen> createState() => _LoginRegisterScreenState();
}

class _LoginRegisterScreenState extends State<LoginRegisterScreen> {
  bool isLogin = true;
  bool isPasswordVisible = false;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();

  String? emailError;
  String? passwordError;

  void _clearTextFields() {
    emailController.clear();
    passwordController.clear();
    usernameController.clear();
    emailError = null;
    passwordError = null;
  }

  bool _validateEmail(String email) {
    final RegExp emailRegExp = RegExp(
      r'^[a-zA-Z0-9._]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
    );
    if (email.isEmpty || !emailRegExp.hasMatch(email)) {
      setState(() {
        emailError = 'Please enter a valid email address';
      });
      return false;
    }
    setState(() {
      emailError = null;
    });
    return true;
  }

  bool _validatePassword(String password) {
    if (password.isEmpty || password.length < 6) {
      setState(() {
        passwordError = 'Password must be at least 6 characters';
      });
      return false;
    }
    setState(() {
      passwordError = null;
    });
    return true;
  }

  void _onSubmit() {
    if (isLogin) {
      Navigator.push(context, FadeRoute(page: HomeScreen()));
    } else {
      if (_validateEmail(emailController.text) &&
          _validatePassword(passwordController.text)) {
        // Handle Register
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "lib/assets/icons/logo_blueAccent.png",
                    height: 35,
                    width: 35,
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Jarvis',
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent),
                  ),
                ],
              ),
              const SizedBox(height: 40),

              // Sign-in with Google
              InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  // Handle Google Sign-in
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.black12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "lib/assets/icons/google.png",
                        height: 15,
                        width: 15,
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Sign in with Google',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Center(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Divider(
                        color: Colors.grey,
                        thickness: 1,
                        endIndent: 10,
                      ),
                    ),
                    Text('or'),
                    Expanded(
                      child: Divider(
                        color: Colors.grey,
                        thickness: 1,
                        indent: 10,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Switch button login-signup
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: const Color.fromARGB(43, 68, 137, 255),
                ),
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
                  'Email', 'Enter your email address', false, emailController,
                  errorText: emailError),
              _buildTextField(
                  'Password', 'Enter your password', true, passwordController,
                  errorText: passwordError),

              const SizedBox(height: 5),

              if (isLogin) _buildForgotPasswordButton(),

              const SizedBox(height: 15),
              // Login/Register button
              InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: _onSubmit,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.blueAccent,
                  ),
                  child: Center(
                    child: Text(
                      isLogin ? 'Login' : 'Register',
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (!isLogin)
                const Text(
                  "By continuing, you agree to our Privacy policy",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black45),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForgotPasswordButton() {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {
        Navigator.push(context, FadeRoute(page: const ForgotPasswordScreen()));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color.fromARGB(0, 0, 0, 0),
        ),
        child: const Center(
          child: Text(
            "Forgot password?",
            style:
                TextStyle(fontWeight: FontWeight.bold, color: Colors.black45),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String hint, bool isPassword,
      TextEditingController controller,
      {String? errorText}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        onTapOutside: (event) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        controller: controller,
        obscureText: isPassword && !isPasswordVisible,
        decoration: InputDecoration(
          hintStyle: const TextStyle(
              color: Colors.black45, fontWeight: FontWeight.normal),
          labelText: label,
          labelStyle: const TextStyle(
              color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 14),
          hintText: hint,
          filled: true,
          fillColor: const Color.fromARGB(15, 0, 0, 0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Colors.black26,
                  ),
                  onPressed: () {
                    setState(() {
                      isPasswordVisible = !isPasswordVisible;
                    });
                  },
                )
              : null,
          errorText: errorText,
        ),
      ),
    );
  }

  Widget _buildToggleButton(String text, bool isActive) {
    return Expanded(
        child: Container(
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: isActive ? Colors.blueAccent : Colors.transparent,
        borderRadius: BorderRadius.circular(50),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(50),
        onTap: () {
          setState(() {
            isLogin = text == 'Login';
            _clearTextFields(); // Clear text fields on toggle
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                  color: isActive
                      ? const Color.fromARGB(255, 255, 255, 255)
                      : Colors.black54,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    ));
  }
}
