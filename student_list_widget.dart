import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import './student_card_widget.dart';

class StudentListWidget extends StatefulWidget {
  const StudentListWidget({super.key});

  @override
  State<StudentListWidget> createState() => _StudentListWidgetState();
}

class _StudentListWidgetState extends State<StudentListWidget> {
  late List<Map<String, dynamic>> students;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  Future<void> _loadStudents() async {
    // Simulate loading from Firestore
    await Future.delayed(const Duration(milliseconds: 800));
    
    try {
      // Mock data - in a real app, this would come from Firestore
      setState(() {
        students = [
          {
            "id": "1",
            "name": "Emma Thompson",
            "grade": "5th Grade",
            "parentEmail": "emma.parent@example.com",
            "avatar": "https://randomuser.me/api/portraits/women/44.jpg",
          },
          {
            "id": "2",
            "name": "Noah Martinez",
            "grade": "5th Grade",
            "parentEmail": "noah.parent@example.com",
            "avatar": "https://randomuser.me/api/portraits/men/32.jpg",
          },
          {
            "id": "3",
            "name": "Olivia Johnson",
            "grade": "5th Grade",
            "parentEmail": "olivia.parent@example.com",
            "avatar": "https://randomuser.me/api/portraits/women/67.jpg",
          },
          {
            "id": "4",
            "name": "Liam Williams",
            "grade": "5th Grade",
            "parentEmail": "liam.parent@example.com",
            "avatar": "https://randomuser.me/api/portraits/men/52.jpg",
          },
          {
            "id": "5",
            "name": "Ava Brown",
            "grade": "5th Grade",
            "parentEmail": "ava.parent@example.com",
            "avatar": "https://randomuser.me/api/portraits/women/90.jpg",
          },
        ];
        isLoading = false;
        errorMessage = null;
      });
    } catch (e) {
      setState(() {
        errorMessage = "Failed to load students. Please try again.";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(
          color: AppTheme.lightTheme.colorScheme.primary,
        ),
      );
    }

    if (errorMessage != null) {
      return _buildErrorState();
    }

    if (students.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: students.length,
      itemBuilder: (context, index) {
        final student = students[index];
        return StudentCardWidget(
          student: student,
          onEdit: () => _editStudent(student),
          onDelete: () => _deleteStudent(student),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CustomIconWidget(
            iconName: 'people',
            color: AppTheme.textTertiary,
            size: 48,
          ),
          SizedBox(height: 2.h),
          Text(
            'No students added yet',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppTheme.textSecondary,
                ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Add your first student to get started',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textTertiary,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 4.w),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CustomIconWidget(
            iconName: 'error',
            color: AppTheme.error,
            size: 48,
          ),
          SizedBox(height: 2.h),
          Text(
            errorMessage!,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppTheme.textSecondary,
                ),
          ),
          SizedBox(height: 2.h),
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                isLoading = true;
              });
              _loadStudents();
            },
            icon: const CustomIconWidget(
              iconName: 'refresh',
              color: Colors.white,
              size: 18,
            ),
            label: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  void _editStudent(Map<String, dynamic> student) {
    // Show edit dialog or navigate to edit screen
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Student'),
        content: const Text('Edit student functionality would be implemented here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _deleteStudent(Map<String, dynamic> student) {
    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Student'),
        content: Text('Are you sure you want to delete ${student["name"]}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Delete student logic would go here
              setState(() {
                students.removeWhere((s) => s["id"] == student["id"]);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Student deleted successfully'),
                  backgroundColor: AppTheme.success,
                ),
              );
            },
            child: Text(
              'Delete',
              style: TextStyle(color: AppTheme.lightTheme.colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }
}