import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  static const List<Map<String, Object>> _items = [
    {
      'title': 'Class reminder',
      'body': 'Data Structures starts at 10:00 AM in DK3, Block A.',
      'icon': Icons.calendar_month_rounded,
      'isRead': false,
    },
    {
      'title': 'Booking submitted',
      'body': 'Your room booking request has been added to the UI preview.',
      'icon': Icons.meeting_room_rounded,
      'isRead': false,
    },
    {
      'title': 'Order placed',
      'body': 'Your campus cafe demo order was placed successfully.',
      'icon': Icons.receipt_long_rounded,
      'isRead': true,
    },
    {
      'title': 'Study planner',
      'body': 'Quiz preparation is scheduled for tomorrow.',
      'icon': Icons.task_alt_rounded,
      'isRead': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1E293B),
        elevation: 0,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final item = _items[index];
          final isRead = item['isRead'] as bool;
          return Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(
                color: isRead ? const Color(0xFFE2E8F0) : const Color(0xFF93C5FD),
              ),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: isRead ? const Color(0xFFF1F5F9) : const Color(0xFFDBEAFE),
                child: Icon(
                  item['icon'] as IconData,
                  color: isRead ? const Color(0xFF64748B) : const Color(0xFF2563EB),
                ),
              ),
              title: Text(
                item['title'] as String,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              subtitle: Text(item['body'] as String),
              trailing: isRead
                  ? null
                  : Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: Color(0xFF2563EB),
                        shape: BoxShape.circle,
                      ),
                    ),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${item['title']} opened')),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
