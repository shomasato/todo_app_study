import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../commons/view_model.dart';
import '../set_task/set_task_screen_view.dart';

class TaskListView extends StatelessWidget {
  final String uid;
  final String wid;

  const TaskListView({Key? key, required this.uid, required this.wid})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ViewModel>(context);
    final FirebaseFirestore db = FirebaseFirestore.instance;
    final timeDocRef = db
        .collection('users')
        .doc(uid)
        .collection('tasks')
        .where(wid, isEqualTo: true)
        .orderBy('noticeHour')
        .orderBy('noticeMinutes')
        .orderBy('index')
        .snapshots();

    final indexDocRef = db
        .collection('users')
        .doc(uid)
        .collection('tasks')
        .where(wid, isEqualTo: true)
        .orderBy('index')
        .snapshots();

    final TextStyle? defaultStyle = Theme.of(context).textTheme.titleMedium;

    return StreamBuilder<QuerySnapshot>(
      stream: viewModel.isOrderIndex ? indexDocRef : timeDocRef,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: Text('Now loading ...'));
        } else {
          final List<DocumentSnapshot> tasks = snapshot.data!.docs;
          viewModel.taskDocs = tasks;
          if (viewModel.taskDocs.isEmpty) {
            return const Center(child: Text('None Tasks'));
          } else {
            return ReorderableListView.builder(
              itemCount: viewModel.taskDocs.length,
              onReorder: (oldIndex, newIndex) {
                viewModel.onReorderTask(oldIndex, newIndex, uid);
                final SnackBar snackBar = SnackBar(
                  backgroundColor: Theme.of(context).cardColor,
                  content: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      'Since "time" is set in the sort order, time is given priority in the display. To change this, go to the menu and change the task order setting.',
                      style: defaultStyle,
                    ),
                  ),
                  duration: const Duration(seconds: 3),
                  action: SnackBarAction(
                    label: 'OK',
                    onPressed: () {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    },
                  ),
                );
                if(!viewModel.isOrderIndex){
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              },
              itemBuilder: (context, index) {
                final DocumentSnapshot task = viewModel.taskDocs[index];
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
    final String tid = task.id;
    final String title = task['title'];
    final int hour = task['noticeHour'];
    final int min = task['noticeMinutes'];
    final String viewMin = min.toString().padLeft(2, '0');
    final bool isNotice = task['isNotice'];
    final bool isDone = viewModel.isDone(wid, task);
    final TextStyle? defaultStyle = Theme.of(context).textTheme.titleMedium;
    final TextStyle? checkedStyle = Theme.of(context)
        .textTheme
        .titleMedium
        ?.merge(const TextStyle(decoration: TextDecoration.lineThrough));

    return AnimatedSize(
      duration: const Duration(milliseconds: 200),
      child: Container(
        child: !(isDone && viewModel.isHide)
            ? Column(
                key: Key(tid),
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          Future.delayed(
                            const Duration(seconds: 0),
                            () =>
                                viewModel.checkTask(uid, wid, task.id, isDone),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Opacity(
                              opacity: isDone ? 1.0 : 0.3,
                              child: Icon(isDone
                                  ? Icons.check_circle
                                  : Icons.circle_outlined)),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 32.0, bottom: 32.0, right: 32.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Opacity(
                                      opacity: isDone ? 0.6 : 1.0,
                                      child: Text(title,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: isDone
                                              ? checkedStyle
                                              : defaultStyle)),
                                ),
                                //領域をなくす場合はVisibility、なくさない場合はOpacityを使う
                                /*
                                Visibility(
                                  visible: isNotice,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 20.0),
                                    child: Opacity(
                                        opacity: 0.6,
                                        child: Text('$hour:$viewMin',
                                            style: defaultStyle)),
                                  ),
                                ),
                                 */
                                Opacity(
                                  opacity: isNotice ? 0.6 : 0.0,
                                  child: Padding(
                                      padding:
                                          const EdgeInsets.only(left: 20.0),
                                      child: Text('$hour:$viewMin',
                                          style: defaultStyle)),
                                ),
                              ],
                            ),
                          ),
                          onTap: () {
                            viewModel.setTaskTitleController(task);
                            viewModel.setWeekday(task);
                            viewModel.setNoticeSettings(task);
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    SetTaskScreen(uid: uid, editTask: task)));
                          },
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 1.0),
                ],
              )
            : null,
      ),
    );
  }
}
