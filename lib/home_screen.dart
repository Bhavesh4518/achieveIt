import 'dart:ffi';

import 'package:achieve_it/common/widgets/filterwidget.dart';
import 'package:achieve_it/common/widgets/note_widget.dart';
import 'package:achieve_it/controllers/task_controller.dart';
import 'package:achieve_it/profile_screen.dart';
import 'package:achieve_it/streams/getAllTasks.dart';
import 'package:achieve_it/webview_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'common/widgets/confirm_dialog.dart';
import 'controllers/news_controller.dart';
import 'models/task_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _launchURL(String url) {
    if (url != null) {
      Get.to(WebViewPage(url: url));
    }
  }

  void showComingSoonDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Coming Soon'),
          content: const Text('This feature is coming soon.'),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final NewsController newsController = Get.put(NewsController());
    final taskController = Get.put(TaskController());
    final userTag =
        user != null ? '#${user.displayName?.replaceAll(' ', '').trim()}' : '';

    return Scaffold(
      backgroundColor: const Color(0xFFF2F5F9),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, kToolbarHeight * 1.2, 18, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () => Get.to(() => const ProfileScreen()),
                    child: const CircleAvatar(
                      maxRadius: 32,
                      child: Icon(Icons.sailing),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Good afternoon,',
                          style: TextStyle(
                              color: Colors.blueGrey,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          user?.displayName ?? 'abc',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: const Color(0xFFF8F8F8),
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.grey,
                              spreadRadius: 1,
                              blurRadius: 1,
                              offset: Offset(0, 1))
                        ]),
                    child: const Icon(
                      Icons.message,
                      size: 18,
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: const Color(0xFFF8F8F8),
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.grey,
                              spreadRadius: 1,
                              blurRadius: 1,
                              offset: Offset(0, 1))
                        ]),
                    child: const Icon(
                      Icons.notifications,
                      size: 18,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 24,
              ),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: const Color(0xFFF8F8F8),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.shade200,
                          spreadRadius: 2,
                          blurRadius: 2,
                          offset: const Offset(0, 1))
                    ]),
                child: Row(
                  children: [
                    StreamBuilder<double>(
                      stream:
                          taskController.getCompletedTaskPercentage(userTag),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }
                        if (snapshot.hasError) {
                          return const Text('Error');
                        }

                        final completedTaskPercentage = snapshot.data ?? 0;
                        return Container(
                          height: 70,
                          width: 70,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(360),
                              color: const Color(0xFFF8F8F8),
                              boxShadow: const [
                                BoxShadow(
                                    color: Colors.grey,
                                    spreadRadius: 1,
                                    blurRadius: 1,
                                    offset: Offset(0, 1))
                              ]),
                          child: Center(
                              child: Text(
                                  '${completedTaskPercentage.toStringAsFixed(2)}')),
                        );
                      },
                    ),
                    const SizedBox(width: 12),
                    const Flexible(
                        child: Text(
                      'This is the task list that opens diialogs box showing tasks',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.blueGrey),
                    )),
                    IconButton(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return SingleChildScrollView(
                                child: Column(
                                  children: [
                                    const FilterTasks(),
                                    Obx(() => TaskStreams(
                                        stream: taskController.getTaskStream()))
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        icon: const Icon(Icons.arrow_forward_ios))
                  ],
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              const Text(
                'Explore',
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 130,
                      width: 125,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            surfaceTintColor: Colors.grey,
                            foregroundColor: Colors.indigo,
                            backgroundColor: Colors.blue.shade50,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            elevation: 2,
                          ),
                          onPressed: ()  => showComingSoonDialog(context),
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Iconsax.activity,
                                size: 44,
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text('Meetings')
                            ],
                          )
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 14,
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 127,
                      width: 125,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            surfaceTintColor: Colors.grey,
                            foregroundColor: Colors.indigo,
                            backgroundColor: Colors.blue.shade50,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            elevation: 2,
                          ),
                          onPressed: () => showComingSoonDialog(context),
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Iconsax.share,
                                size: 44,
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text('Share')
                            ],
                          )
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 14,
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 130,
                      width: 125,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            surfaceTintColor: Colors.grey,
                            foregroundColor: Colors.indigo,
                            backgroundColor: Colors.blue.shade50,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            elevation: 2,
                          ),
                          onPressed: () => Get.to(() => AddTaskPage()),
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Iconsax.task_square,
                                size: 44,
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text('Add Task')
                            ],
                          )),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 24,
              ),
              const Text(
                'Tasks',
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 16,
              ),
              const NoteWidget(),
              const SizedBox(
                height: 10,
              ),
              TaskStreams(
                  stream: taskController.getUserTasksOrAllTasks(userTag)),
              const SizedBox(
                height: 24,
              ),
              const Text(
                'Articles',
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 16,
              ),
              Obx(
                () {
                  if (newsController.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: const Color(0xFFF8F8F8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade200,
                          spreadRadius: 2,
                          blurRadius: 2,
                          offset: const Offset(0, 1),
                        )
                      ],
                    ),
                    height: 200,
                    width: MediaQuery.of(context).size.width * 0.88,
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const PageScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: newsController.articles.length,
                      itemBuilder: (context, index) {
                        final article = newsController.articles[index];
                        return SizedBox(
                          width: MediaQuery.of(context).size.width * 0.88,
                          // Set a fixed width for each ListTile
                          child: ListTile(
                              leading: article.urlToImage.isNotEmpty
                                  ? Image.network(article.urlToImage,
                                      width: 100, fit: BoxFit.cover)
                                  : null,
                              title: Text(article.title),
                              subtitle: Text(article.description),
                              onTap:
                                  () {} // => Get.to(WebViewPage(url: article.url)),
                              ),
                        );
                      },
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
