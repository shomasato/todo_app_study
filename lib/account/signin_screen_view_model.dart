import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../commons/local_notification_plugin.dart';
import '../home/home_screen_view.dart';

class SignInScreenViewModel extends ChangeNotifier {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordContorller = TextEditingController();
  TextEditingController recoderPasswordContorller = TextEditingController();
  String infoText = '';
  String recoverPasswordTitle = 'Recover Password';
  String recoverPasswordError = '';
  final Notifier notifier = Notifier();
  bool isTaped = false;
  bool isSendedEmail = false;

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

  Future<void> singInWithEmailAndPassword(BuildContext context) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    showProgressDialog(context);
    try {
      final String email = emailController.text;
      final String password = passwordContorller.text;
      await auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) {
        if (value.user != null) {
          Navigator.pop(context);
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  settings: const RouteSettings(name: '/'),
                  builder: (context) => const HomeScreenView()),
              (route) => false);
          notifier.initialize();
        }
      });
      clearController();
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      infoText = e.message.toString();
      notifyListeners();
    }
  }

  void validateRocoverEmail(BuildContext context) {
    final String email = recoderPasswordContorller.text;
    final bool result = email.contains(RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"));
    if (result) {
      sendPasswordResetEmail(context, email);
      recoverPasswordError = '';
      notifyListeners();
    } else {
      recoverPasswordError = 'Please enter a valid email';
      notifyListeners();
    }
  }

  Future<void> sendPasswordResetEmail(
      BuildContext context, String email) async {
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      await auth
          .sendPasswordResetEmail(email: email)
          .then((value) => FocusScope.of(context).unfocus());
      recoverPasswordTitle = 'Password recoverly link was sent to:\n$email';
      isSendedEmail = true;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      recoverPasswordError = e.message!;
      notifyListeners();
    }
  }

  void clearController() {
    emailController.clear();
    passwordContorller.clear();
    infoText = '';
    clearRecoverController();
  }

  void clearRecoverController() {
    recoderPasswordContorller.clear();
    recoverPasswordTitle = 'Recover Password';
    recoverPasswordError = '';
    isSendedEmail = false;
  }
}
