import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timer_app_08/set_task/note_view.dart';
import '../commons/view_model.dart';
import 'reminder_view.dart';

class SetTaskScreen extends StatelessWidget {
  static String id = 'set_timer_screen_view';
  final String uid;
  final DocumentSnapshot? editTask;

  const SetTaskScreen({Key? key, this.uid = '', this.editTask})
      : super(key: key);

  bool _isEdit() => editTask != null;

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ViewModel>(context);
    return GestureDetector(
      /*
      //タップでキーボードを閉じる
      onTap: () {
        final FocusScopeNode currentScope = FocusScope.of(context);
        if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      }
      */
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          actions: [
            if (_isEdit())
              IconButton(
                  onPressed: () => showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text('Delete Task'),
                          content: const Text(
                              'Are you sure you want to refresh all tasks?'),
                          actions: <Widget>[
                            TextButton(
                              child: const Text("Cancel"),
                              onPressed: () => Navigator.pop(context),
                            ),
                            TextButton(
                                child: const Text("Delete"),
                                onPressed: () {
                                  viewModel.deleteTask(uid, editTask!.id);
                                  Navigator.of(context)
                                      .popUntil((route) => route.isFirst);
                                }),
                          ],
                        ),
                      ),
                  icon: const Icon(Icons.delete_outline)),
          ],
        ),
        body: _buildBody(context),
        resizeToAvoidBottomInset: false,
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final viewModel = Provider.of<ViewModel>(context);
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: ListView(
        children: [
          const SizedBox(height: 20.0),
          _buildTitle(context),
          const SizedBox(height: 20.0),
          _buildWeekdayPickers(context),
          const SizedBox(height: 20.0),
          Visibility(
            visible: viewModel.isInbox,
            child: const Text(
                'If no day of the week is selected, it will be saved in Inbox.'),
          ),
          _buildReminder(context, () {
            showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    builder: (context) => ReminderView(uid: uid))
                .whenComplete(() =>
                    _isEdit() ? viewModel.updateTask(uid, editTask!.id) : null);
          }),
          const SizedBox(height: 8.0),
          _buildMemo2(context),
          const SizedBox(height: 8.0),
          _buildMemo(context, () {}),
        ],
      ),
    );
  }

  Widget _buildMemo2(BuildContext context) {
    return Container(
      color: Theme.of(context).cardColor,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (context) => const NoteView()),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Add Note'),
              Icon(Icons.add),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMemo(BuildContext context, VoidCallback onTap) {
    final TextStyle? style = Theme.of(context).textTheme.bodyMedium;
    return Container(
      color: Theme.of(context).cardColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
        child: TextField(
          style: style,
          maxLines: null,
          decoration: const InputDecoration(
            hintText: 'Task Name',
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    final viewModel = Provider.of<ViewModel>(context);
    final TextStyle? style = Theme.of(context).textTheme.headlineSmall;
    return TextField(
        style: style,
        maxLines: null,
        textInputAction: TextInputAction.done,
        controller: viewModel.taskTitleController,
        autofocus: _isEdit() ? false : true,
        decoration: const InputDecoration(
          hintText: 'Task Name',
          border: InputBorder.none,
        ),
        onSubmitted: (value) {
          //_isEdit() ? viewModel.updateTask(uid, editTask!.id) : addTask();
          if (_isEdit()) {
            viewModel.updateTask(uid, editTask!.id);
          } else {
            viewModel.addTask(uid);
            Navigator.pop(context);
          }
        });
  }

  /*
  Widget _buildNote(BuildContext context) {
    final viewModel = Provider.of<ViewModel>(context);
    final TextStyle? style = Theme.of(context).textTheme.titleMedium;
    return TextField(
      style: style,
      controller: viewModel.taskNoteController,
      maxLines: null,
      decoration: const InputDecoration(
        hintText: '+ Add Note',
        border: InputBorder.none,
      ),
      //onChanged: (value) {},
    );
  }
  */

  Widget _buildReminder(BuildContext context, VoidCallback onTap) {
    final viewModel = Provider.of<ViewModel>(context);
    String hour = viewModel.noticeHour.toString();
    String minutes = viewModel.noticeMinutes.toString().padLeft(2, '0');
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 0.0,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Reminder'),
              Text(viewModel.isNotice ? '$hour:$minutes' : 'なし'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeekdayPickers(BuildContext context) {
    final viewModel = Provider.of<ViewModel>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildWeekdayPicker(context, 'Mo', viewModel.isMonday, () {
          viewModel.changeMonday();
          _isEdit() ? viewModel.updateTask(uid, editTask!.id) : null;
        }),
        _buildWeekdayPicker(context, 'Tu', viewModel.isTuesday, () {
          viewModel.changeTuesday();
          _isEdit() ? viewModel.updateTask(uid, editTask!.id) : null;
        }),
        _buildWeekdayPicker(context, 'We', viewModel.isWednesday, () {
          viewModel.changeWednesday();
          _isEdit() ? viewModel.updateTask(uid, editTask!.id) : null;
        }),
        _buildWeekdayPicker(context, 'Th', viewModel.isThursday, () {
          viewModel.changeThursday();
          _isEdit() ? viewModel.updateTask(uid, editTask!.id) : null;
        }),
        _buildWeekdayPicker(context, 'Fr', viewModel.isFriday, () {
          viewModel.changeFriday();
          _isEdit() ? viewModel.updateTask(uid, editTask!.id) : null;
        }),
        _buildWeekdayPicker(context, 'Sa', viewModel.isSaturday, () {
          viewModel.changeSaturday();
          _isEdit() ? viewModel.updateTask(uid, editTask!.id) : null;
        }),
        _buildWeekdayPicker(context, 'Sn', viewModel.isSunday, () {
          viewModel.changeSunday();
          _isEdit() ? viewModel.updateTask(uid, editTask!.id) : null;
        }),
      ],
    );
  }

  Widget _buildWeekdayPicker(
      BuildContext context, String label, bool isChecked, VoidCallback onTap) {
    const TextStyle defaultStyle = TextStyle(fontWeight: FontWeight.normal);
    const TextStyle checkedStyle = TextStyle(fontWeight: FontWeight.bold);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).dividerColor),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Opacity(
            opacity: isChecked ? 1.0 : 0.3,
            child: Text(label, style: isChecked ? checkedStyle : defaultStyle)),
      ),
    );
  }
}
