import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RoleSelectionWidget extends StatelessWidget {
  final String? selectedRole;
  final Function(String) onRoleSelected;

  const RoleSelectionWidget({
    super.key,
    required this.selectedRole,
    required this.onRoleSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Your Role',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        SizedBox(height: 1.h),
        Text(
          'Choose the role that best describes you',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondary,
              ),
        ),
        SizedBox(height: 2.h),
        _buildRoleCard(
          context,
          'Teacher',
          'Create and manage student profiles, track performance, and share feedback with parents',
          'school',
        ),
        SizedBox(height: 2.h),
        _buildRoleCard(
          context,
          'Parent',
          'View your child\'s performance, receive feedback from teachers, and stay updated on progress',
          'family_restroom',
        ),
      ],
    );
  }

  Widget _buildRoleCard(
    BuildContext context,
    String role,
    String description,
    String iconName,
  ) {
    final isSelected = selectedRole == role;

    return InkWell(
      onTap: () => onRoleSelected(role),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppTheme.primary : AppTheme.border,
            width: isSelected ? 2 : 1,
          ),
          color: isSelected ? AppTheme.primaryLight : null,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Radio<String>(
              value: role,
              groupValue: selectedRole,
              onChanged: (value) {
                if (value != null) {
                  onRoleSelected(value);
                }
              },
              activeColor: AppTheme.primary,
            ),
            SizedBox(width: 2.w),
            Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.primary : AppTheme.surface,
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomIconWidget(
                iconName: iconName,
                color: isSelected ? Colors.white : AppTheme.primary,
                size: 24,
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    role,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: isSelected ? AppTheme.primary : AppTheme.textPrimary,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}