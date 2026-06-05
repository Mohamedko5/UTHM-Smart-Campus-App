import 'dart:convert';

enum ReminderType {
  quiz,
  survey,
  study,
  other,
}

extension ReminderTypeLabel on ReminderType {
  String get label {
    switch (this) {
      case ReminderType.quiz:
        return 'Quiz';
      case ReminderType.survey:
        return 'Survey';
      case ReminderType.study:
        return 'Study';
      case ReminderType.other:
        return 'Other';
    }
  }

  static ReminderType fromName(String value) {
    return ReminderType.values.firstWhere(
      (type) => type.name == value,
      orElse: () => ReminderType.other,
    );
  }
}

class ReminderModel {
  const ReminderModel({
    required this.id,
    required this.title,
    required this.description,
    required this.scheduledAt,
    required this.type,
    required this.createdAt,
  });

  final int id;
  final String title;
  final String description;
  final DateTime scheduledAt;
  final ReminderType type;
  final DateTime createdAt;

  bool get isPast => scheduledAt.isBefore(DateTime.now());

  ReminderModel copyWith({
    int? id,
    String? title,
    String? description,
    DateTime? scheduledAt,
    ReminderType? type,
    DateTime? createdAt,
  }) {
    return ReminderModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'scheduledAt': scheduledAt.toIso8601String(),
      'type': type.name,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory ReminderModel.fromMap(Map<String, dynamic> map) {
    return ReminderModel(
      id: map['id'] as int,
      title: map['title'] as String,
      description: map['description'] as String,
      scheduledAt: DateTime.parse(map['scheduledAt'] as String),
      type: ReminderTypeLabel.fromName(map['type'] as String),
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }

  String toJson() => jsonEncode(toMap());

  factory ReminderModel.fromJson(String source) {
    return ReminderModel.fromMap(jsonDecode(source) as Map<String, dynamic>);
  }
}
