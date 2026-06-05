import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uthm_smart_campus/models/reminder_model.dart';
import 'package:uthm_smart_campus/services/notification_service.dart';
import 'package:uthm_smart_campus/utils/app_language.dart';
import 'package:uthm_smart_campus/utils/main_navigation.dart';

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({super.key});

  @override
  State<ReminderScreen> createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  static const Color kBlue700 = Color(0xFF113A6E);
  static const Color kBlue500 = Color(0xFF2563EB);
  static const Color kGray50 = Color(0xFFF8FAFC);
  static const Color kGray100 = Color(0xFFF1F5F9);
  static const Color kGray200 = Color(0xFFE2E8F0);
  static const Color kGray400 = Color(0xFF94A3B8);
  static const Color kGray500 = Color(0xFF64748B);
  static const Color kGray800 = Color(0xFF1E293B);
  static const Color kGreen = Color(0xFF10B981);
  static const Color kRed = Color(0xFFEF4444);
  static const Color kAmber = Color(0xFFF59E0B);
  static const Color kPurple = Color(0xFF7C3AED);

  static const String _storageKey = 'student_reminders';

  final DateFormat _dateFormat = DateFormat('EEE, d MMM yyyy');
  final DateFormat _timeFormat = DateFormat('h:mm a');
  final List<ReminderModel> _reminders = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadReminders();
  }

  Future<void> _loadReminders() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList(_storageKey) ?? [];
    final reminders = saved.map(ReminderModel.fromJson).toList()
      ..sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));

    if (!mounted) return;
    setState(() {
      _reminders
        ..clear()
        ..addAll(reminders);
      _isLoading = false;
    });

    for (final reminder in reminders.where((item) => !item.isPast)) {
      await NotificationService.instance.scheduleReminder(reminder);
    }
  }

  Future<void> _saveReminders() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _storageKey,
      _reminders.map((item) => item.toJson()).toList(),
    );
  }

  Future<void> _addReminder(ReminderModel reminder) async {
    setState(() {
      _reminders.add(reminder);
      _reminders.sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
    });
    await _saveReminders();
    await NotificationService.instance.scheduleReminder(reminder);
  }

  Future<void> _deleteReminder(ReminderModel reminder) async {
    setState(() => _reminders.removeWhere((item) => item.id == reminder.id));
    await _saveReminders();
    await NotificationService.instance.cancelReminder(reminder.id);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.tr('Reminder deleted')),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  int get _pendingCount => _reminders.where((item) => !item.isPast).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kGray50,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _reminders.isEmpty
                    ? _buildEmptyState()
                    : RefreshIndicator(
                        onRefresh: _loadReminders,
                        child: ListView.separated(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
                          itemCount: _reminders.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            return _buildReminderCard(_reminders[index]);
                          },
                        ),
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showReminderSheet,
        backgroundColor: kBlue500,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: Text(context.tr('Add Reminder')),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [kBlue700, kBlue500],
        ),
      ),
      padding: EdgeInsets.fromLTRB(
        20,
        MediaQuery.of(context).padding.top + 14,
        20,
        20,
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.maybePop(context),
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            color: Colors.white,
            style: IconButton.styleFrom(
              backgroundColor: Colors.white.withValues(alpha: 0.14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.tr('Reminders'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  context.tr('Academic alerts and study tasks'),
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.72),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '$_pendingCount pending',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReminderCard(ReminderModel reminder) {
    final color = _typeColor(reminder.type);
    final isPast = reminder.isPast;

    return Dismissible(
      key: ValueKey(reminder.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: kRed,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.delete_rounded, color: Colors.white),
      ),
      confirmDismiss: (_) => _confirmDelete(reminder),
      child: Card(
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: isPast ? kGray200 : color.withValues(alpha: 0.4),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: isPast ? 0.08 : 0.14),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(_typeIcon(reminder.type), color: color),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            reminder.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: isPast ? kGray500 : kGray800,
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        _buildTypeChip(reminder.type),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      reminder.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: isPast ? kGray400 : kGray500,
                        fontSize: 12,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(
                          isPast
                              ? Icons.history_rounded
                              : Icons.schedule_rounded,
                          color: isPast ? kGray400 : color,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            '${_dateFormat.format(reminder.scheduledAt)} at '
                            '${_timeFormat.format(reminder.scheduledAt)}',
                            style: TextStyle(
                              color: isPast ? kGray400 : kGray800,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: context.tr('Delete'),
                onPressed: () => _confirmDelete(reminder),
                icon: const Icon(Icons.delete_outline_rounded),
                color: kGray400,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeChip(ReminderType type) {
    final color = _typeColor(type);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        type.label,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 86,
              height: 86,
              decoration: const BoxDecoration(
                color: Color(0xFFDBEAFE),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.notifications_active_rounded,
                size: 42,
                color: kBlue500,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              context.tr('No reminders yet'),
              style: const TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w800,
                color: kGray800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              context.tr(
                'Create quiz, survey, study, or custom alerts for your academic tasks.',
              ),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: kGray500,
                fontSize: 13,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: _showReminderSheet,
              icon: const Icon(Icons.add_rounded),
              label: Text(context.tr('Create Reminder')),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _confirmDelete(ReminderModel reminder) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.tr('Delete reminder?')),
        content: Text(
            context.tr('This will also cancel the scheduled notification.')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.tr('Cancel')),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: kRed),
            child: Text(context.tr('Delete')),
          ),
        ],
      ),
    );

    if (shouldDelete == true) {
      await _deleteReminder(reminder);
      return true;
    }
    return false;
  }

  Future<void> _showReminderSheet() async {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    DateTime selectedDate = DateTime.now();
    TimeOfDay selectedTime = TimeOfDay.now();
    ReminderType selectedType = ReminderType.quiz;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            final scheduledAt = DateTime(
              selectedDate.year,
              selectedDate.month,
              selectedDate.day,
              selectedTime.hour,
              selectedTime.minute,
            );

            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 42,
                          height: 4,
                          decoration: BoxDecoration(
                            color: kGray200,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        context.tr('Create Reminder'),
                        style: const TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w800,
                          color: kGray800,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: titleController,
                        label: context.tr('Title'),
                        hint: context.tr('Your quiz is starting soon'),
                        icon: Icons.title_rounded,
                      ),
                      const SizedBox(height: 12),
                      _buildTextField(
                        controller: descriptionController,
                        label: context.tr('Description'),
                        hint: context.tr('Add details about this reminder'),
                        icon: Icons.notes_rounded,
                        maxLines: 3,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        context.tr('Reminder Type'),
                        style: const TextStyle(
                          color: kGray500,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: ReminderType.values.map((type) {
                          final isSelected = selectedType == type;
                          final color = _typeColor(type);
                          return ChoiceChip(
                            selected: isSelected,
                            avatar: Icon(
                              _typeIcon(type),
                              size: 18,
                              color: isSelected ? Colors.white : color,
                            ),
                            label: Text(type.label),
                            labelStyle: TextStyle(
                              color: isSelected ? Colors.white : kGray800,
                              fontWeight: FontWeight.w700,
                            ),
                            selectedColor: color,
                            backgroundColor: kGray50,
                            side: BorderSide(
                                color: isSelected ? color : kGray200),
                            onSelected: (_) =>
                                setSheetState(() => selectedType = type),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildPickerButton(
                              icon: Icons.calendar_today_rounded,
                              label: _dateFormat.format(selectedDate),
                              onTap: () async {
                                final picked = await showDatePicker(
                                  context: context,
                                  initialDate: selectedDate,
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.now().add(
                                    const Duration(days: 365 * 2),
                                  ),
                                );
                                if (picked != null) {
                                  setSheetState(() => selectedDate = picked);
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _buildPickerButton(
                              icon: Icons.access_time_rounded,
                              label: selectedTime.format(context),
                              onTap: () async {
                                final picked = await showTimePicker(
                                  context: context,
                                  initialTime: selectedTime,
                                );
                                if (picked != null) {
                                  setSheetState(() => selectedTime = picked);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: kGray50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: kGray200),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.notifications_rounded,
                                color: kBlue500, size: 18),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                '${context.tr('Notification time')}: '
                                '${_dateFormat.format(scheduledAt)}, '
                                '${_timeFormat.format(scheduledAt)}',
                                style: const TextStyle(
                                  color: kGray800,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: FilledButton.icon(
                          onPressed: () async {
                            await _handleSaveReminder(
                              title: titleController.text,
                              description: descriptionController.text,
                              scheduledAt: scheduledAt,
                              type: selectedType,
                              sheetContext: context,
                            );
                          },
                          icon: const Icon(Icons.check_rounded),
                          label: Text(context.tr('Save Reminder')),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );

    titleController.dispose();
    descriptionController.dispose();
  }

  Future<void> _handleSaveReminder({
    required String title,
    required String description,
    required DateTime scheduledAt,
    required ReminderType type,
    required BuildContext sheetContext,
  }) async {
    final trimmedTitle = title.trim();
    final trimmedDescription = description.trim();

    if (trimmedTitle.isEmpty) {
      _showMessage(context.tr('Please add a reminder title'));
      return;
    }

    if (scheduledAt.isBefore(DateTime.now())) {
      _showMessage(context.tr('Please choose a future date and time'));
      return;
    }

    final reminder = ReminderModel(
      id: DateTime.now().millisecondsSinceEpoch.remainder(2147483647),
      title: trimmedTitle,
      description: trimmedDescription.isEmpty
          ? _defaultDescription(type)
          : trimmedDescription,
      scheduledAt: scheduledAt,
      type: type,
      createdAt: DateTime.now(),
    );

    final navigator = Navigator.of(sheetContext);
    final successMessage = context.tr('Reminder saved');

    if (!mounted) return;
    await _addReminder(reminder);
    navigator.pop();
    _showMessage(successMessage);
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: kGray50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: kGray200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: kGray200),
        ),
      ),
    );
  }

  Widget _buildPickerButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 18),
      label: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      style: OutlinedButton.styleFrom(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        side: const BorderSide(color: kGray200),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: kGray100)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 62,
          child: Row(
            children: List.generate(kMainNavItems.length, (index) {
              final item = kMainNavItems[index];
              final isActive = index == 2;
              return Expanded(
                child: InkWell(
                  onTap: () => navigateToMainTab(context, index, '/reminder'),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        item['icon'] as IconData,
                        color: isActive ? kBlue500 : kGray400,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        context.tr(item['label'] as String),
                        style: TextStyle(
                          color: isActive ? kBlue500 : kGray400,
                          fontSize: 10,
                          fontWeight:
                              isActive ? FontWeight.w800 : FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  IconData _typeIcon(ReminderType type) {
    switch (type) {
      case ReminderType.quiz:
        return Icons.quiz_rounded;
      case ReminderType.survey:
        return Icons.assignment_turned_in_rounded;
      case ReminderType.study:
        return Icons.menu_book_rounded;
      case ReminderType.other:
        return Icons.notifications_rounded;
    }
  }

  Color _typeColor(ReminderType type) {
    switch (type) {
      case ReminderType.quiz:
        return kRed;
      case ReminderType.survey:
        return kAmber;
      case ReminderType.study:
        return kGreen;
      case ReminderType.other:
        return kPurple;
    }
  }

  String _defaultDescription(ReminderType type) {
    switch (type) {
      case ReminderType.quiz:
        return 'Your quiz is starting soon';
      case ReminderType.survey:
        return 'Survey deadline is today';
      case ReminderType.study:
        return 'You should study today';
      case ReminderType.other:
        return 'Custom reminder alert';
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
