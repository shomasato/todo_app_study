import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../commons/view_model.dart';

class SettingsScreenView extends StatelessWidget {
  static String id = 'settings_screen_view';

  const SettingsScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ViewModel>(context);
    return Scaffold(
      appBar: AppBar(elevation: 0.0, title: const Text('Settings')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => viewModel.signOut(context),
          child: const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text('Sign Out'),
          ),
        ),
      ),
    );
  }
}
