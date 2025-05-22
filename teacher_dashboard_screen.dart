import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/add_student_form_widget.dart';
import './widgets/note_entry_widget.dart';
import './widgets/student_list_widget.dart';

class TeacherDashboardScreen extends StatefulWidget {
  const TeacherDashboardScreen({super.key});

  @override
  State<TeacherDashboardScreen> createState() => _TeacherDashboardScreenState();
}

class _TeacherDashboardScreenState extends State<TeacherDashboardScreen> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  bool isAddingStudent = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Teacher Dashboard',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        actions: [
          IconButton(
            icon: const CustomIconWidget(
              iconName: 'logout',
              color: AppTheme.textSecondary,
              size: 24,
            ),
            onPressed: () {
              // Navigate to login screen
              Navigator.pushReplacementNamed(context, '/login-screen');
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: () async {
          // Implement refresh logic here
          await Future.delayed(const Duration(seconds: 1));
          setState(() {});
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader(context, 'Student Management'),
              SizedBox(height: 2.h),
              _buildStudentManagementSection(),
              SizedBox(height: 4.h),
              _buildSectionHeader(context, 'Note Entry'),
              SizedBox(height: 2.h),
              const NoteEntryWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppTheme.border,
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          if (title == 'Student Management' && !isAddingStudent)
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  isAddingStudent = true;
                });
              },
              icon: const CustomIconWidget(
                iconName: 'add',
                color: Colors.white,
                size: 18,
              ),
              label: const Text('Add Student'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStudentManagementSection() {
    return Column(
      children: [
        if (isAddingStudent)
          AddStudentFormWidget(
            onCancel: () {
              setState(() {
                isAddingStudent = false;
              });
            },
            onSave: (studentData) {
              // Save student data logic would go here
              setState(() {
                isAddingStudent = false;
                // Refresh student list
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Student added successfully'),
                  backgroundColor: AppTheme.success,
                ),
              );
            },
          ),
        SizedBox(height: 2.h),
        const StudentListWidget(),
      ],
    );
  }
}