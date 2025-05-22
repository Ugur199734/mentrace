import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AddStudentFormWidget extends StatefulWidget {
  final Function() onCancel;
  final Function(Map<String, dynamic>) onSave;

  const AddStudentFormWidget({
    super.key,
    required this.onCancel,
    required this.onSave,
  });

  @override
  State<AddStudentFormWidget> createState() => _AddStudentFormWidgetState();
}

class _AddStudentFormWidgetState extends State<AddStudentFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _parentEmailController = TextEditingController();
  String _selectedGrade = '5th Grade';
  bool _isSubmitting = false;

  final List<String> _grades = [
    '1st Grade',
    '2nd Grade',
    '3rd Grade',
    '4th Grade',
    '5th Grade',
    '6th Grade',
    '7th Grade',
    '8th Grade',
  ];

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _parentEmailController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
      });

      // Simulate API call
      Future.delayed(const Duration(milliseconds: 800), () {
        final studentData = {
          "id": DateTime.now().millisecondsSinceEpoch.toString(),
          "name": "${_firstNameController.text} ${_lastNameController.text}",
          "grade": _selectedGrade,
          "parentEmail": _parentEmailController.text,
          "avatar": "https://randomuser.me/api/portraits/lego/1.jpg", // Default avatar
        };

        widget.onSave(studentData);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: AppTheme.lightTheme.colorScheme.primary.withAlpha(77)),
      ),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add New Student',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppTheme.primary,
                    ),
              ),
              SizedBox(height: 2.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _firstNameController,
                      decoration: const InputDecoration(
                        labelText: 'First Name',
                        prefixIcon: CustomIconWidget(
                          iconName: 'person',
                          color: AppTheme.textSecondary,
                          size: 20,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter first name';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: TextFormField(
                      controller: _lastNameController,
                      decoration: const InputDecoration(
                        labelText: 'Last Name',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter last name';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              DropdownButtonFormField<String>(
                value: _selectedGrade,
                decoration: const InputDecoration(
                  labelText: 'Grade',
                  prefixIcon: CustomIconWidget(
                    iconName: 'school',
                    color: AppTheme.textSecondary,
                    size: 20,
                  ),
                ),
                items: _grades.map((grade) {
                  return DropdownMenuItem<String>(
                    value: grade,
                    child: Text(grade),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedGrade = value;
                    });
                  }
                },
              ),
              SizedBox(height: 2.h),
              TextFormField(
                controller: _parentEmailController,
                decoration: const InputDecoration(
                  labelText: 'Parent Email',
                  prefixIcon: CustomIconWidget(
                    iconName: 'email',
                    color: AppTheme.textSecondary,
                    size: 20,
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter parent email';
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 3.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _isSubmitting ? null : widget.onCancel,
                    child: const Text('Cancel'),
                  ),
                  SizedBox(width: 2.w),
                  ElevatedButton(
                    onPressed: _isSubmitting ? null : _submitForm,
                    child: _isSubmitting
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text('Save Student'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}