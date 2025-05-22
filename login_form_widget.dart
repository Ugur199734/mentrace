import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class LoginFormWidget extends StatefulWidget {
  const LoginFormWidget({super.key});

  @override
  State<LoginFormWidget> createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  String? _errorMessage;
  bool _rememberMe = false;

  // Mock credentials for demonstration
  final Map<String, Map<String, String>> _mockUsers = {
    "teacher@example.com": {
      "password": "teacher123",
      "role": "teacher",
    },
    "parent@example.com": {
      "password": "parent123",
      "role": "parent",
    },
  };

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));

      final email = _emailController.text.trim();
      final password = _passwordController.text;

      try {
        // Mock authentication logic
        if (_mockUsers.containsKey(email) && _mockUsers[email]!["password"] == password) {
          final userRole = _mockUsers[email]!["role"];
          
          if (userRole == "teacher") {
            if (mounted) {
              Navigator.pushReplacementNamed(context, '/teacher-dashboard-screen');
            }
          } else if (userRole == "parent") {
            if (mounted) {
              Navigator.pushReplacementNamed(context, '/parent-dashboard-screen');
            }
          }
        } else {
          setState(() {
            _errorMessage = "Invalid email or password. Please try again.";
            _isLoading = false;
          });
        }
      } catch (e) {
        setState(() {
          _errorMessage = "Network error. Please check your connection and try again.";
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Login',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          SizedBox(height: 1.h),
          Text(
            'Please sign in to continue',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondary,
                ),
          ),
          SizedBox(height: 3.h),
          if (_errorMessage != null) _buildErrorMessage(),
          SizedBox(height: _errorMessage != null ? 2.h : 0),
          _buildEmailField(),
          SizedBox(height: 2.h),
          _buildPasswordField(),
          SizedBox(height: 1.h),
          _buildRememberMeAndForgotPassword(),
          SizedBox(height: 3.h),
          _buildLoginButton(),
          SizedBox(height: 2.h),
          _buildRoleSelector(),
        ],
      ),
    );
  }

  Widget _buildErrorMessage() {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.errorLight,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.error.withAlpha(77)),
      ),
      child: Row(
        children: [
          const CustomIconWidget(
            iconName: 'error',
            color: AppTheme.error,
            size: 20,
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Text(
              _errorMessage!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.error,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
        labelText: 'Email',
        hintText: 'Enter your email',
        prefixIcon: CustomIconWidget(
          iconName: 'email',
          color: AppTheme.textSecondary,
          size: 20,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your email';
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
      obscureText: !_isPasswordVisible,
      decoration: InputDecoration(
        labelText: 'Password',
        hintText: 'Enter your password',
        prefixIcon: const CustomIconWidget(
          iconName: 'lock',
          color: AppTheme.textSecondary,
          size: 20,
        ),
        suffixIcon: IconButton(
          icon: CustomIconWidget(
            iconName: _isPasswordVisible ? 'visibility_off' : 'visibility',
            color: AppTheme.textSecondary,
            size: 20,
          ),
          onPressed: _togglePasswordVisibility,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your password';
        }
        if (value.length < 6) {
          return 'Password must be at least 6 characters';
        }
        return null;
      },
    );
  }

  Widget _buildRememberMeAndForgotPassword() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SizedBox(
              height: 24,
              width: 24,
              child: Checkbox(
                value: _rememberMe,
                onChanged: (value) {
                  setState(() {
                    _rememberMe = value ?? false;
                  });
                },
              ),
            ),
            SizedBox(width: 1.w),
            Text(
              'Remember me',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        TextButton(
          onPressed: () {
            // Show forgot password dialog
            _showForgotPasswordDialog();
          },
          child: Text(
            'Forgot Password?',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.primary,
                ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      height: 6.h,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleLogin,
        child: _isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Text('Login'),
      ),
    );
  }

  Widget _buildRoleSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Login:',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.textSecondary,
              ),
        ),
        SizedBox(height: 1.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildRoleButton(
              title: 'Teacher',
              icon: 'school',
              onTap: () {
                _emailController.text = 'teacher@example.com';
                _passwordController.text = 'teacher123';
              },
            ),
            SizedBox(width: 4.w),
            _buildRoleButton(
              title: 'Parent',
              icon: 'family_restroom',
              onTap: () {
                _emailController.text = 'parent@example.com';
                _passwordController.text = 'parent123';
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRoleButton({
    required String title,
    required String icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
        decoration: BoxDecoration(
          border: Border.all(color: AppTheme.border),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            CustomIconWidget(
              iconName: icon,
              color: AppTheme.primary,
              size: 24,
            ),
            SizedBox(height: 0.5.h),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  void _showForgotPasswordDialog() {
    final TextEditingController emailController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Enter your email address and we\'ll send you instructions to reset your password.',
            ),
            SizedBox(height: 2.h),
            TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'Enter your email',
                prefixIcon: CustomIconWidget(
                  iconName: 'email',
                  color: AppTheme.textSecondary,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // Show success message
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Password reset instructions sent to your email'),
                  backgroundColor: AppTheme.success,
                ),
              );
            },
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }
}