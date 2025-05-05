import 'package:flutter/material.dart';
import 'package:photo_beza_gallery/components/show_error.dart';
import 'package:photo_beza_gallery/views/screen/Auth/pages/login_view.dart';
import 'package:photo_beza_gallery/views/shared/form_input_field.dart';
import 'package:photo_beza_gallery/services/auth_services.dart';
import 'package:toastification/toastification.dart';

class SignupView extends StatefulWidget {
  const SignupView({Key? key}) : super(key: key);

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final AuthService _authService = AuthService();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isLoading = false;
  bool _obscureText = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _signup() async {
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
          showToast(ToastificationType.error, "All fields are required.");
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      showToast(ToastificationType.error, "Passwords do not match.");
      return;
    }

    setState(() => _isLoading = true);

    String? result = await _authService.signup(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      phone: _phoneController.text.trim(),
    );

    setState(() => _isLoading = false);

    if (result == null) {
      showToast(ToastificationType.success, 'Signup successful');
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginView()));
    } else {
      showError(result);
    }
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
                'Sign Up',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              FormInputField(label: 'Full Name', controller: _nameController),
              const SizedBox(height: 20),
              FormInputField(label: 'Email', controller: _emailController),
              const SizedBox(height: 20),
              FormInputField(label: 'Phone Number', controller: _phoneController),
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
              const SizedBox(height: 20),
              FormInputField(
                label: 'Confirm Password', 
                controller: _confirmPasswordController, 
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
                        onPressed: _signup,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          textStyle: const TextStyle(fontSize: 18),
                          foregroundColor: Colors.white,
                          backgroundColor: const Color(0xFF093945),// Changed gradient to solid color
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text('Sign Up'),
                      ),
                    ),

              const SizedBox(height: 15),
              TextButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginView())),
                child: const Text('Already have an account? Log in'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
