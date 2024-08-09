import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../home/home_screen_view.dart';
import '../welcome/welcome_screen_view.dart';
import 'local_notification_plugin.dart';
import 'week_model.dart';

class ViewModel extends ChangeNotifier {
  //App
  bool isFirst = true;

  //Task
  TextEditingController taskTitleController = TextEditingController();
  TextEditingController taskNoteController = TextEditingController();

  bool isMonday = false;
  bool isTuesday = false;
  bool isWednesday = false;
  bool isThursday = false;
  bool isFriday = false;
  bool isSaturday = false;
  bool isSunday = false;

  bool isInbox = false;
  bool isHide = false;
  bool isOrderIndex = false;

  bool isFabView = false;
  bool isTabIndexRow = true;

  bool isNotice = false;
  int noticeHour = 0;
  int noticeMinutes = 0;

  final Notifier notifier = Notifier();

  int today() {
    final DateTime now = DateTime.now();
    final int result = now.weekday - 1;
    return result;
  }

  void checkToday(int tabIndex) {
    if (tabIndex == today()) {
      isFabView = false;
    } else {
      isFabView = true;
      if (tabIndex < today()) {
        isTabIndexRow = true;
      } else {
        isTabIndexRow = false;
      }
    }
  }

  void initializeWeekday(int tabIndex) {
    isMonday = false;
    isTuesday = false;
    isWednesday = false;
    isThursday = false;
    isFriday = false;
    isSaturday = false;
    isSunday = false;
    initializeSetWeekday(tabIndex);
    isInbox = false;
    isNotice = false;
  }

  void initializeSetWeekday(int tabIndex) {
    if (tabIndex == 0) isMonday = true;
    if (tabIndex == 1) isTuesday = true;
    if (tabIndex == 2) isWednesday = true;
    if (tabIndex == 3) isThursday = true;
    if (tabIndex == 4) isFriday = true;
    if (tabIndex == 5) isSaturday = true;
    if (tabIndex == 6) isSunday = true;
  }

  void setWeekday(DocumentSnapshot task) {
    isMonday = task['monday'];
    isTuesday = task['tuesday'];
    isWednesday = task['wednesday'];
    isThursday = task['thursday'];
    isFriday = task['friday'];
    isSaturday = task['saturday'];
    isSunday = task['sunday'];
    isInbox = task['isInbox'];
  }

  void setNoticeSettings(DocumentSnapshot task) {
    isNotice = task['isNotice'];
    noticeHour = isNotice ? task['noticeHour'] : 0;
    noticeMinutes = isNotice ? task['noticeMinutes'] : 0;
  }

  void checkIsInbox() {
    isInbox = false;
    if (isMonday) return;
    if (isTuesday) return;
    if (isWednesday) return;
    if (isThursday) return;
    if (isFriday) return;
    if (isSaturday) return;
    if (isSunday) return;
    isInbox = true;
    notifyListeners();
  }

  void changeMonday() {
    isMonday = !isMonday;
    checkIsInbox();
    notifyListeners();
  }

  void changeTuesday() {
    isTuesday = !isTuesday;
    checkIsInbox();
    notifyListeners();
  }

  void changeWednesday() {
    isWednesday = !isWednesday;
    checkIsInbox();
    notifyListeners();
  }

  void changeThursday() {
    isThursday = !isThursday;
    checkIsInbox();
    notifyListeners();
  }

  void changeFriday() {
    isFriday = !isFriday;
    checkIsInbox();
    notifyListeners();
  }

  void changeSaturday() {
    isSaturday = !isSaturday;
    checkIsInbox();
    notifyListeners();
  }

  void changeSunday() {
    isSunday = !isSunday;
    checkIsInbox();
    notifyListeners();
  }

  void changeNoticeSetting(bool value) {
    isNotice = value;
    if (isNotice) {
      noticeHour = 12;
      noticeMinutes = 0;
    }
    notifyListeners();
  }

  void changeHideSetting(bool value) {
    isHide = value;
    notifyListeners();
  }

  void changeOrderSetting(bool value) {
    isOrderIndex = value;
    notifyListeners();
  }

  void changeNoticeHour(int value) {
    noticeHour = value;
    notifyListeners();
  }

  void changeNoticeMinutes(int value) {
    noticeMinutes = value;
    notifyListeners();
  }

