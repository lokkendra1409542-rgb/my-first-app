import 'package:flutter/material.dart';
import 'package:my_first_app/core/auth_store.dart';
import 'package:my_first_app/features/users/auth_api.dart';

class LoginSignupPage extends StatefulWidget {
  const LoginSignupPage({super.key});
  @override
  State<LoginSignupPage> createState() => _LoginSignupPageState();
}

class _LoginSignupPageState extends State<LoginSignupPage> {
  final _form = GlobalKey<FormState>();
  bool signup = false;
  bool loading = false;
  String? error;

  final nameC = TextEditingController();
  final emailC = TextEditingController();
  final passC = TextEditingController();

  final api = AuthApi();

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    setState(() {
      loading = true;
      error = null;
    });
    try {
      final token = signup
          ? await api.signup(nameC.text.trim(), emailC.text.trim(), passC.text)
          : await api.login(emailC.text.trim(), passC.text);
      await AuthStore.saveToken(token);
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, "/dashboard");
    } catch (e) {
      setState(() => error = e.toString());
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _form,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      signup ? "Sign Up" : "Login",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (signup)
                      TextFormField(
                        controller: nameC,
                        decoration: const InputDecoration(labelText: "Name"),
                        validator: (v) =>
                            v == null || v.trim().isEmpty ? "Required" : null,
                      ),
                    if (signup) const SizedBox(height: 8),
                    TextFormField(
                      controller: emailC,
                      decoration: const InputDecoration(labelText: "Email"),
                      validator: (v) =>
                          v == null ||
                              !RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(v)
                          ? "Invalid"
                          : null,
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: passC,
                      decoration: const InputDecoration(labelText: "Password"),
                      obscureText: true,
                      validator: (v) =>
                          v == null || v.length < 4 ? "Min 4 chars" : null,
                    ),
                    const SizedBox(height: 12),
                    if (error != null)
                      Text(error!, style: const TextStyle(color: Colors.red)),
                    const SizedBox(height: 8),
                    FilledButton(
                      onPressed: loading ? null : _submit,
                      child: loading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(signup ? "Create Account" : "Login"),
                    ),
                    TextButton(
                      onPressed: () => setState(() => signup = !signup),
                      child: Text(
                        signup ? "Have an account? Login" : "New user? Sign up",
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
