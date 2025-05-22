import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/empty_notes_widget.dart';
import './widgets/loading_skeleton_widget.dart';
import './widgets/note_card_widget.dart';
import './widgets/student_filter_widget.dart';

class ParentDashboardScreen extends StatefulWidget {
  const ParentDashboardScreen({super.key});

  @override
  State<ParentDashboardScreen> createState() => _ParentDashboardScreenState();
}

class _ParentDashboardScreenState extends State<ParentDashboardScreen> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  bool isLoading = true;
  String? errorMessage;
  String selectedStatusFilter = 'All';
  String? selectedStudentId;
  
  // Mock data for parent's children
  late List<Map<String, dynamic>> children;
  // Mock data for notes
  late List<Map<String, dynamic>> allNotes;
  late List<Map<String, dynamic>> filteredNotes;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    // Simulate API call delay
    await Future.delayed(const Duration(milliseconds: 1200));
    
    try {
      // In a real app, this would fetch data from Firestore
      setState(() {
        children = [
          {
            "id": "1",
            "name": "Emma Thompson",
            "grade": "5th Grade",
            "avatar": "https://randomuser.me/api/portraits/women/44.jpg",
          },
          {
            "id": "2",
            "name": "Noah Martinez",
            "grade": "3rd Grade",
            "avatar": "https://randomuser.me/api/portraits/men/32.jpg",
          },
        ];
        
        allNotes = [
          {
            "id": "note1",
            "student_id": "1",
            "student_name": "Emma Thompson",
            "status": "Positive",
            "feedback": "Emma did an excellent job on her math test today. She showed great problem-solving skills and attention to detail.",
            "homework_status": "Completed",
            "timestamp": DateTime.now().subtract(const Duration(hours: 5)),
            "teacher_name": "Ms. Johnson"
          },
          {
            "id": "note2",
            "student_id": "1",
            "student_name": "Emma Thompson",
            "status": "Neutral",
            "feedback": "Emma participated in class discussion today but seemed a bit distracted during independent work time.",
            "homework_status": "Incomplete",
            "timestamp": DateTime.now().subtract(const Duration(days: 1, hours: 3)),
            "teacher_name": "Ms. Johnson"
          },
          {
            "id": "note3",
            "student_id": "2",
            "student_name": "Noah Martinez",
            "status": "Positive",
            "feedback": "Noah showed great improvement in his reading comprehension this week. He was able to answer complex questions about the story.",
            "homework_status": "Completed",
            "timestamp": DateTime.now().subtract(const Duration(days: 2)),
            "teacher_name": "Mr. Davis"
          },
          {
            "id": "note4",
            "student_id": "1",
            "student_name": "Emma Thompson",
            "status": "Negative",
            "feedback": "Emma did not complete her science project by the deadline. Please discuss the importance of time management with her.",
            "homework_status": "Missing",
            "timestamp": DateTime.now().subtract(const Duration(days: 3, hours: 5)),
            "teacher_name": "Ms. Wilson"
          },
          {
            "id": "note5",
            "student_id": "2",
            "student_name": "Noah Martinez",
            "status": "Negative",
            "feedback": "Noah was disruptive during quiet reading time today. He needs to work on respecting classroom rules.",
            "homework_status": "Incomplete",
            "timestamp": DateTime.now().subtract(const Duration(days: 4, hours: 2)),
            "teacher_name": "Mr. Davis"
          },
        ];
        
        // Initially, show all notes sorted by timestamp (newest first)
        filteredNotes = List.from(allNotes)
          ..sort((a, b) => (b["timestamp"] as DateTime).compareTo(a["timestamp"] as DateTime));
        
        isLoading = false;
        errorMessage = null;
      });
    } catch (e) {
      setState(() {
        errorMessage = "Failed to load data. Please try again.";
        isLoading = false;
      });
    }
  }

  void _applyFilters() {
    setState(() {
      // Start with all notes
      filteredNotes = List.from(allNotes);
      
      // Apply student filter if selected
      if (selectedStudentId != null) {
        filteredNotes = filteredNotes.where((note) => note["student_id"] == selectedStudentId).toList();
      }
      
      // Apply status filter if not 'All'
      if (selectedStatusFilter != 'All') {
        filteredNotes = filteredNotes.where((note) => note["status"] == selectedStatusFilter).toList();
      }
      
      // Sort by timestamp (newest first)
      filteredNotes.sort((a, b) => (b["timestamp"] as DateTime).compareTo(a["timestamp"] as DateTime));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Parent Dashboard',
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
          setState(() {
            isLoading = true;
          });
          await _loadData();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWelcomeSection(),
              SizedBox(height: 3.h),
              _buildFilterSection(),
              SizedBox(height: 2.h),
              _buildNotesList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome, Parent',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 1.h),
            Text(
              'View the latest updates and feedback for your children below.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
            SizedBox(height: 2.h),
            Row(
              children: [
                const CustomIconWidget(
                  iconName: 'info',
                  color: AppTheme.primary,
                  size: 20,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    'Pull down to refresh for the latest updates.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Feedback & Notes',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              '${filteredNotes.length} ${filteredNotes.length == 1 ? 'note' : 'notes'}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        SizedBox(height: 2.h),
        StudentFilterWidget(
          students: children,
          selectedStudentId: selectedStudentId,
          selectedStatus: selectedStatusFilter,
          onStudentChanged: (String? studentId) {
            setState(() {
              selectedStudentId = studentId;
              _applyFilters();
            });
          },
          onStatusChanged: (String status) {
            setState(() {
              selectedStatusFilter = status;
              _applyFilters();
            });
          },
        ),
      ],
    );
  }

  Widget _buildNotesList() {
    if (isLoading) {
      return const LoadingSkeletonWidget();
    }

    if (errorMessage != null) {
      return _buildErrorState();
    }

    if (filteredNotes.isEmpty) {
      return EmptyNotesWidget(
        message: selectedStudentId != null || selectedStatusFilter != 'All'
            ? 'No notes match your current filters.'
            : 'No notes available yet.',
        onReset: () {
          setState(() {
            selectedStudentId = null;
            selectedStatusFilter = 'All';
            _applyFilters();
          });
        },
      );
    }

    // Group notes by date for better organization
    final Map<String, List<Map<String, dynamic>>> groupedNotes = {};
    
    for (final note in filteredNotes) {
      final DateTime timestamp = note["timestamp"] as DateTime;
      final String dateKey = _formatDateKey(timestamp);
      
      if (!groupedNotes.containsKey(dateKey)) {
        groupedNotes[dateKey] = [];
      }
      
      groupedNotes[dateKey]!.add(note);
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: groupedNotes.length,
      itemBuilder: (context, index) {
        final String dateKey = groupedNotes.keys.elementAt(index);
        final List<Map<String, dynamic>> dayNotes = groupedNotes[dateKey]!;
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 1.h),
              child: Text(
                dateKey,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
            ),
            ...dayNotes.map((note) => NoteCardWidget(note: note)),
            SizedBox(height: 1.h),
          ],
        );
      },
    );
  }

  String _formatDateKey(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final noteDate = DateTime(date.year, date.month, date.day);
    
    if (noteDate == today) {
      return 'Today';
    } else if (noteDate == yesterday) {
      return 'Yesterday';
    } else {
      // Format as Month Day, Year (e.g., "June 15, 2023")
      return '${_getMonthName(date.month)} ${date.day}, ${date.year}';
    }
  }

  String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
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
              _loadData();
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
}