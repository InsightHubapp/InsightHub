import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:InsightHub/feature/auth/cubit/register_cubit.dart';
import 'package:InsightHub/feature/auth/views/register/otp_verification.dart';
import 'package:InsightHub/feature/auth/widget/auth_input_decoration.dart';
import 'package:InsightHub/feature/auth/widget/auth_layout.dart';
import 'package:InsightHub/feature/auth/widget/bottom_action_button.dart';
import 'package:InsightHub/feature/auth/widget/card_container.dart';
import 'package:InsightHub/feature/auth/widget/validatores.dart';
import 'package:lucide_icons/lucide_icons.dart';

class RegisterAccountScreen extends StatefulWidget {
  const RegisterAccountScreen({super.key});

  static const String routeName = '/registerAccountScreen';

  @override
  State<RegisterAccountScreen> createState() =>
      _RegisterAccountScreenState();
}

class _RegisterAccountScreenState
    extends State<RegisterAccountScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController =
      TextEditingController();

  final TextEditingController _passwordController =
      TextEditingController();

  final TextEditingController _confirmController =
      TextEditingController();

  bool _showPassword = false;
  bool _showConfirmPassword = false;

  bool get hasUppercase =>
      RegExp(r'[A-Z]').hasMatch(_passwordController.text);

  bool get hasLowercase =>
      RegExp(r'[a-z]').hasMatch(_passwordController.text);

  bool get hasNumber =>
      RegExp(r'[0-9]').hasMatch(_passwordController.text);

  bool get hasSpecialCharacter =>
      RegExp(r'[!@#$%^&*(),.?":{}|<>]')
          .hasMatch(_passwordController.text);

  bool get hasMinLength =>
      _passwordController.text.length >= 8;

  bool get isPasswordValid =>
      hasUppercase &&
      hasLowercase &&
      hasNumber &&
      hasSpecialCharacter &&
      hasMinLength;

  bool get _canProceed {
    return Validators.email(_emailController.text) == null &&
        isPasswordValid &&
        _passwordController.text ==
            _confirmController.text &&
        _confirmController.text.isNotEmpty;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _handleNext() {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();

    context
        .read<RegisterCubit>()
        .checkEmailExistence(email);
  }

  String? _confirmValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password confirmation is required';
    }

    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }

    return null;
  }

  Widget _buildRequirement(
    String text,
    bool valid,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Row(
        children: [
          Icon(
            valid
                ? Icons.check_circle
                : Icons.cancel,
            color:
                valid ? Colors.green : Colors.red,
            size: 18,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: valid
                  ? Colors.green
                  : Colors.red,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state is EmailExists) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'This email is already registered.',
              ),
              backgroundColor: Colors.red,
            ),
          );
        } else if (state is EmailDoesNotExist) {
          context
              .read<RegisterCubit>()
              .sendOtp(state.email);
        } else if (state is OtpSent) {
          final email =
              _emailController.text.trim();

          final password =
              _passwordController.text;

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  OtpVerificationScreen(
                email: email,
                password: password,
              ),
            ),
          );
        } else if (state is OtpSendFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.errorMessage,
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: BlocBuilder<
          RegisterCubit,
          RegisterState>(
        builder: (context, state) {
          final isLoading =
              state is CheckingEmailExistence ||
                  state is OtpSending;

          return AuthLayout(
            title: 'Create Account',
            subtitle:
                'Enter your email and password to continue.',
            action: BottomActionButton(
              label: 'Next',
              enabled:
                  _canProceed && !isLoading,
              isLoading: isLoading,
              onPressed:
                  _canProceed && !isLoading
                      ? _handleNext
                      : null,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  CardContainer(
                    children: [
                      const Text(
                        'Email Address',
                      ),

                      const SizedBox(height: 8),

                      TextFormField(
                        controller:
                            _emailController,
                        keyboardType:
                            TextInputType
                                .emailAddress,
                        autofillHints: const [
                          AutofillHints.email,
                        ],
                        inputFormatters: [
                          FilteringTextInputFormatter
                              .deny(
                            RegExp(r"\s"),
                          ),
                        ],
                        decoration:
                            authInputDecoration(
                          'you@example.com',
                        ),
                        validator:
                            Validators.email,
                        onChanged: (_) =>
                            setState(() {}),
                      ),

                      const SizedBox(height: 24),

                      const Text('Password'),

                      const SizedBox(height: 8),

                      TextFormField(
                        controller:
                            _passwordController,
                        obscureText:
                            !_showPassword,
                        decoration:
                            authInputDecoration(
                          'Enter password',
                          suffixIcon:
                              IconButton(
                            icon: Icon(
                              _showPassword
                                  ? LucideIcons
                                      .eye
                                  : LucideIcons
                                      .eyeOff,
                              size: 20,
                            ),
                            onPressed: () {
                              setState(() {
                                _showPassword =
                                    !_showPassword;
                              });
                            },
                          ),
                        ).copyWith(
                          enabledBorder:
                              OutlineInputBorder(
                            borderRadius:
                                BorderRadius
                                    .circular(
                              14,
                            ),
                            borderSide:
                                BorderSide(
                              color:
                                  _passwordController
                                              .text
                                              .isEmpty ||
                                          isPasswordValid
                                      ? Colors
                                          .grey
                                      : Colors
                                          .red,
                              width: 1.5,
                            ),
                          ),
                          focusedBorder:
                              OutlineInputBorder(
                            borderRadius:
                                BorderRadius
                                    .circular(
                              14,
                            ),
                            borderSide:
                                BorderSide(
                              color:
                                  isPasswordValid
                                      ? Colors
                                          .green
                                      : Colors
                                          .red,
                              width: 2,
                            ),
                          ),
                        ),
                        onChanged: (_) =>
                            setState(() {}),
                      ),

                      const SizedBox(height: 12),

                      _buildRequirement(
                        'At least 8 characters',
                        hasMinLength,
                      ),

                      _buildRequirement(
                        'Contains uppercase letter',
                        hasUppercase,
                      ),

                      _buildRequirement(
                        'Contains lowercase letter',
                        hasLowercase,
                      ),

                      _buildRequirement(
                        'Contains number',
                        hasNumber,
                      ),

                      _buildRequirement(
                        'Contains special character',
                        hasSpecialCharacter,
                      ),

                      const SizedBox(height: 24),

                      const Text(
                        'Confirm Password',
                      ),

                      const SizedBox(height: 8),

                      TextFormField(
                        controller:
                            _confirmController,
                        obscureText:
                            !_showConfirmPassword,
                        decoration:
                            authInputDecoration(
                          'Confirm password',
                          suffixIcon:
                              IconButton(
                            icon: Icon(
                              _showConfirmPassword
                                  ? LucideIcons
                                      .eye
                                  : LucideIcons
                                      .eyeOff,
                              size: 20,
                            ),
                            onPressed: () {
                              setState(() {
                                _showConfirmPassword =
                                    !_showConfirmPassword;
                              });
                            },
                          ),
                        ),
                        validator:
                            _confirmValidator,
                        onChanged: (_) =>
                            setState(() {}),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}