  Future<void> setWeeklyNotice(String uid) async {
    notifier.cancelNotice();

    List<DocumentSnapshot> taskDocs = [];
    final FirebaseFirestore db = FirebaseFirestore.instance;
    await db
        .collection('users')
        .doc(uid)
        .collection('tasks')
        .orderBy('index')
        .get()
        .then((snapshot) => taskDocs = snapshot.docs);
    final bool isSetWeeklyNotice = taskDocs.isEmpty;
    if (isSetWeeklyNotice) return; //登録されているタスクがなければ何もしない。

    for (var taskDoc in taskDocs) {
      final DocumentSnapshot task = taskDoc;
      final bool isTaskNotice = task['isNotice'];
      if (!isTaskNotice) return; //タスクの通知設定がオフなら何もしない。

      //各変数を用意
      final int id = task.hashCode;
      final String title = task['title'];
      final int hour = task['noticeHour'];
      final int min = task['noticeMinutes'];

      //通知をスケジュール
      if (task['monday']) notifier.setWeeklyNotice(id, title, hour, min, 1);
      if (task['tuesday']) notifier.setWeeklyNotice(id, title, hour, min, 2);
      if (task['wednesday']) notifier.setWeeklyNotice(id, title, hour, min, 3);
      if (task['thursday']) notifier.setWeeklyNotice(id, title, hour, min, 4);
      if (task['friday']) notifier.setWeeklyNotice(id, title, hour, min, 5);
      if (task['saturday']) notifier.setWeeklyNotice(id, title, hour, min, 6);
      if (task['sunday']) notifier.setWeeklyNotice(id, title, hour, min, 7);
    }
  }

  bool isDone(String wid, DocumentSnapshot task) {
    if (wid == weeks[0].id) return task['isMondeyDone'];
    if (wid == weeks[1].id) return task['isTuesdayDone'];
    if (wid == weeks[2].id) return task['isWednesdayDone'];
    if (wid == weeks[3].id) return task['isThursdayDone'];
    if (wid == weeks[4].id) return task['isFridayDone'];
    if (wid == weeks[5].id) return task['isSaturdayDone'];
    if (wid == weeks[6].id) return task['isSundayDone'];
    return false;
  }

  Future<void> checkTask(
      String uid, String wid, String tid, bool isDone) async {
    if (wid == weeks[0].id) weekdayDone(uid, tid, 'isMondeyDone', isDone);
    if (wid == weeks[1].id) weekdayDone(uid, tid, 'isTuesdayDone', isDone);
    if (wid == weeks[2].id) weekdayDone(uid, tid, 'isWednesdayDone', isDone);
    if (wid == weeks[3].id) weekdayDone(uid, tid, 'isThursdayDone', isDone);
    if (wid == weeks[4].id) weekdayDone(uid, tid, 'isFridayDone', isDone);
    if (wid == weeks[5].id) weekdayDone(uid, tid, 'isSaturdayDone', isDone);
    if (wid == weeks[6].id) weekdayDone(uid, tid, 'isSundayDone', isDone);
  }

  Future<void> weekdayDone(
      String uid, String tid, String weekday, bool isDone) async {
    final FirebaseFirestore db = FirebaseFirestore.instance;
    await db
        .collection('users')
        .doc(uid)
        .collection('tasks')
        .doc(tid)
        .set({weekday: !isDone}, SetOptions(merge: true));
  }

  /////////////////////

  /////////////////////

  Future<void> addTask(String uid) async {
    final String taskTitle = taskTitleController.text;
    final String taskNote = taskNoteController.text;
    if (taskTitle.isEmpty) return;
    List<DocumentSnapshot> taskDocs = [];
    final FirebaseFirestore db = FirebaseFirestore.instance;
    await db
        .collection('users')
        .doc(uid)
        .collection('tasks')
        .orderBy('index')
        .get()
        .then((snapshot) => taskDocs = snapshot.docs);
    final int index = taskDocs.isEmpty ? 1 : taskDocs.last['index'] + 1;
    await db.collection('users').doc(uid).collection('tasks').doc().set({
      'title': taskTitle,
      'note': taskNote,
      //
      'monday': isMonday,
      'tuesday': isTuesday,
      'wednesday': isWednesday,
      'thursday': isThursday,
      'friday': isFriday,
      'saturday': isSaturday,
      'sunday': isSunday,
      //
      'isMondeyDone': false,
      'isTuesdayDone': false,
      'isWednesdayDone': false,
      'isThursdayDone': false,
      'isFridayDone': false,
      'isSaturdayDone': false,
      'isSundayDone': false,
      //
      'isInbox': isInbox,
      //
      'isNotice': isNotice,
      'noticeHour': isNotice ? noticeHour : 24,
      'noticeMinutes': isNotice ? noticeMinutes : 0,
      //
      'index': index,
    });
    setWeeklyNotice(uid);
  }

  Future<void> updateTask(String uid, String tid) async {
    final String taskTitle = taskTitleController.text;
    final String taskNote = taskNoteController.text;
    if (taskTitle.isEmpty) return;
    final FirebaseFirestore db = FirebaseFirestore.instance;
    await db.collection('users').doc(uid).collection('tasks').doc(tid).set({
      'title': taskTitle,
      'note': taskNote,
      'monday': isMonday,
      'tuesday': isTuesday,
      'wednesday': isWednesday,
      'thursday': isThursday,
      'friday': isFriday,
      'saturday': isSaturday,
      'sunday': isSunday,
      'isInbox': isInbox,
      'isNotice': isNotice,
      'noticeHour': isNotice ? noticeHour : 24,
      'noticeMinutes': isNotice ? noticeMinutes : 0,
    }, SetOptions(merge: true));
    setWeeklyNotice(uid);
  }

