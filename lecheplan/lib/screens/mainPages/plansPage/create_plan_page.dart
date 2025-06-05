import 'package:flutter/material.dart';
import 'package:lecheplan/providers/theme_provider.dart';
import 'package:lecheplan/services/plans_services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';

final Logger _createPlanLogger = Logger('CreatePlanPage');

class CreatePlanPage extends StatefulWidget {
  const CreatePlanPage({super.key});

  @override
  State<CreatePlanPage> createState() => _CreatePlanPageState();
}

class _CreatePlanPageState extends State<CreatePlanPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _categoryController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  TimeOfDay _selectedEndTime = TimeOfDay.now().replacing(
    hour: (TimeOfDay.now().hour + 4) % 24,
  );
  final List<String> _selectedParticipants = [];
  final List<String> _availableUsers = [];
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  Future<void> _loadUsers() async {
    try {
      final users = await fetchAllUsers();
      setState(() {
        _availableUsers.addAll(
          users.map((u) => u['username'] as String).where((u) => u.isNotEmpty),
        );
      });
    } catch (e) {
      _createPlanLogger.warning('Error loading users: $e');
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: orangeAccentColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: darktextColor,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: orangeAccentColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: darktextColor,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Future<void> _selectEndTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedEndTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: orangeAccentColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: darktextColor,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedEndTime) {
      setState(() {
        _selectedEndTime = picked;
      });
    }
  }

  Future<void> _createPlan() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final planDateTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );
      final endDateTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedEndTime.hour,
        _selectedEndTime.minute,
      );

      final result = await createPlan(
        title: _titleController.text,
        category: _categoryController.text,
        planDateTime: planDateTime,
        endDateTime: endDateTime,
        participantUsernames: _selectedParticipants,
      );

      if (result['success']) {
        if (mounted) {
          context.pop(); // Return to previous page
        }
      } else {
        setState(() {
          _errorMessage = result['message'];
        });
      }
    } catch (e) {
      _createPlanLogger.severe('Error creating plan: $e');
      setState(() {
        _errorMessage = 'An unexpected error occurred';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0E1342)),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Create Plan',
          style: TextStyle(
            color: Color(0xFFFF6600),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF8F5FF), Colors.white],
          ), 
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title field
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: 'Title',
                      hintText: 'Enter plan title',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Category field
                  TextFormField(
                    controller: _categoryController,
                    decoration: InputDecoration(
                      labelText: 'Category',
                      hintText: 'e.g. Sports, Food, Study',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a category';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Date and Time selection
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () => _selectDate(context),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFFE0E0E0),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Date',
                                  style: TextStyle(
                                    color: Color(0xFF0E1342),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  DateFormat(
                                    'MMM d, yyyy',
                                  ).format(_selectedDate),
                                  style: const TextStyle(
                                    color: Color(0xFF0E1342),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: InkWell(
                          onTap: () => _selectTime(context),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFFE0E0E0),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Start Time',
                                  style: TextStyle(
                                    color: Color(0xFF0E1342),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _selectedTime.format(context),
                                  style: const TextStyle(
                                    color: Color(0xFF0E1342),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: InkWell(
                          onTap: () => _selectEndTime(context),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFFE0E0E0),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'End Time',
                                  style: TextStyle(
                                    color: Color(0xFF0E1342),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _selectedEndTime.format(context),
                                  style: const TextStyle(
                                    color: Color(0xFF0E1342),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Participants section
                  const Text(
                    'Participants',
                    style: TextStyle(
                      color: Color(0xFF0E1342),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE0E0E0)),
                    ),
                    child: Column(
                      children: [
                        ..._availableUsers.map((username) {
                          final isSelected = _selectedParticipants.contains(
                            username,
                          );
                          return ListTile(
                            title: Text(
                              username,
                              style: TextStyle(
                                color: darktextColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            trailing: Checkbox(
                              value: isSelected,
                              onChanged: (bool? value) {
                                setState(() {
                                  if (value == true) {
                                    _selectedParticipants.add(username);
                                  } else {
                                    _selectedParticipants.remove(username);
                                  }
                                });
                              },
                              activeColor: orangeAccentColor,
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Error message
                  if (_errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(color: Colors.red, fontSize: 14),
                      ),
                    ),

                  // Create button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _createPlan,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: orangeAccentColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      child:
                          _isLoading
                              ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                              : const Text('Create Plan'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
