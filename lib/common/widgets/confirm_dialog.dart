import 'package:flutter/material.dart';

Future<bool?> showConfirmationDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Confirm Completion'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Are you sure you want to mark this task as completed?',style: TextStyle(fontWeight: FontWeight.bold)),
            Text('This task can not be unmarked after clicking confirm',style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false), // User cancelled
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true), // User confirmed
            child: Text('Confirm'),
          ),
        ],
      );
    },
  );
}
