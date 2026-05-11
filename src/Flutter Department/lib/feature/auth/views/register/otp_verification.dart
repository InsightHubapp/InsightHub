import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:InsightHub/core/constant/routes.dart';
import 'package:InsightHub/feature/auth/cubit/register_cubit.dart';
import 'package:InsightHub/feature/auth/widget/auth_layout.dart';
import 'package:InsightHub/feature/auth/widget/bottom_action_button.dart';
import 'package:InsightHub/feature/auth/widget/card_container.dart';
import 'package:InsightHub/feature/auth/widget/otp_countdown_timer.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String email;
  final String password;

  const OtpVerificationScreen({
    super.key,
    required this.email,
    required this.password,
  });

  static const String routeName = '/otpVerificationScreen';

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final TextEditingController _otpController = TextEditingController();
  late GlobalKey<OtpCountdownTimerState> _timerKey;
  bool _isResendButtonEnabled = false;
  bool _isTimerFinished = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _timerKey = GlobalKey<OtpCountdownTimerState>();
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  bool get _canVerify => _otpController.text.length == 6 && !_isLoading;

  void _handleVerifyOtp() {
    if (!_canVerify) return;

    context.read<RegisterCubit>().verifyOtp(widget.email, _otpController.text);
  }

  void _handleResendOtp() {
    if (!_isResendButtonEnabled) return;

    context.read<RegisterCubit>().sendOtp(widget.email);
    _isResendButtonEnabled = false;
    _isTimerFinished = false;
    _otpController.clear();
    setState(() {});
    _timerKey.currentState?.restartTimer();
  }

  void _onTimerFinish() {
    setState(() {
      _isTimerFinished = true;
      _isResendButtonEnabled = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state is OtpVerified) {
          context.read<RegisterCubit>().savePassword(widget.password);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('OTP verified successfully!')),
          );
          Navigator.pushNamedAndRemoveUntil(
            context,
            Routes.registerNameScreen,
            (route) => false,
          );
        } else if (state is OtpVerifyFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage)),
          );
        } else if (state is OtpSent) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('OTP sent successfully!')),
          );
        } else if (state is OtpSendFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage)),
          );
        }
      },
      child: BlocBuilder<RegisterCubit, RegisterState>(
        builder: (context, state) {
          _isLoading = state is OtpVerifying || state is OtpSending;

          return AuthLayout(
            title: 'Verify Your Email',
            subtitle: 'Enter the 6-digit code sent to ${widget.email}',
            action: BottomActionButton(
              label: 'Verify',
              enabled: _canVerify,
              isLoading: state is OtpVerifying,
              onPressed: _canVerify ? _handleVerifyOtp : null,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CardContainer(
                    children: [
                      const Text('Verification Code'),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _otpController,
                        keyboardType: TextInputType.number,
                        maxLength: 6,
                        enabled: !_isLoading,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(6),
                        ],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 12,
                        ),
                        decoration: InputDecoration(
                          hintText: '000000',
                          hintStyle: const TextStyle(
                            fontSize: 32,
                            color: Colors.grey,
                          ),
                          counterText: '',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Colors.blue,
                              width: 2,
                            ),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 12,
                          ),
                        ),
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Code expires in',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 4),
                              OtpCountdownTimer(
                                key: _timerKey,
                                duration: const Duration(minutes: 5),
                                onTimerFinish: _onTimerFinish,
                                onTick: (remaining) {
                                },
                              ),
                            ],
                          ),
                          if (_isTimerFinished)
                            ElevatedButton(
                              onPressed: _isLoading ? null : _handleResendOtp,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                disabledBackgroundColor: Colors.grey.shade300,
                              ),
                              child: const Text('Send OTP Again'),
                            )
                          else
                            Opacity(
                              opacity: 0.5,
                              child: ElevatedButton(
                                onPressed: null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  disabledBackgroundColor: Colors.grey.shade300,
                                ),
                                child: const Text('Send OTP Again'),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  if (state is OtpVerifyFailure)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        border: Border.all(color: Colors.red.shade200),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: Colors.red.shade700,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              state.errorMessage,
                              style: TextStyle(
                                color: Colors.red.shade700,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
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
