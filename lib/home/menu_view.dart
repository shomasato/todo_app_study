import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../commons/view_model.dart';
import '../menu_screens/all_tasks_screen_view.dart';
import '../menu_screens/inbox_screen_view.dart';
import '../menu_screens/settings_screen_view.dart';

class MenuView extends StatelessWidget {
  final String uid;

  const MenuView({Key? key, required this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ViewModel>(context);
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Order by Index'),
                Switch(
                  value: viewModel.isOrderIndex,
                  onChanged: (value) => viewModel.changeOrderSetting(value),
                ),
              ],
            ),
          ),
          const Divider(height: 1.0),
          _buildMenuItem(context, 'Account', () {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    settings: const RouteSettings(name: "/account"),
                    builder: (context) => const SettingsScreenView()),
                ModalRoute.withName('/'));
            //Navigator.pushNamedAndRemoveUntil(context, "/", (_) => false);
          }),
          const Divider(height: 1.0),
          _buildMenuItem(
            context,
            'All Tasks',
            () => Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => AllTasksScreenView(uid: uid)),
              ModalRoute.withName('/'),
            ),
          ),
          const Divider(height: 1.0),
          _buildMenuItem(
            context,
            'Inbox',
            () => Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => InboxScreenView(uid: uid)),
              ModalRoute.withName('/'),
            ),
          ),
          const Divider(height: 1.0),
          _buildMenuItem(context, 'All Done Cansell', () {
            showDialog(
                context: context,
                builder: (_) => AlertDialog(
                      title: const Text('All Done Cansell'),
                      content: const Text(
                          'Are you sure you want to refresh all tasks?'),
                      actions: <Widget>[
                        TextButton(
                          child: const Text("Cancel"),
                          onPressed: () => Navigator.pop(context),
                        ),
                        TextButton(
                            child: const Text("OK"),
                            onPressed: () {
                              viewModel.allTaskCansell(uid);
                              Navigator.pop(context);
                            }),
                      ],
                    ));
          }),
          const Divider(height: 1.0),
          _buildMenuItem(context, 'Close', () => Navigator.of(context).pop()),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
      BuildContext context, String label, VoidCallback onTap) {
    return Center(
      child: SizedBox(
        width: double.infinity,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Text(label),
          ),
        ),
      ),
    );
  }
}
