import 'package:achieve_it/controllers/task_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FilterTasks extends StatelessWidget {
  const FilterTasks({super.key});

  @override
  Widget build(BuildContext context) {
    final taskController = Get.put(TaskController());
    final user = FirebaseAuth.instance.currentUser;
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
            children: [
              Obx(() => ChoiceChip(
                label: const Text('All Tasks'),
                selected: taskController.showAllTasks.value,
                onSelected: (selected) {
                  taskController.showAllTasks.value = true;
                },
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.circular(20),
                ),
              )),
              SizedBox(width: 8),
              Obx(() => ChoiceChip(
                label: const Text('Completed'),
                selected: !taskController.showAllTasks.value,
                onSelected: (selected) {
                  taskController.showAllTasks.value = false;
                },
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.circular(12),
                ),
              )),
            ],
          ),
          SizedBox(height:0,)
        ],
      ),
    );
  }
}
