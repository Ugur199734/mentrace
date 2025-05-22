import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class LoadingSkeletonWidget extends StatelessWidget {
  const LoadingSkeletonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        3,
        (index) => _buildSkeletonCard(context),
      ),
    );
  }

  Widget _buildSkeletonCard(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 2.h),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSkeletonHeader(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSkeletonLine(width: 90.w, height: 1.5.h),
                SizedBox(height: 1.h),
                _buildSkeletonLine(width: 80.w, height: 1.5.h),
                SizedBox(height: 1.h),
                _buildSkeletonLine(width: 60.w, height: 1.5.h),
              ],
            ),
          ),
          _buildSkeletonFooter(),
        ],
      ),
    );
  }

  Widget _buildSkeletonHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest.withAlpha(77),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
      ),
      child: Row(
        children: [
          _buildSkeletonCircle(size: 40),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSkeletonLine(width: 40.w, height: 1.8.h),
                SizedBox(height: 0.8.h),
                _buildSkeletonLine(width: 30.w, height: 1.5.h),
              ],
            ),
          ),
          _buildSkeletonChip(),
        ],
      ),
    );
  }

  Widget _buildSkeletonFooter() {
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
          _buildSkeletonLine(width: 30.w, height: 1.5.h),
          _buildSkeletonLine(width: 20.w, height: 1.5.h),
        ],
      ),
    );
  }

  Widget _buildSkeletonLine({required double width, required double height}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildSkeletonCircle({required double size}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildSkeletonChip() {
    return Container(
      width: 20.w,
      height: 3.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }
}