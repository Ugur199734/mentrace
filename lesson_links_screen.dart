import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';

import '../../core/app_export.dart';

class LessonLinksScreen extends StatefulWidget {
  const LessonLinksScreen({super.key});

  @override
  State<LessonLinksScreen> createState() => _LessonLinksScreenState();
}

class _LessonLinksScreenState extends State<LessonLinksScreen> {
  bool isTeacher = false;
  bool isLoading = true;
  String? errorMessage;
  final _formKey = GlobalKey<FormState>();
  
  // Form controllers
  final TextEditingController _studentController = TextEditingController();
  final TextEditingController _lessonTitleController = TextEditingController();
  final TextEditingController _linkController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  
  // Mock data for students
  late List<Map<String, dynamic>> students;
  
  // Mock data for lesson links
  late List<Map<String, dynamic>> lessonLinks;
  
  // Selected student for dropdown
  String? selectedStudentId;
  
  // For pagination
  int _currentPage = 0;
  final int _itemsPerPage = 10;
  
  @override
  void initState() {
    super.initState();
    _loadUserRole();
    _loadData();
  }
  
  @override
  void dispose() {
    _studentController.dispose();
    _lessonTitleController.dispose();
    _linkController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }
  
  Future<void> _loadUserRole() async {
    // Simulating a network call to get user role
    await Future.delayed(const Duration(milliseconds: 500));
    
    // For demo purposes, detect if coming from teacher or parent dashboard
    final String? previousRoute = ModalRoute.of(context)?.settings.name;
    setState(() {
      isTeacher = previousRoute == '/teacher-dashboard-screen';
    });
  }
  
