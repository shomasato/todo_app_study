import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../commons/view_model.dart';
import '../set_task/set_task_screen_view.dart';

class InboxScreenView extends StatelessWidget {
  static String id = 'inbox_screen_view';
  final String uid;

  const InboxScreenView({Key? key, this.uid = ''}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0.0, title: const Text('Inbox')),
      body: _builTaskList(context),
    );
  }

  Widget _builTaskList(BuildContext context) {
    final FirebaseFirestore db = FirebaseFirestore.instance;
    return StreamBuilder<QuerySnapshot>(
      stream: db
          .collection('users')
          .doc(uid)
          .collection('tasks')
          .where('isInbox', isEqualTo: true)
          .snapshots(),
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
                  child: _buildItem(context, task),
                );
              },
            );
          }
        }
      },
    );
  }

  Widget _buildItem(BuildContext context, DocumentSnapshot task) {
    final viewModel = Provider.of<ViewModel>(context);
    final String title = task['title'];
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Text(title),
      ),
      onTap: () {
        viewModel.setTaskTitleController(task);
        viewModel.setWeekday(task);
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => SetTaskScreen(uid: uid, editTask: task)));
      },
    );
  }
}
