import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class StudentFilterWidget extends StatelessWidget {
  final List<Map<String, dynamic>> students;
  final String? selectedStudentId;
  final String selectedStatus;
  final Function(String?) onStudentChanged;
  final Function(String) onStatusChanged;

  const StudentFilterWidget({
    super.key,
    required this.students,
    required this.selectedStudentId,
    required this.selectedStatus,
    required this.onStudentChanged,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStudentFilter(context),
        SizedBox(height: 2.h),
        _buildStatusFilter(context),
      ],
    );
  }

  Widget _buildStudentFilter(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Filter by Student',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
        SizedBox(height: 1.h),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              // "All Students" option
              _buildStudentChip(
                context,
                null,
                'All Students',
                'people',
              ),
              SizedBox(width: 2.w),
              // Individual student options
              ...students.map((student) => Padding(
                padding: EdgeInsets.only(right: 2.w),
                child: _buildStudentChip(
                  context,
                  student["id"] as String,
                  student["name"] as String,
                  'person',
                ),
              )),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStudentChip(BuildContext context, String? studentId, String label, String iconName) {
    final bool isSelected = selectedStudentId == studentId;
    
    return FilterChip(
      selected: isSelected,
      label: Text(label),
      avatar: CustomIconWidget(
        iconName: iconName,
        color: isSelected ? Colors.white : AppTheme.textSecondary,
        size: 18,
      ),
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      selectedColor: AppTheme.primary,
      checkmarkColor: Colors.white,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : AppTheme.textPrimary,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      onSelected: (selected) {
        if (selected) {
          onStudentChanged(studentId);
        } else {
          // If deselecting the current filter, go back to "All"
          onStudentChanged(null);
        }
      },
    );
  }

  Widget _buildStatusFilter(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Filter by Status',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
        SizedBox(height: 1.h),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildStatusChip(context, 'All', null),
              SizedBox(width: 2.w),
              _buildStatusChip(context, 'Positive', AppTheme.success),
              SizedBox(width: 2.w),
              _buildStatusChip(context, 'Neutral', AppTheme.warning),
              SizedBox(width: 2.w),
              _buildStatusChip(context, 'Negative', AppTheme.error),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusChip(BuildContext context, String status, Color? color) {
    final bool isSelected = selectedStatus == status;
    
    return FilterChip(
      selected: isSelected,
      label: Text(status),
      backgroundColor: color != null ? color.withAlpha(26) : AppTheme.lightTheme.colorScheme.surface,
      selectedColor: color ?? AppTheme.primary,
      checkmarkColor: Colors.white,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : (color ?? AppTheme.textPrimary),
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      onSelected: (selected) {
        if (selected) {
          onStatusChanged(status);
        } else {
          // If deselecting the current filter, go back to "All"
          onStatusChanged('All');
        }
      },
    );
  }
}