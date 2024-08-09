import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';
import '../commons/view_model.dart';

class ReminderView extends StatelessWidget {
  final String uid;

  const ReminderView({Key? key, required this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ViewModel>(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildToggleSwitch(context),
            const SizedBox(height: 20.0),
            Visibility(
                visible: viewModel.isNotice, child: _buildTimePickers(context)),
            const SizedBox(height: 40.0),
            _buildButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleSwitch(BuildContext context) {
    final viewModel = Provider.of<ViewModel>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Reminder'),
        Switch(
            value: viewModel.isNotice,
            onChanged: (value) => viewModel.changeNoticeSetting(value)),
      ],
    );
  }

  Widget _buildTimePickers(BuildContext context) {
    final viewModel = Provider.of<ViewModel>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        NumberPicker(
          value: viewModel.noticeHour,
          minValue: 0,
          maxValue: 23,
          step: 1,
          haptics: true,
          onChanged: (value) => viewModel.changeNoticeHour(value),
        ),
        const Text(':'),
        NumberPicker(
          value: viewModel.noticeMinutes,
          minValue: 0,
          maxValue: 59,
          step: 1,
          haptics: true,
          zeroPad: true,
          onChanged: (value) => viewModel.changeNoticeMinutes(value),
        ),
      ],
    );
  }

  Widget _buildButton(BuildContext context) {
    return ElevatedButton(
        onPressed: () => Navigator.of(context).pop(),
        child: const SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Center(child: Text('Done')),
          ),
        ));
  }
}
