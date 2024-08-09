import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../commons/local_notification_plugin.dart';
import '../home/home_screen_view.dart';

class WelcomeScreenViewModel extends ChangeNotifier {
  int selectedPageIndex = 0;
  final Notifier notifier = Notifier();

  void onChangePageSelected(index) {
    selectedPageIndex = index;
    notifyListeners();
  }

  void showProgressDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      transitionDuration: const Duration(milliseconds: 200),
      barrierColor: Colors.black.withOpacity(0.8),
      pageBuilder: (BuildContext context, Animation animation,
              Animation secondaryAnimation) =>
          const Center(child: CircularProgressIndicator()),
    );
  }

  Future<void> signInAnonymously(BuildContext context) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    showProgressDialog(context);
    try {
      await auth.signInAnonymously().then((value) {
        if (value.user != null) {
          Navigator.pop(context);
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              settings: const RouteSettings(name: '/'),
              builder: (context) => const HomeScreenView()));
          notifier.initialize();
        }
      });
    } catch (e) {
      Navigator.of(context).pop();
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Unable to access server.'),
          content: const Text('Please try again.'),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
    }
  }
}
