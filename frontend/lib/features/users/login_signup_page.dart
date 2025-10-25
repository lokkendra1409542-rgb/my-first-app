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
      body: LayoutBuilder(
        builder: (context, constraints) {
          final showInfoPanel = constraints.maxWidth >= 920;
          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0D4E81), Color(0xFF1876C1)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1100),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: Material(
                    elevation: 12,
                    shadowColor: Colors.black26,
                    child: SizedBox(
                      height: showInfoPanel ? 560 : null,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (showInfoPanel)
                            Expanded(
                              child: _BrandPanel(onToggle: _toggleMode, signup: signup),
                            ),
                          Expanded(
                            child: _AuthForm(
                              formKey: _form,
                              signup: signup,
                              loading: loading,
                              error: error,
                              nameController: nameC,
                              emailController: emailC,
                              passwordController: passC,
                              onSubmit: _submit,
                              onToggleMode: _toggleMode,
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
        },
      ),
    );
  }
}

class _BrandPanel extends StatelessWidget {
  final VoidCallback onToggle;
  final bool signup;

  const _BrandPanel({required this.onToggle, required this.signup});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0D4E81),
      padding: const EdgeInsets.fromLTRB(48, 48, 32, 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Color(0xFF59B6F3), Color(0xFF1876C1)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: Image.asset('assets/logo.png', width: 26, height: 26),
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Vertex',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const Spacer(),
          const Text(
            'Smarter logistics, simplified.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.w800,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Manage shipments, automate carrier workflows and keep your
business teams aligned from a single control tower.',
            style: TextStyle(
              color: Color(0xFFB7D4F6),
              fontSize: 15,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 28),
          FilledButton.tonal(
            onPressed: onToggle,
            style: FilledButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF0D4E81),
            ),
            child: Text(
              signup
                  ? 'Already onboard? Log in instead'
                  : 'New here? Create your account',
            ),
          ),
        ],
      ),
    );
  }
}

class _AuthForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final bool signup;
  final bool loading;
  final String? error;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback onSubmit;
  final VoidCallback onToggleMode;

  const _AuthForm({
    required this.formKey,
    required this.signup,
    required this.loading,
    required this.error,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.onSubmit,
    required this.onToggleMode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(48, 48, 48, 48),
      child: Form(
        key: formKey,
        child: AutofillGroup(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                signup ? 'Create your account' : 'Welcome back',
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                signup
                    ? 'A few details and you are ready to ship.'
                    : 'Log in with your credentials to continue.',
                style: TextStyle(color: Colors.grey.shade600),
              ),
              const SizedBox(height: 28),
              if (signup)
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Full name'),
                  textInputAction: TextInputAction.next,
                  autofillHints: const <String>[],
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Required' : null,
                ),
              if (signup) const SizedBox(height: 12),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Work email'),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                autofillHints: const <String>[],
                enableSuggestions: false,
                autocorrect: false,
                validator: (v) =>
                    v == null ||
                            !RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(v)
                        ? 'Invalid'
                        : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                textInputAction: TextInputAction.done,
                autofillHints: const <String>[],
                enableSuggestions: false,
                autocorrect: false,
                onFieldSubmitted: (_) => onSubmit(),
                validator: (v) => v == null || v.length < 4 ? 'Min 4 chars' : null,
              ),
              const SizedBox(height: 16),
              if (error != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    error!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: loading ? null : onSubmit,
                  child: loading
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(signup ? 'Create account' : 'Log in'),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: onToggleMode,
                child: Text(
                  signup
                      ? 'Have an account? Log in'
                      : 'New user? Sign up',
                ),
              ),
              const Spacer(),
              const Text(
                'By continuing you agree to our Terms & Privacy Policy.',
                style: TextStyle(fontSize: 11, color: Color(0xFF8C96AB)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
