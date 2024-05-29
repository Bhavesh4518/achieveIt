import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  final String id;
  final String title;
  final String taskBy;
  final String description;
  final DateTime dueDate;
  final String status;
  final String userId;
  final List<String> tags;

  Task({
    required this.id,
    required this.taskBy,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.status,
    required this.userId,
    required this.tags

  });

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      dueDate: (map['dueDate'] ?? '' as Timestamp).toDate(),
      status: map['status'] ?? '',
      userId: map['userId'] ?? '', taskBy: map['taskBy'] ?? '',
      tags: List<String>.from(map['tags'] ?? []), // Initialize tags from data
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate,
      'status': status,
      'userId': userId,
      'taskBy' : taskBy,
      'tags': tags, // Add tags to map
    };
  }
}
