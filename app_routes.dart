import 'package:flutter/material.dart';
import '../presentation/teacher_dashboard_screen/teacher_dashboard_screen.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/registration_screen/registration_screen.dart';
import '../presentation/parent_dashboard_screen/parent_dashboard_screen.dart';
import '../presentation/lesson_links_screen/lesson_links_screen.dart';

class AppRoutes {
  static const String initial = '/';
  static const String teacherDashboardScreen = '/teacher-dashboard-screen';
  static const String loginScreen = '/login-screen';
  static const String registrationScreen = '/registration-screen';
  static const String parentDashboardScreen = '/parent-dashboard-screen';
  static const String lessonLinksScreen = '/lesson-links-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const LoginScreen(),
    teacherDashboardScreen: (context) => const TeacherDashboardScreen(),
    loginScreen: (context) => const LoginScreen(),
    registrationScreen: (context) => const RegistrationScreen(),
    parentDashboardScreen: (context) => const ParentDashboardScreen(),
    lessonLinksScreen: (context) => const LessonLinksScreen(),
  };
}
