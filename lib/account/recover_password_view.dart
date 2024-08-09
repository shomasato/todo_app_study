import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timer_app_08/welcome/welcome_screen_view.dart';

import 'signin_screen_view_model.dart';

class RecoverPasswordView extends StatelessWidget {
  const RecoverPasswordView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextStyle? style = Theme.of(context).textTheme.titleMedium;
    final TextStyle? errorStyle = Theme.of(context)
        .textTheme
        .titleMedium
        ?.merge(const TextStyle(color: Colors.red));
    return Consumer<SignInScreenViewModel>(builder: (context, model, child) {
      final bool isError = model.recoverPasswordError.isNotEmpty;
      return Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(model.recoverPasswordTitle,
                    style: style, textAlign: TextAlign.center),
                const SizedBox(height: 20.0),
                model.isSendedEmail
                    ? MyButton(
                        label: 'OK',
                        color: Colors.blue,
                        onTap: () => Navigator.pop(context),
                      )
                    : TextField(
                        autofocus: true,
                        controller: model.recoderPasswordContorller,
                        textInputAction: TextInputAction.send,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelStyle: style,
                          errorStyle: errorStyle,
                          hintText: 'Email',
                          filled: true,
                          fillColor: Theme.of(context).cardColor,
                          isDense: true,
                          contentPadding: const EdgeInsets.all(20.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide.none,
                          ),
                          errorText:
                              isError ? model.recoverPasswordError : null,
                          errorMaxLines: 4,
                        ),
                        onEditingComplete: () =>
                            model.validateRocoverEmail(context),
                      ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
