import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class NoteEntryWidget extends StatefulWidget {
  const NoteEntryWidget({super.key});

  @override
  State<NoteEntryWidget> createState() => _NoteEntryWidgetState();
}

class _NoteEntryWidgetState extends State<NoteEntryWidget> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedStudentId;
  String _selectedStatus = 'Positive';
  String _selectedHomeworkStatus = 'Completed';
  final _feedbackController = TextEditingController();
  bool _isSubmitting = false;

  // Mock data - in a real app, this would come from Firestore
  final List<Map<String, dynamic>> _students = [
    {  "id": "1\", \"name\": \"Emma Thompson"},
    {  "id": "2\", \"name\": \"Noah Martinez"},
    {  "id": "3\", \"name\": \"Olivia Johnson"},
    {  "id": "4\", \"name\": \"Liam Williams"},
    {  "id": "5\", \"name\": \"Ava Brown"},
  ];

  final List<String> _statusOptions = ['Positive', 'Negative', 'Neutral'];
  final List<String> _homeworkStatusOptions = ['Completed', 'Incomplete', 'Missing'];

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  void _submitNote() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
      });

      // Simulate API call to Firestore
      Future.delayed(const Duration(milliseconds: 1000), () {
        // In a real app, this would save to Firestore
        final noteData = {
          "student_id": _selectedStudentId,
          "status": _selectedStatus,
          "feedback": _feedbackController.text,
          "homework_status": _selectedHomeworkStatus,
          "timestamp": DateTime.now().toIso8601String(),
          "teacher_id": "current_teacher_id", // In a real app, this would be the logged-in teacher's ID
        };

        // Reset form
        setState(() {
          _isSubmitting = false;
          _selectedStudentId = null;
          _selectedStatus = 'Positive';
          _selectedHomeworkStatus = 'Completed';
          _feedbackController.clear();
        });

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Note saved successfully'),
            backgroundColor: AppTheme.success,
          ),
        );

        print('Note saved: $noteData');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStudentDropdown(),
              SizedBox(height: 2.h),
              _buildStatusSelector(),
              SizedBox(height: 2.h),
              _buildFeedbackField(),
              SizedBox(height: 2.h),
              _buildHomeworkStatusDropdown(),
              SizedBox(height: 3.h),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStudentDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedStudentId,
      decoration: const InputDecoration(
        labelText: 'Select Student',
        prefixIcon: CustomIconWidget(
          iconName: 'person',
          color: AppTheme.textSecondary,
          size: 20,
        ),
      ),
      hint: const Text('Select a student'),
      items: _students.map((student) {
        return DropdownMenuItem<String>(
          value: student["id"] as String,
          child: Text(student["name"] as String),
        );
      }).toList(),
      validator: (value) {
        if (value == null) {
          return 'Please select a student';
        }
        return null;
      },
      onChanged: (value) {
        setState(() {
          _selectedStudentId = value;
        });
      },
    );
  }

  Widget _buildStatusSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Feedback Status',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: AppTheme.textSecondary,
              ),
        ),
        SizedBox(height: 1.h),
        Row(
          children: _statusOptions.map((status) {
            final isSelected = _selectedStatus == status;
            Color chipColor;
            
            switch (status) {
              case 'Positive':
                chipColor = AppTheme.success;
                break;
              case 'Negative':
                chipColor = AppTheme.error;
                break;
              default:
                chipColor = AppTheme.warning;
            }
            
            return Padding(
              padding: EdgeInsets.only(right: 2.w),
              child: ChoiceChip(
                label: Text(status),
                selected: isSelected,
                selectedColor: chipColor.withAlpha(51),
                labelStyle: TextStyle(
                  color: isSelected ? chipColor : AppTheme.textSecondary,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                onSelected: (selected) {
                  if (selected) {
                    setState(() {
                      _selectedStatus = status;
                    });
                  }
                },
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildFeedbackField() {
    return TextFormField(
      controller: _feedbackController,
      decoration: const InputDecoration(
        labelText: 'Feedback',
        hintText: 'Enter your feedback for the student',
        prefixIcon: CustomIconWidget(
          iconName: 'comment',
          color: AppTheme.textSecondary,
          size: 20,
        ),
        alignLabelWithHint: true,
      ),
      maxLines: 4,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter feedback';
        }
        return null;
      },
    );
  }

  Widget _buildHomeworkStatusDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedHomeworkStatus,
      decoration: const InputDecoration(
        labelText: 'Homework Status',
        prefixIcon: CustomIconWidget(
          iconName: 'assignment',
          color: AppTheme.textSecondary,
          size: 20,
        ),
      ),
      items: _homeworkStatusOptions.map((status) {
        IconData iconData;
        Color iconColor;
        
        switch (status) {
          case 'Completed':
            iconData = Icons.check_circle;
            iconColor = AppTheme.success;
            break;
          case 'Incomplete':
            iconData = Icons.error;
            iconColor = AppTheme.warning;
            break;
          default:
            iconData = Icons.cancel;
            iconColor = AppTheme.error;
        }
        
        return DropdownMenuItem<String>(
          value: status,
          child: Row(
            children: [
              Icon(iconData, color: iconColor, size: 16),
              SizedBox(width: 2.w),
              Text(status),
            ],
          ),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          setState(() {
            _selectedHomeworkStatus = value;
          });
        }
      },
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _isSubmitting ? null : _submitNote,
        icon: _isSubmitting
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const CustomIconWidget(
                iconName: 'save',
                color: Colors.white,
                size: 20,
              ),
        label: Text(_isSubmitting ? 'Saving...' : 'Save Note'),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 1.5.h),
        ),
      ),
    );
  }
}