import 'package:flutter/material.dart';
import 'package:focusmode/models/requests/UserCreateRequest.dart';
import 'package:focusmode/models/requests/UserLoginRequest.dart';
import 'package:focusmode/services/ApiErrorMapper.dart';
import 'package:focusmode/services/ApiService.dart';
import 'package:focusmode/ui/AppToast.dart';
import 'package:focusmode/ui/AppTextField.dart';
import 'package:focusmode/views/Login.dart';
import 'package:focusmode/views/Permiso.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final ApiService _apiService = ApiService();

  bool _isLoading = false;

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final request = UserCreateRequest(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      await _apiService.signUp(request);

      await _apiService.login(
        UserLoginRequest(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        ),
      );

      if (!mounted) {
        return;
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Permiso()),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      AppToast.showError(context, ApiErrorMapper.toFriendlyMessage(error));
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Column(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF6C63FF),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text("Back", style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Color(0xFF232946),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      "Create a new Account",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Already Registered? Log in here.",
                      style: TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 30),
                    AppTextField(
                      hint: "Name",
                      controller: _nameController,
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return "El nombre es requerido";
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      hint: "Email",
                      controller: _emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return "El email es requerido";
                        if (!value.contains('@'))
                          return "Ingresa un email válido";
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      hint: "Password",
                      controller: _passwordController,
                      isPassword: true,
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return "La contraseña es requerida";
                        if (value.length < 6) return "Mínimo 6 caracteres";
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),
                    Container(
                      width: double.infinity,
                      height: 55,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF6C63FF), Color(0xFF7F7BFF)],
                        ),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(30),
                          onTap: _isLoading ? null : _signUp,
                          child: Center(
                            child: _isLoading
                                ? const SizedBox(
                                    height: 22,
                                    width: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text(
                                    "Sign Up",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => const Login()),
                          );
                        },
                        child: const Text(
                          "Already have an account? Login",
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
