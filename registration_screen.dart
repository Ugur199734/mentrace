import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/password_strength_indicator.dart';
import './widgets/role_selection_widget.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String? _selectedRole;
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  
  // Password strength variables
  int _passwordStrength = 0;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _updatePasswordStrength(String password) {
    int strength = 0;
    
    // Check for length
    if (password.length >= 8) strength++;
    
    // Check for uppercase
    if (password.contains(RegExp(r'[A-Z]'))) strength++;
    
    // Check for lowercase
    if (password.contains(RegExp(r'[a-z]'))) strength++;
    
    // Check for numbers
    if (password.contains(RegExp(r'[0-9]'))) strength++;
    
    // Check for special characters
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) strength++;
    
    setState(() {
      _passwordStrength = strength;
    });
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedRole == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select a role'),
            backgroundColor: AppTheme.error,
          ),
        );
        return;
      }
      
      setState(() {
        _isLoading = true;
      });
      
      // Simulate Firebase authentication delay
      await Future.delayed(const Duration(seconds: 2));
      
      // Mock successful registration
      setState(() {
        _isLoading = false;
      });
      
      // Navigate to appropriate dashboard based on role
      if (!mounted) return;
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Registration successful! Welcome as a ${_selectedRole?.toLowerCase()}'),
          backgroundColor: AppTheme.success,
        ),
      );
      
      // Navigate to appropriate dashboard
      if (_selectedRole == 'Teacher') {
        Navigator.pushReplacementNamed(context, '/teacher-dashboard-screen');
      } else {
        Navigator.pushReplacementNamed(context, '/parent-dashboard-screen');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.textPrimary,
            size: 24,
          ),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/login-screen');
          },
        ),
        title: const Text('Create Account'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 2.h),
                  _buildHeader(),
                  SizedBox(height: 4.h),
                  _buildEmailField(),
                  SizedBox(height: 2.h),
                  _buildPasswordField(),
                  SizedBox(height: 0.5.h),
                  PasswordStrengthIndicator(strength: _passwordStrength),
                  SizedBox(height: 2.h),
                  _buildConfirmPasswordField(),
                  SizedBox(height: 3.h),
                  RoleSelectionWidget(
                    selectedRole: _selectedRole,
                    onRoleSelected: (role) {
                      setState(() {
                        _selectedRole = role;
                      });
                    },
                  ),
                  SizedBox(height: 4.h),
                  _buildRegisterButton(),
                  SizedBox(height: 2.h),
                  _buildLoginLink(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Join Edu Tracker',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        SizedBox(height: 1.h),
        Text(
          'Create an account to track student progress and communicate effectively',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
        labelText: 'Email',
        hintText: 'Enter your email address',
        prefixIcon: CustomIconWidget(
          iconName: 'email',
          color: AppTheme.textSecondary,
          size: 20,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Email is required';
        }
        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
          return 'Please enter a valid email address';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        labelText: 'Password',
        hintText: 'Create a strong password',
        prefixIcon: const CustomIconWidget(
          iconName: 'lock',
          color: AppTheme.textSecondary,
          size: 20,
        ),
        suffixIcon: IconButton(
          icon: CustomIconWidget(
            iconName: _obscurePassword ? 'visibility' : 'visibility_off',
            color: AppTheme.textSecondary,
            size: 20,
          ),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
      ),
      onChanged: (value) {
        _updatePasswordStrength(value);
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Password is required';
        }
        if (value.length < 8) {
          return 'Password must be at least 8 characters';
        }
        if (_passwordStrength < 3) {
          return 'Password is too weak';
        }
        return null;
      },
    );
  }

  Widget _buildConfirmPasswordField() {
    return TextFormField(
      controller: _confirmPasswordController,
      obscureText: _obscureConfirmPassword,
      decoration: InputDecoration(
        labelText: 'Confirm Password',
        hintText: 'Re-enter your password',
        prefixIcon: const CustomIconWidget(
          iconName: 'lock_outline',
          color: AppTheme.textSecondary,
          size: 20,
        ),
        suffixIcon: IconButton(
          icon: CustomIconWidget(
            iconName: _obscureConfirmPassword ? 'visibility' : 'visibility_off',
            color: AppTheme.textSecondary,
            size: 20,
          ),
          onPressed: () {
            setState(() {
              _obscureConfirmPassword = !_obscureConfirmPassword;
            });
          },
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please confirm your password';
        }
        if (value != _passwordController.text) {
          return 'Passwords do not match';
        }
        return null;
      },
    );
  }

  Widget _buildRegisterButton() {
    return ElevatedButton(
      onPressed: _isLoading ? null : _register,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 1.5.h),
      ),
      child: _isLoading
          ? SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
          : const Text('Create Account'),
    );
  }

  Widget _buildLoginLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Already have an account?',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/login-screen');
          },
          child: const Text('Log In'),
        ),
      ],
    );
  }
}