import 'package:flutter/material.dart';

class AppHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final Widget? extra;
  final Widget? leading;
  final IconData? leadingIcon;
  final bool showBackButton;
  final VoidCallback? onBackPress;

  const AppHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
    this.extra,
    this.leading,
    this.leadingIcon,
    this.showBackButton = false,
    this.onBackPress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

     decoration: BoxDecoration(
  color: Colors.transparent,
),

      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [

              Row(
                children: [
                  if (leading != null) ...[
                    leading!,
                    const SizedBox(width: 10),
                  ] else if (showBackButton) ...[
                    IconButton(
                      icon: Icon(
                        leadingIcon ?? Icons.arrow_back,
                        color: Colors.white,
                      ),
                      onPressed:
                          onBackPress ?? () => Navigator.of(context).pop(),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: 10),
                  ],

                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 24, 
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  if (trailing != null) trailing!,
                ],
              ),

              if (subtitle != null) ...[
                const SizedBox(height: 6),
                Text(
                  subtitle!,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.85),
                    fontSize: 14,
                  ),
                ),
              ],

              if (extra != null) ...[
                const SizedBox(height: 14),
                extra!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}