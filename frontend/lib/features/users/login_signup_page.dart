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
  bool signup = false, loading = false;
  String? error;

  final nameC = TextEditingController();
  final emailC = TextEditingController();
  final passC = TextEditingController();
  final api = AuthApi();

  @override
  void dispose() {
    nameC.dispose();
    emailC.dispose();
    passC.dispose();
    super.dispose();
  }

  void _clearAllFields() {
    nameC.clear();
    emailC.clear();
    passC.clear();
    // keyboard/IME dismiss
    FocusScope.of(context).unfocus();
  }

  void _toggleMode() {
    setState(() {
      signup = !signup;
      _clearAllFields(); // ⇐ mode बदलते ही fields खाली
      error = null;
    });
  }

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    setState(() {
      loading = true;
      error = null;
    });

    try {
      if (signup) {
        // SIGNUP → token save नहीं; success पर login mode दिखे + fields clear
        await api.signup(nameC.text.trim(), emailC.text.trim(), passC.text);
        if (!mounted) return;
        _clearAllFields(); // ⇐ signup के बाद inputs खाली
        setState(() => signup = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Account created. Please log in.")),
        );
      } else {
        // LOGIN → token save + dashboard
        final token = await api.login(emailC.text.trim(), passC.text);
        await AuthStore.saveToken(token);
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, "/dashboard");
      }
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
                child: AutofillGroup(
                  // optional: group, नीचे fields में autofillHints off
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
                          textInputAction: TextInputAction.next,
                          autofillHints: const <String>[], // disable autofill
                          validator: (v) =>
                              v == null || v.trim().isEmpty ? "Required" : null,
                        ),

                      if (signup) const SizedBox(height: 8),

                      TextFormField(
                        controller: emailC,
                        decoration: const InputDecoration(labelText: "Email"),
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        autofillHints: const <String>[], // disable autofill
                        enableSuggestions: false,
                        autocorrect: false,
                        validator: (v) =>
                            v == null ||
                                !RegExp(
                                  r'^[^\s@]+@[^\s@]+\.[^\s@]+$',
                                ).hasMatch(v)
                            ? "Invalid"
                            : null,
                      ),
                      const SizedBox(height: 8),

                      TextFormField(
                        controller: passC,
                        decoration: const InputDecoration(
                          labelText: "Password",
                        ),
                        obscureText: true,
                        textInputAction: TextInputAction.done,
                        autofillHints: const <String>[], // disable autofill
                        enableSuggestions: false,
                        autocorrect: false,
                        onFieldSubmitted: (_) => _submit(),
                        validator: (v) =>
                            v == null || v.length < 4 ? "Min 4 chars" : null,
                      ),

                      const SizedBox(height: 12),

                      if (error != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            error!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),

                      FilledButton(
                        onPressed: loading ? null : _submit,
                        child: loading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(signup ? "Create Account" : "Login"),
                      ),

                      TextButton(
                        onPressed: _toggleMode,
                        child: Text(
                          signup
                              ? "Have an account? Login"
                              : "New user? Sign up",
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
