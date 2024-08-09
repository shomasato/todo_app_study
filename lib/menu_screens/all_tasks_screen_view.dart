import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AllTasksScreenView extends StatelessWidget {
  static String id = 'all_tasks_screen_view';
  final String uid;

  const AllTasksScreenView({Key? key, this.uid = ''}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0.0, title: const Text('All Tasks')),
      body: _builTaskList(context),
    );
  }

  Widget _builTaskList(BuildContext context) {
    final FirebaseFirestore db = FirebaseFirestore.instance;
    return StreamBuilder<QuerySnapshot>(
      stream: db.collection('users').doc(uid).collection('tasks').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: Text('Now loading ...'));
        } else {
          List<DocumentSnapshot> tasks = snapshot.data!.docs;
          if (tasks.isEmpty) {
            return const Center(child: Text('None Tasks'));
          } else {
            return ReorderableListView.builder(
              itemCount: tasks.length,
              onReorder: (oldIndex, newIndex) {},
              itemBuilder: (context, index) {
                final DocumentSnapshot task = tasks[index];
                final String tid = task.id;
                return Card(
                  key: Key(tid),
                  elevation: 0.0,
                  margin: EdgeInsets.zero,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(task['title']),
                  ),
                );
              },
            );
          }
        }
      },
    );
  }
}
