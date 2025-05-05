import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:photo_beza_gallery/components/show_error.dart';
import 'package:photo_beza_gallery/views/screen/Auth/pages/signup_view.dart';
import 'package:photo_beza_gallery/views/screen/Main%20Sreen/app_main_screen.dart';
import 'package:photo_beza_gallery/views/shared/form_input_field.dart';
import 'package:photo_beza_gallery/services/auth_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toastification/toastification.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final AuthService _authService = AuthService();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscureText = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      showError("Email and password are required.");
      return;
    }

    setState(() => _isLoading = true);

    try {
      final loginResult = await _authService.login(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (loginResult == 'Admin') {
        //_navigateToAdminPage();
      } else if (loginResult == 'user') {
        await _navigateToHomePage();
         final prefs = await SharedPreferences.getInstance();
          prefs.setBool("isLoggedIn", true);
      } else {
        showError(loginResult);
      }
    } on FirebaseAuthException catch (e) {
      showError("Authentication Error: ${e.message}");
    } catch (e) {
      showError("An unexpected error occurred: ${e.toString()}");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _navigateToHomePage() async {
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => AppMainScreen()),
    );
    _showToast(ToastificationType.success, "Logged in successfully!");
  }

  void _showToast(ToastificationType type, String message) {
    toastification.show(
      type: type,
      description: Text(message),
      autoCloseDuration: const Duration(seconds: 3),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: const AssetImage('assets/images/pblogo.png'),
              ),
              const Text(
                'Log In',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              FormInputField(label: 'Email', controller: _emailController),
              const SizedBox(height: 20),
              FormInputField(
                label: 'Password',
                controller: _passwordController,
                isPassword: _obscureText,
                suffixIcon: IconButton(
                  icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
                  onPressed: () => setState(() => _obscureText = !_obscureText),
                ),
              ),
              const SizedBox(height: 25),

              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SizedBox(
                      width: double.infinity,
                      height: 50.0,
                      child: ElevatedButton(
                        onPressed: _login,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          textStyle: const TextStyle(fontSize: 18),
                          foregroundColor: Colors.white,
                          backgroundColor: const Color(0xFF093945),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text('Log In'),
                      ),
                    ),

              const SizedBox(height: 15),
              TextButton(
                onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const SignupView())),
                child: const Text("Don't have an account? Sign Up"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