  Future<void> deleteTask(String uid, String tid) async {
    final FirebaseFirestore db = FirebaseFirestore.instance;
    await db.collection('users').doc(uid).collection('tasks').doc(tid).delete();
    setWeeklyNotice(uid);
  }

  void clearTaskTitleController() {
    taskTitleController.clear();
    taskNoteController.clear();
  }

  void setTaskTitleController(DocumentSnapshot task) {
    final String editTaskTitle = task['title'];
    final String editTaskNote = task['note'];
    taskTitleController.text = editTaskTitle;
    taskNoteController.text = editTaskNote;
  }

  ///

  List<DocumentSnapshot> taskDocs = [];

  ///

  Future<void> allTaskCansell(String uid) async {
    late List<DocumentSnapshot> allTasks;
    final FirebaseFirestore db = FirebaseFirestore.instance;
    await db
        .collection('users')
        .doc(uid)
        .collection('tasks')
        .orderBy('index')
        .get()
        .then((snapshot) => allTasks = snapshot.docs);
    final batch = db.batch();
    for (var document in allTasks) {
      final taskRef =
          db.collection('users').doc(uid).collection('tasks').doc(document.id);
      final taskOpts = {
        'isMondeyDone': false,
        'isTuesdayDone': false,
        'isWednesdayDone': false,
        'isThursdayDone': false,
        'isFridayDone': false,
        'isSaturdayDone': false,
        'isSundayDone': false,
      };
      batch.set(taskRef, taskOpts, SetOptions(merge: true));
    }
    await batch.commit();
  }

  Future<void> onReorderTask(int oldIndex, int newIndex, String uid) async {
    //クライアント側の処理
    if (oldIndex < newIndex) newIndex -= 1;

    final List<DocumentSnapshot> tasks = taskDocs;
    final String oldTid = tasks[oldIndex].id;
    final String newTid = tasks[newIndex].id;

    final DocumentSnapshot moveDocument = taskDocs.removeAt(oldIndex);
    taskDocs.insert(newIndex, moveDocument);

    //DBへの反映
    late List<DocumentSnapshot> allTasks;
    final FirebaseFirestore db = FirebaseFirestore.instance;
    await db
        .collection('users')
        .doc(uid)
        .collection('tasks')
        .orderBy('index')
        .get()
        .then((snapshot) => allTasks = snapshot.docs);

    final int oldTaskIndex = allTasks.indexWhere((e) => e.id == oldTid);
    final int newTaskIndex = allTasks.indexWhere((e) => e.id == newTid);

    final DocumentSnapshot moveTask = allTasks.removeAt(oldTaskIndex);
    allTasks.insert(newTaskIndex, moveTask);

    //バッチ処理
    final batch = db.batch();
    allTasks.asMap().forEach((index, document) {
      final taskRef =
          db.collection('users').doc(uid).collection('tasks').doc(document.id);
      final taskOpts = {'index': index};
      batch.set(taskRef, taskOpts, SetOptions(merge: true));
    });
    await batch.commit();
  }

  // Account
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordContorller = TextEditingController();
  String infoText = 'info';

  Future<void> signInAnonymously(BuildContext context) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    try {
      await auth.signInAnonymously().then((value) {
        if (value.user != null) {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const HomeScreenView()));
          notifier.initialize();
        }
      });
    } catch (e) {
      infoText = e.toString();
      notifyListeners();
    }
  }

  void onTapRegisterButton(context, User user) async {
    try {
      final String email = emailController.text;
      final String password = passwordContorller.text;
      final AuthCredential credential =
          EmailAuthProvider.credential(email: email, password: password);
      await user.linkWithCredential(credential);
      clearAccountController();
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HomeScreenView()),
          (route) => false);
    } catch (e) {
      infoText = e.toString();
      notifyListeners();
    }
  }

  void onTapSignInButton(context) async {
    try {
      final String email = emailController.text;
      final String password = passwordContorller.text;
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      clearAccountController();
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HomeScreenView()),
          (route) => false);
    } catch (e) {
      infoText = e.toString();
      notifyListeners();
    }
  }

  Future<void> signOut(BuildContext context) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    try {
      await auth.signOut().then((value) => Navigator.of(context)
          .pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => const WelcomeScreenView()),
              (_) => false));
    } catch (e) {
      infoText = e.toString();
      notifyListeners();
    }
  }

  void clearAccountController() {
    emailController.clear();
    passwordContorller.clear();
    infoText = 'info';
  }
}
