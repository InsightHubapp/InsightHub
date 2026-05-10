import 'package:flutter/material.dart';
import 'dart:async';

class OtpCountdownTimer extends StatefulWidget {
  final Duration duration;
  final VoidCallback onTimerFinish;
  final Function(Duration remaining)? onTick;

  const OtpCountdownTimer({
    super.key,
    this.duration = const Duration(minutes: 5),
    required this.onTimerFinish,
    this.onTick,
  });

  @override
  State<OtpCountdownTimer> createState() => OtpCountdownTimerState();
}

class OtpCountdownTimerState extends State<OtpCountdownTimer> {
  late Timer _timer;
  late Duration _remainingTime;
  bool _isRunning = false;

  @override
  void initState() {
    super.initState();
    _remainingTime = widget.duration;
    _startTimer();
  }

  void _startTimer() {
    if (_isRunning) return;
    
    _isRunning = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime.inSeconds > 0) {
        setState(() {
          _remainingTime = Duration(seconds: _remainingTime.inSeconds - 1);
          widget.onTick?.call(_remainingTime);
        });
      } else {
        _timer.cancel();
        _isRunning = false;
        widget.onTimerFinish();
      }
    });
  }

  void restartTimer() {
    _timer.cancel();
    _isRunning = false;
    setState(() {
      _remainingTime = widget.duration;
    });
    _startTimer();
  }

  String _formatTime(Duration duration) {
    final minutes = duration.inMinutes.toString().padLeft(1, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    if (_isRunning) {
      _timer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _formatTime(_remainingTime),
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.blue,
      ),
    );
  }
}
