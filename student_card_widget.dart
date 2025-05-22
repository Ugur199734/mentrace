import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class StudentCardWidget extends StatelessWidget {
  final Map<String, dynamic> student;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const StudentCardWidget({
    super.key,
    required this.student,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 2.h),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest),
      ),
      child: Padding(
        padding: EdgeInsets.all(2.w),
        child: Row(
          children: [
            _buildAvatar(),
            SizedBox(width: 3.w),
            Expanded(
              child: _buildStudentInfo(context),
            ),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return CircleAvatar(
      radius: 24,
      backgroundColor: AppTheme.primaryLight,
      child: ClipOval(
        child: CustomImageWidget(
          imageUrl: student["avatar"] ?? "",
          width: 48,
          height: 48,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildStudentInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          student["name"] ?? "Unknown",
          style: Theme.of(context).textTheme.titleMedium,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 0.5.h),
        Text(
          student["grade"] ?? "",
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondary,
              ),
        ),
        SizedBox(height: 0.5.h),
        Row(
          children: [
            const CustomIconWidget(
              iconName: 'email',
              color: AppTheme.textTertiary,
              size: 14,
            ),
            SizedBox(width: 1.w),
            Expanded(
              child: Text(
                student["parentEmail"] ?? "",
                style: Theme.of(context).textTheme.bodySmall,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const CustomIconWidget(
            iconName: 'edit',
            color: AppTheme.primary,
            size: 20,
          ),
          onPressed: onEdit,
          tooltip: 'Edit Student',
          constraints: BoxConstraints(
            minWidth: 10.w,
            minHeight: 5.h,
          ),
        ),
        IconButton(
          icon: const CustomIconWidget(
            iconName: 'delete',
            color: AppTheme.error,
            size: 20,
          ),
          onPressed: onDelete,
          tooltip: 'Delete Student',
          constraints: BoxConstraints(
            minWidth: 10.w,
            minHeight: 5.h,
          ),
        ),
      ],
    );
  }
}