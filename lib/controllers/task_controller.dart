import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart' as Rxdart;

import '../models/task_model.dart';

class TaskController extends GetxController {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController tagsController = TextEditingController(); // Add tags controller
  late Rx<DateTime> dueDate;
  final user = FirebaseAuth.instance.currentUser;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  var showAllTasks = true.obs;
  var showUserTasks = true.obs;

  @override
  void onInit() {
    super.onInit();
    dueDate = DateTime.now().obs;
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    super.onClose();
  }

  void selectDueDate() async {
    final pickedDate = await showDatePicker(
      context: Get.overlayContext!,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      dueDate.value = pickedDate;
    }
  }
  void updateTaskStatus(String taskId, String status) {
    FirebaseFirestore.instance.collection('Tasks').doc(taskId).update({
      'status': status,
    });
  }



  Future<void> saveTask() async {
    final newTask = Task(
      id: DateTime.now().toString(),
      title: titleController.text,
      description: descriptionController.text,
      dueDate: dueDate.value,
      status: 'pending',
      userId: user?.uid ?? '#212023',
      taskBy: user?.displayName.toString() ?? 'Unknown',
      tags: tagsController.text.split(',').map((tag) => tag.trim())
          .where((tag) => tag.startsWith('#')).toList(),   // Splitting with comma
    );
    try {
      await FirebaseFirestore.instance
          .collection('Tasks')
          .doc(newTask.id)
          .set(newTask.toMap());
      Get.back(result: true); // Navigate back on successful save
    } catch (e) {
      print("Error saving task: $e");
      // Handle error, show error message, etc.
    }
  }
  Stream<List<Task>> getUserTasks(String userTag) {
    return FirebaseFirestore.instance
        .collection('Tasks')
        .where('tags', arrayContains : userTag)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => Task.fromMap(doc.data() as Map<String, dynamic>))
        .toList());
  }
  Stream<List<Task>> getAllTasks() {
    return FirebaseFirestore.instance
        .collection('Tasks')
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => Task.fromMap(doc.data() as Map<String, dynamic>))
        .toList());
  }
  Stream<List<Task>> getUserTasksOrAllTasks(String userTag) {
    return getUserTasks(userTag).switchMap((userTasks) {
      if (userTasks.isEmpty) {
        return getAllTasks();
      } else {
        return Stream.value(userTasks);
      }
    });
  }
  Stream<List<Task>> getCompletedTasks() {
    return FirebaseFirestore.instance
        .collection('Tasks')
        .where('status', isEqualTo: 'completed')
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => Task.fromMap(doc.data() as Map<String, dynamic>))
        .toList());
  }
  Stream<int> getCompletedTaskCount(String userTag) {
    final user = auth.currentUser;
    return firestore.collection('Tasks')
        .where('tags', arrayContains: userTag)
        .where('status', isEqualTo: 'completed')
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }
  Stream<double> getCompletedTaskPercentage(String userTag) {
    final user = auth.currentUser;

    final userTasksStream = firestore.collection('Tasks')
        .where('tags', arrayContains: userTag)
        .snapshots();

    return userTasksStream.map((snapshot) {
      final totalTasks = snapshot.docs.length;
      final completedTasks = snapshot.docs.where((doc) => doc.data()['status'] == 'completed').length;
      if (totalTasks == 0) return 0.0;
      return (completedTasks / totalTasks) * 100;
    });
  }

  Stream<List<Task>> getTaskStream() {
    return showAllTasks.value ? getAllTasks() : getCompletedTasks();
  }

}



class AddTaskPage extends StatelessWidget {
  final TaskController taskController = Get.put(TaskController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F5F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF2F5F9),
        title: Text("Add Task",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 21),),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: taskController.titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: taskController.descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              TextField(
                controller: taskController.tagsController,
                decoration: InputDecoration(labelText: 'Tags (comma separated, each starting with #)'),
              ),
              ListTile(
                title: Text('Due Date'),
                subtitle: Obx(() => Text('${taskController.dueDate.value.year}-${taskController.dueDate.value.month}-${taskController.dueDate.value.day}')),
                onTap: () {
                  taskController.selectDueDate();
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  taskController.saveTask();
                },
                child: Text('Save'),
              ),
          SizedBox(height: 20,),
          Text('Tags',style: TextStyle(fontWeight: FontWeight.bold),),
          SizedBox(height: 8,),
          Text('It display all users of this app , you can tag below names by adding # at the start of name and It should match exactly as below names',
          style: TextStyle(color: Colors.grey, fontSize: 14,),),
              SizedBox(height: 20,),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('Users').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
        
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(child: Text('No users logged in with Google.'));
              }
        
              final users = snapshot.data!.docs;
        
              return ListView.separated(
                shrinkWrap: true,
                itemCount: users.length,
                physics: const NeverScrollableScrollPhysics(),
                separatorBuilder: (_ , __ ) => SizedBox(height: 12,),
                itemBuilder: (context, index) {
                  final user = users[index].data() as Map<String, dynamic>;
                  return Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.purple.shade50
                    ),
                    child:  Text(user['name'].toString().replaceAll( ' ', '') ?? 'No Name'),
                    
                  );
                },
              );
            },
          ),
            ],
          ),
        ),
      ),
    );
  }
}