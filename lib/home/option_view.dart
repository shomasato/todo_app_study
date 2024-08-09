import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../commons/view_model.dart';

class OptionView extends StatelessWidget {
  const OptionView({Key? key}) : super(key: key);

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
                const Text('Hide Completed Taks'),
                Switch(
                  value: viewModel.isHide,
                  onChanged: (value) => viewModel.changeHideSetting(value),
                ),
              ],
            ),
          ),
          const Divider(height: 1.0),
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
          _buildMenuItem(context, 'Close', () {
            Navigator.of(context).pop();
          }),
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