  Future<void> _loadData() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    
    try {
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 1000));
      
      // Mock data that would come from Firestore
      setState(() {
        students = [
          {
            "id": "1",
            "name": "Emma Thompson",
            "grade": "5th Grade",
            "avatar": "https://randomuser.me/api/portraits/women/44.jpg",
          },
          {
            "id": "2",
            "name": "Noah Martinez",
            "grade": "5th Grade",
            "avatar": "https://randomuser.me/api/portraits/men/32.jpg",
          },
          {
            "id": "3",
            "name": "Olivia Johnson",
            "grade": "5th Grade",
            "avatar": "https://randomuser.me/api/portraits/women/67.jpg",
          },
          {
            "id": "4",
            "name": "Liam Williams",
            "grade": "5th Grade",
            "avatar": "https://randomuser.me/api/portraits/men/52.jpg",
          },
          {
            "id": "5",
            "name": "Ava Brown",
            "grade": "5th Grade",
            "avatar": "https://randomuser.me/api/portraits/women/90.jpg",
          },
        ];
        
        lessonLinks = [
          {
            "id": "link1",
            "student_id": "1",
            "student_name": "Emma Thompson",
            "lesson_title": "Mathematics - Fractions",
            "link": "https://example.com/math/fractions",
            "date": DateTime.now().subtract(const Duration(days: 1)),
            "time": "14:30",
            "teacher_id": "teacher1",
            "teacher_name": "Ms. Johnson",
            "created_at": DateTime.now().subtract(const Duration(days: 1, hours: 3)),
          },
          {
            "id": "link2",
            "student_id": "2",
            "student_name": "Noah Martinez",
            "lesson_title": "Science - Solar System",
            "link": "https://example.com/science/solar-system",
            "date": DateTime.now().add(const Duration(days: 2)),
            "time": "10:15",
            "teacher_id": "teacher1",
            "teacher_name": "Ms. Johnson",
            "created_at": DateTime.now().subtract(const Duration(days: 2)),
          },
          {
            "id": "link3",
            "student_id": "3",
            "student_name": "Olivia Johnson",
            "lesson_title": "English - Grammar",
            "link": "https://example.com/english/grammar",
            "date": DateTime.now().add(const Duration(days: 1)),
            "time": "13:00",
            "teacher_id": "teacher1",
            "teacher_name": "Mr. Davis",
            "created_at": DateTime.now().subtract(const Duration(hours: 5)),
          },
        ];
        
        // Sort by creation date (newest first)
        lessonLinks.sort((a, b) => (b["created_at"] as DateTime).compareTo(a["created_at"] as DateTime));
        
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = "Failed to load data. Please try again.";
        isLoading = false;
      });
    }
  }
  
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }
  
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _timeController.text = picked.format(context);
      });
    }
  }
  
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Simulate saving to Firestore
      final newLink = {
        "id": "link${lessonLinks.length + 1}",
        "student_id": selectedStudentId,
        "student_name": students.firstWhere((s) => s["id"] == selectedStudentId)["name"],
        "lesson_title": _lessonTitleController.text,
        "link": _linkController.text,
        "date": DateFormat('yyyy-MM-dd').parse(_dateController.text),
        "time": _timeController.text,
        "teacher_id": "teacher1", // Would come from auth in real app
        "teacher_name": "Ms. Johnson", // Would come from auth in real app
        "created_at": DateTime.now(),
      };
      
      setState(() {
        lessonLinks.insert(0, newLink);
      });
      
      // Reset the form
      _formKey.currentState!.reset();
      selectedStudentId = null;
      _lessonTitleController.clear();
      _linkController.clear();
      _dateController.clear();
      _timeController.clear();
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lesson link added successfully'),
          backgroundColor: AppTheme.success,
        ),
      );
    }
  }
  
  void _editLessonLink(Map<String, dynamic> link) {
    // Populate form with existing data
    setState(() {
      selectedStudentId = link["student_id"];
      _lessonTitleController.text = link["lesson_title"];
      _linkController.text = link["link"];
      _dateController.text = DateFormat('yyyy-MM-dd').format(link["date"]);
      _timeController.text = link["time"];
    });
    
    // Scroll to the form
    Scrollable.ensureVisible(
      _formKey.currentContext!,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }
  
  void _deleteLessonLink(String linkId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Lesson Link'),
        content: const Text('Are you sure you want to delete this lesson link?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                lessonLinks.removeWhere((link) => link["id"] == linkId);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Lesson link deleted successfully'),
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
  
  List<Map<String, dynamic>> get _paginatedLinks {
    final startIndex = _currentPage * _itemsPerPage;
    final endIndex = startIndex + _itemsPerPage;
    return lessonLinks.sublist(
      startIndex,
      endIndex > lessonLinks.length ? lessonLinks.length : endIndex,
    );
  }
  
  int get _pageCount => (lessonLinks.length / _itemsPerPage).ceil();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Lesson Links',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        leading: IconButton(
          icon: const CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.textSecondary,
            size: 24,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildReturnToDashboardButton(),
              SizedBox(height: 2.h),
              _buildHeader(),
              SizedBox(height: 3.h),
              if (isTeacher) _buildLessonLinkForm(),
              SizedBox(height: isTeacher ? 4.h : 2.h),
              _buildLessonLinksSection(),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildReturnToDashboardButton() {
    return OutlinedButton.icon(
      onPressed: () {
        Navigator.pushReplacementNamed(
          context,
          isTeacher ? '/teacher-dashboard-screen' : '/parent-dashboard-screen',
        );
      },
      icon: const CustomIconWidget(
        iconName: 'dashboard',
        color: AppTheme.primary,
        size: 20,
      ),
      label: const Text('Panoya Dön'),
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      ),
    );
  }
  
  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.primaryLight,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CustomIconWidget(
                iconName: 'link',
                color: AppTheme.primary,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text(
                isTeacher ? 'Ders Bağlantıları Yönetimi' : 'Ders Bağlantıları',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            isTeacher
                ? 'Öğrencileriniz için ders bağlantılarını ekleyin ve yönetin.'
                : 'Öğretmenleriniz tarafından paylaşılan ders bağlantılarını görüntüleyin.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.primary,
                ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildLessonLinkForm() {
    return Form(
      key: _formKey,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Yeni Ders Bağlantısı Ekle',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(height: 2.h),
              _buildStudentDropdown(),
              SizedBox(height: 2.h),
              TextFormField(
                controller: _lessonTitleController,
                decoration: const InputDecoration(
                  labelText: 'Ders Başlığı',
                  hintText: 'Ders başlığını girin',
                  prefixIcon: CustomIconWidget(
                    iconName: 'subject',
                    color: AppTheme.textSecondary,
                    size: 20,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen ders başlığını girin';
                  }
                  return null;
                },
              ),
              SizedBox(height: 2.h),
              TextFormField(
                controller: _linkController,
                decoration: const InputDecoration(
                  labelText: 'Link',
                  hintText: 'Ders bağlantı linkini girin',
                  prefixIcon: CustomIconWidget(
                    iconName: 'link',
                    color: AppTheme.textSecondary,
                    size: 20,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen bağlantı linkini girin';
                  }
                  if (!Uri.parse(value).isAbsolute) {
                    return 'Lütfen geçerli bir URL girin';
                  }
                  return null;
                },
              ),
              SizedBox(height: 2.h),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _dateController,
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: 'Tarih',
                        hintText: 'Tarih seçin',
                        prefixIcon: CustomIconWidget(
                          iconName: 'calendar_today',
                          color: AppTheme.textSecondary,
                          size: 20,
                        ),
                      ),
                      onTap: () => _selectDate(context),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Lütfen tarih seçin';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: TextFormField(
                      controller: _timeController,
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: 'Saat',
                        hintText: 'Saat seçin',
                        prefixIcon: CustomIconWidget(
                          iconName: 'access_time',
                          color: AppTheme.textSecondary,
                          size: 20,
                        ),
                      ),
                      onTap: () => _selectTime(context),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Lütfen saat seçin';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 3.h),
              SizedBox(
                width: double.infinity,
                height: 6.h,
                child: ElevatedButton.icon(
                  onPressed: _submitForm,
                  icon: const CustomIconWidget(
                    iconName: 'save',
                    color: Colors.white,
                    size: 20,
                  ),
                  label: const Text('Kaydet'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildStudentDropdown() {
    return DropdownButtonFormField<String>(
      value: selectedStudentId,
      decoration: const InputDecoration(
        labelText: 'Öğrenci Adı',
        hintText: 'Öğrenci seçin',
        prefixIcon: CustomIconWidget(
          iconName: 'person',
          color: AppTheme.textSecondary,
          size: 20,
        ),
      ),
      items: students.map((student) {
        return DropdownMenuItem<String>(
          value: student["id"],
          child: Text(student["name"]),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          selectedStudentId = value;
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Lütfen bir öğrenci seçin';
        }
        return null;
      },
    );
  }
  
  Widget _buildLessonLinksSection() {
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

    if (lessonLinks.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Ders Bağlantıları Listesi',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              '${lessonLinks.length} bağlantı',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        SizedBox(height: 2.h),
        _buildLessonLinksTable(),
        if (_pageCount > 1) SizedBox(height: 2.h),
        if (_pageCount > 1) _buildPagination(),
      ],
    );
  }

  Widget _buildLessonLinksTable() {
    return MediaQuery.of(context).size.width > 600
        ? _buildDesktopTable()
        : _buildMobileTable();
  }

  Widget _buildDesktopTable() {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Öğrenci Adı')),
            DataColumn(label: Text('Ders Başlığı')),
            DataColumn(label: Text('Link')),
            DataColumn(label: Text('Tarih')),
            DataColumn(label: Text('Saat')),
            DataColumn(label: Text('İşlemler')),
          ],
          rows: _paginatedLinks.map((link) {
            return DataRow(
              cells: [
                DataCell(Text(link["student_name"])),
                DataCell(Text(link["lesson_title"])),
                DataCell(
                  InkWell(
                    onTap: () {
                      // Would open the link in a real app
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Link açılıyor: ${link["link"]}'),
                        ),
                      );
                    },
                    child: Text(
                      link["link"],
                      style: const TextStyle(
                        color: AppTheme.primary,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
                DataCell(Text(DateFormat('yyyy-MM-dd').format(link["date"]))),
                DataCell(Text(link["time"])),
                DataCell(
                  isTeacher
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const CustomIconWidget(
                                iconName: 'edit',
                                color: AppTheme.primary,
                                size: 20,
                              ),
                              onPressed: () => _editLessonLink(link),
                            ),
                            IconButton(
                              icon: const CustomIconWidget(
                                iconName: 'delete',
                                color: AppTheme.error,
                                size: 20,
                              ),
                              onPressed: () => _deleteLessonLink(link["id"]),
                            ),
                          ],
                        )
                      : const Text('Sadece görüntüleme'),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildMobileTable() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _paginatedLinks.length,
      separatorBuilder: (context, index) => SizedBox(height: 1.h),
      itemBuilder: (context, index) {
        final link = _paginatedLinks[index];
        return Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: EdgeInsets.all(3.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        link["lesson_title"],
                        style: Theme.of(context).textTheme.titleMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isTeacher)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const CustomIconWidget(
                              iconName: 'edit',
                              color: AppTheme.primary,
                              size: 20,
                            ),
                            onPressed: () => _editLessonLink(link),
                          ),
                          IconButton(
                            icon: const CustomIconWidget(
                              iconName: 'delete',
                              color: AppTheme.error,
                              size: 20,
                            ),
                            onPressed: () => _deleteLessonLink(link["id"]),
                          ),
                        ],
                      ),
                  ],
                ),
                SizedBox(height: 1.h),
                _buildInfoRow('Öğrenci Adı', link["student_name"]),
                SizedBox(height: 0.5.h),
                _buildInfoRow(
                  'Tarih ve Saat',
                  '${DateFormat('yyyy-MM-dd').format(link["date"])} | ${link["time"]}',
                ),
                SizedBox(height: 0.5.h),
                _buildLinkRow('Link', link["link"]),
                SizedBox(height: 0.5.h),
                _buildInfoRow('Öğretmen', link["teacher_name"]),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 35.w,
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }

  Widget _buildLinkRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 35.w,
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ),
        Expanded(
          child: InkWell(
            onTap: () {
              // Would open the link in a real app
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Link açılıyor: $value'),
                ),
              );
            },
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.primary,
                    decoration: TextDecoration.underline,
                  ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPagination() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const CustomIconWidget(
            iconName: 'navigate_before',
            color: AppTheme.textSecondary,
            size: 24,
          ),
          onPressed: _currentPage > 0
              ? () {
                  setState(() {
                    _currentPage--;
                  });
                }
              : null,
        ),
        for (int i = 0; i < _pageCount; i++)
          InkWell(
            onTap: () {
              setState(() {
                _currentPage = i;
              });
            },
            borderRadius: BorderRadius.circular(4),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _currentPage == i ? AppTheme.primary : null,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '${i + 1}',
                style: TextStyle(
                  color: _currentPage == i ? Colors.white : AppTheme.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        IconButton(
          icon: const CustomIconWidget(
            iconName: 'navigate_next',
            color: AppTheme.textSecondary,
            size: 24,
          ),
          onPressed: _currentPage < _pageCount - 1
              ? () {
                  setState(() {
                    _currentPage++;
                  });
                }
              : null,
        ),
      ],
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
            iconName: 'link_off',
            color: AppTheme.textTertiary,
            size: 48,
          ),
          SizedBox(height: 2.h),
          Text(
            'Henüz ders bağlantısı eklenmemiş',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppTheme.textSecondary,
                ),
          ),
          SizedBox(height: 1.h),
          Text(
            isTeacher
                ? 'Öğrencileriniz için yeni bir ders bağlantısı ekleyin'
                : 'Öğretmenleriniz bağlantı eklediğinde burada görünecek',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textTertiary,
                ),
            textAlign: TextAlign.center,
          ),
          if (isTeacher) SizedBox(height: 2.h),
          if (isTeacher)
            ElevatedButton.icon(
              onPressed: () {
                // Scroll to form
                Scrollable.ensureVisible(
                  _formKey.currentContext ?? context,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              },
              icon: const CustomIconWidget(
                iconName: 'add_link',
                color: Colors.white,
                size: 18,
              ),
              label: const Text('Bağlantı Ekle'),
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
            onPressed: _loadData,
            icon: const CustomIconWidget(
              iconName: 'refresh',
              color: Colors.white,
              size: 18,
            ),
            label: const Text('Tekrar Dene'),
          ),
        ],
      ),
    );
  }
}
