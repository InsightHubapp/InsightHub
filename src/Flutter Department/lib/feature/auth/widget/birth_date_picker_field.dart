import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:InsightHub/core/constant/app_colors.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';

class BirthDatePickerField extends StatelessWidget {
  const BirthDatePickerField({
    super.key,
    required this.value,
    required this.onChanged,
    this.enabled = true,
  });

  final DateTime? value;
  final ValueChanged<DateTime> onChanged;
  final bool enabled;

  DateTime get _maximumDate {
    final now = DateTime.now();
    return DateTime(now.year - 18, now.month, now.day);
  }

  DateTime get _initialDate {
    final selected = value;
    if (selected == null || selected.isAfter(_maximumDate)) {
      return DateTime(2000);
    }
    return selected;
  }

  Future<void> _pickDate(BuildContext context) async {
    if (!enabled) return;

    await showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 250,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: CupertinoDatePicker(
            initialDateTime: _initialDate,
            mode: CupertinoDatePickerMode.date,
            minimumDate: DateTime(1950),
            maximumDate: _maximumDate,
            onDateTimeChanged: onChanged,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? () => _pickDate(context) : null,
      borderRadius: BorderRadius.circular(14),
      child: Opacity(
        opacity: enabled ? 1 : 0.6,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFD1D5DB)),
            borderRadius: BorderRadius.circular(14),
            color: Colors.white,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                value == null
                    ? 'Select date'
                    : DateFormat('MMMM dd, yyyy').format(value!),
                style: TextStyle(
                  color: value == null ? Colors.grey : Colors.black,
                ),
              ),
              const Icon(
                LucideIcons.calendar,
                size: 20,
                color: AppColors.primaryBlue,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
