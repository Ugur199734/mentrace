import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class PasswordStrengthIndicator extends StatelessWidget {
  final int strength;

  const PasswordStrengthIndicator({
    super.key,
    required this.strength,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: List.generate(5, (index) {
            return Expanded(
              child: Container(
                height: 0.5.h,
                margin: EdgeInsets.only(right: index < 4 ? 0.5.w : 0),
                decoration: BoxDecoration(
                  color: _getColorForIndex(index),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            );
          }),
        ),
        SizedBox(height: 0.5.h),
        Text(
          _getStrengthText(),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: _getStrengthTextColor(),
              ),
        ),
      ],
    );
  }

  Color _getColorForIndex(int index) {
    if (strength == 0) {
      return AppTheme.border;
    }
    
    if (index < strength) {
      switch (strength) {
        case 1:
          return AppTheme.error;
        case 2:
          return AppTheme.warning;
        case 3:
          return AppTheme.warning;
        case 4:
          return AppTheme.success;
        case 5:
          return AppTheme.success;
        default:
          return AppTheme.border;
      }
    } else {
      return AppTheme.border;
    }
  }

  Color _getStrengthTextColor() {
    switch (strength) {
      case 0:
        return AppTheme.textTertiary;
      case 1:
        return AppTheme.error;
      case 2:
        return AppTheme.warning;
      case 3:
        return AppTheme.warning;
      case 4:
      case 5:
        return AppTheme.success;
      default:
        return AppTheme.textTertiary;
    }
  }

  String _getStrengthText() {
    switch (strength) {
      case 0:
        return 'No password entered';
      case 1:
        return 'Very weak password';
      case 2:
        return 'Weak password';
      case 3:
        return 'Moderate password';
      case 4:
        return 'Strong password';
      case 5:
        return 'Very strong password';
      default:
        return '';
    }
  }
}