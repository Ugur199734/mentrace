import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EmptyNotesWidget extends StatelessWidget {
  final String message;
  final VoidCallback onReset;

  const EmptyNotesWidget({
    super.key,
    required this.message,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 4.w),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CustomIconWidget(
            iconName: 'note',
            color: AppTheme.textTertiary,
            size: 64,
          ),
          SizedBox(height: 3.h),
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            'Notes from teachers will appear here.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.textTertiary,
            ),
          ),
          SizedBox(height: 3.h),
          OutlinedButton.icon(
            onPressed: onReset,
            icon: const CustomIconWidget(
              iconName: 'filter_alt_off',
              color: AppTheme.primary,
              size: 18,
            ),
            label: const Text('Reset Filters'),
          ),
        ],
      ),
    );
  }
}