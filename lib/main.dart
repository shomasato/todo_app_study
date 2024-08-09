import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:provider/provider.dart';
import 'package:timer_app_08/welcome/welcome_screen_view_model.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'account/signin_screen_view.dart';
import 'account/signin_screen_view_model.dart';
import 'commons/firebase_options.dart';
import 'commons/view_model.dart';
import 'home/home_screen_view.dart';
import 'menu_screens/all_tasks_screen_view.dart';
import 'menu_screens/inbox_screen_view.dart';
import 'menu_screens/settings_screen_view.dart';
import 'set_task/set_task_screen_view.dart';
import 'welcome/welcome_screen_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //タイムゾーンを端末に合わせる
  await configureLocalTimeZone();
  //Firebaseを初期化する
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  //再インストール時にサインアウトする
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.getBool('first_launch') ?? true) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();
    prefs.setBool('first_launch', false);
  }
  runApp(const MyApp());
}

Future<void> configureLocalTimeZone() async {
  tz.initializeTimeZones();
  final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timeZoneName));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ViewModel>(create: (context) => ViewModel()),
        ChangeNotifierProvider<WelcomeScreenViewModel>(
            create: (context) => WelcomeScreenViewModel()),
        ChangeNotifierProvider<SignInScreenViewModel>(
            create: (context) => SignInScreenViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        home: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return const HomeScreenView();
              } else {
                return const WelcomeScreenView();
              }
            }),
        routes: {
          WelcomeScreenView.id: (_) => const WelcomeScreenView(),
          HomeScreenView.id: (_) => const HomeScreenView(),
          SetTaskScreen.id: (_) => const SetTaskScreen(),
          AllTasksScreenView.id: (_) => const AllTasksScreenView(),
          InboxScreenView.id: (_) => const InboxScreenView(),
          SettingsScreenView.id: (_) => const SettingsScreenView(),
          SignInScreenView.id: (_) => const SignInScreenView(),
        },
      ),
    );
  }
}
