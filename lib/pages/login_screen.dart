import 'package:flutter/material.dart';

import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();
  bool _isRegister = false;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(
                  flex: 10,
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter email';
                    }
                    return null;
                  },
                  controller: _emailController,
                  decoration: const InputDecoration(
                    hintText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
                const Spacer(),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter password';
                    }
                    return null;
                  },
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    hintText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                ),
                const Spacer(
                  flex: 1,
                ),
                _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : _isRegister
                        ? ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  _isLoading = true;
                                });
                                await AuthService()
                                    .register(
                                        email: _emailController.text.trim(),
                                        password:
                                            _passwordController.text.trim())
                                    .then((value) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(value ?? ''),
                                    ),
                                  );
                                  _emailController.clear();
                                  _passwordController.clear();
                                });
                                setState(() {
                                  _isLoading = false;
                                });
                              }
                            },
                            child: const Text('Register'),
                          )
                        : ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  _isLoading = true;
                                });
                                await AuthService()
                                    .signIn(
                                        email: _emailController.text.trim(),
                                        password:
                                            _passwordController.text.trim())
                                    .then(
                                      (value) => ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(value),
                                        ),
                                      ),
                                    );
                                _emailController.clear();
                                _passwordController.clear();
                                setState(() {
                                  _isLoading = false;
                                });
                              }
                            },
                            child: const Text('Login'),
                          ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isRegister = !_isRegister;
                    });
                  },
                  child: Text(
                      !_isRegister ? 'Create a new account' : 'Back to login'),
                ),
                const Spacer(
                  flex: 10,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
