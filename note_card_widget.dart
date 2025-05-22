import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class NoteCardWidget extends StatelessWidget {
  final Map<String, dynamic> note;

  const NoteCardWidget({
    super.key,
    required this.note,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 2.h),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: _getStatusColor().withAlpha(77),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardHeader(context),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            child: Text(
              note["feedback"] ?? "No feedback provided",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          _buildCardFooter(context),
        ],
      ),
    );
  }

  Widget _buildCardHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: _getStatusColor().withAlpha(26),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: _getStatusColor().withAlpha(51),
            radius: 20,
            child: CustomIconWidget(
              iconName: _getStatusIcon(),
              color: _getStatusColor(),
              size: 24,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  note["student_name"] ?? "Unknown Student",
                  style: Theme.of(context).textTheme.titleMedium,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 0.5.h),
                Text(
                  note["teacher_name"] ?? "Unknown Teacher",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.8.h),
            decoration: BoxDecoration(
              color: _getStatusColor().withAlpha(51),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              note["status"] ?? "Unknown",
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: _getStatusColor(),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardFooter(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest.withAlpha(77),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: _getHomeworkStatusIcon(),
                color: _getHomeworkStatusColor(),
                size: 18,
              ),
              SizedBox(width: 1.w),
              Text(
                "Homework: ${note["homework_status"] ?? "Unknown"}",
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: _getHomeworkStatusColor(),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Text(
            _formatTimestamp(note["timestamp"] as DateTime),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.textTertiary,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor() {
    switch (note["status"]) {
      case "Positive":
        return AppTheme.success;
      case "Negative":
        return AppTheme.error;
      case "Neutral":
        return AppTheme.warning;
      default:
        return AppTheme.textSecondary;
    }
  }

  String _getStatusIcon() {
    switch (note["status"]) {
      case "Positive":
        return 'sentiment_satisfied';
      case "Negative":
        return 'sentiment_dissatisfied';
      case "Neutral":
        return 'sentiment_neutral';
      default:
        return 'help';
    }
  }

  Color _getHomeworkStatusColor() {
    switch (note["homework_status"]) {
      case "Completed":
        return AppTheme.success;
      case "Incomplete":
        return AppTheme.warning;
      case "Missing":
        return AppTheme.error;
      default:
        return AppTheme.textSecondary;
    }
  }

  String _getHomeworkStatusIcon() {
    switch (note["homework_status"]) {
      case "Completed":
        return 'check_circle';
      case "Incomplete":
        return 'error';
      case "Missing":
        return 'cancel';
      default:
        return 'help';
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}