import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:InsightHub/core/constant/routes.dart';
import 'package:InsightHub/feature/auth/cubit/login_cubit.dart';
import 'package:InsightHub/feature/auth/widget/auth_input_decoration.dart';
import 'package:InsightHub/feature/auth/widget/auth_layout.dart';
import 'package:InsightHub/feature/auth/widget/bottom_action_button.dart';
import 'package:InsightHub/feature/auth/widget/card_container.dart';
import 'package:InsightHub/feature/auth/widget/validatores.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool get _canContinue {
    return Validators.email(_emailController.text) == null &&
        Validators.loginPassword(_passwordController.text) == null;
  }

  void _handleContinue() {
  print("LOGIN CLICKED");

  final formState = _formKey.currentState;

  if (formState == null || !formState.validate()) {
    print("FORM INVALID");
    return;
  }

  print("CALLING LOGIN");

  context.read<LoginCubit>().login(
    _emailController.text.trim(),
    _passwordController.text,
  );
}

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          if (!context.mounted) return;
          Navigator.pushNamedAndRemoveUntil(
            context,
            Routes.homeScreen,
            (route) => false,
          );
        } else if (state is LoginFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.error)));
        }
      },
      builder: (context, state) {
        final isLoading = state is LoginLoading;

        return AuthLayout(
          title: 'Sign in',
          subtitle: 'Enter your email and password to continue.',
          action: BottomActionButton(
            label: 'Continue',
            enabled: _canContinue && !isLoading,
            isLoading: isLoading,
            onPressed: (_canContinue && !isLoading) ? _handleContinue : null,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CardContainer(
                  children: [
                    const Text('Email address'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: authInputDecoration('you@example.com'),
                      validator: Validators.email,
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 20),
                    const Text('Password'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: authInputDecoration('Enter your password'),
                      validator: Validators.loginPassword,
                      onChanged: (_) => setState(() {}),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, Routes.registerEmailScreen);
                    },
                    child: const Text.rich(
                      TextSpan(
                        text: "Don't have an account? ",
                        style: TextStyle(color: Colors.grey),
                        children: [
                          TextSpan(
                            text: 'Register',
                            style: TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
