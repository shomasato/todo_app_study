import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../welcome/welcome_screen_view.dart';
import 'recover_password_view.dart';
import 'signin_screen_view_model.dart';

class SignInScreenView extends StatefulWidget {
  static String id = 'signin_screen_view';

  const SignInScreenView({Key? key}) : super(key: key);

  @override
  State<SignInScreenView> createState() => _SignInScreenViewState();
}

class _SignInScreenViewState extends State<SignInScreenView> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign In'), elevation: 0.0),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    final viewModel = Provider.of<SignInScreenViewModel>(context);
    final TextStyle? style = Theme.of(context).textTheme.titleMedium;
    final TextStyle? errorStyle = Theme.of(context)
        .textTheme
        .titleMedium
        ?.merge(const TextStyle(color: Colors.red));
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 40.0, left: 40.0, right: 40.0),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                //info
                _buildInfoText(context, errorStyle!),
                //Email
                Center(
                  child: TextFormField(
                    controller: viewModel.emailController,
                    autofocus: true,
                    textInputAction: TextInputAction.next,
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
                      errorMaxLines: 4,
                    ),
                    validator: (value) {
                      final bool result = value!.contains(RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"));
                      return result ? null : "Please enter a valid email";
                    },
                  ),
                ),
                const SizedBox(height: 8),
                //Password
                TextFormField(
                  controller: viewModel.passwordContorller,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelStyle: style,
                    errorStyle: errorStyle,
                    hintText: 'Password',
                    filled: true,
                    fillColor: Theme.of(context).cardColor,
                    isDense: true,
                    contentPadding: const EdgeInsets.all(20.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                    errorMaxLines: 4,
                  ),
                  validator: (value) {
                    final bool result = value!.isNotEmpty;
                    //final bool regExp = value.contains(RegExp(r"^[a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]"));
                    return result ? null : 'Please enter your password.';
                  },
                  onFieldSubmitted: (value) {
                    if (formKey.currentState!.validate()) {
                      viewModel.singInWithEmailAndPassword(context);
                    }
                  },
                ),
                const SizedBox(height: 20.0),
                MyButton(
                    label: 'Sign In',
                    color: Colors.blue,
                    onTap: () {
                      if (formKey.currentState!.validate()) {
                        viewModel.singInWithEmailAndPassword(context);
                      }
                    }),
                const SizedBox(height: 8),
                MyTextButton(
                    label: 'Recover Password',
                    color: Theme.of(context).cardColor,
                    onTap: () {
                      viewModel.clearRecoverController();
                      showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (context) => const RecoverPasswordView(),
                      );
                    }),
              ],
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => FocusScope.of(context).unfocus(),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoText(BuildContext context, TextStyle style) {
    return Consumer<SignInScreenViewModel>(builder: (context, model, child) {
      final String infoText = model.infoText;
      final bool isError = infoText.isEmpty;
      return Visibility(
        visible: !isError,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: Text(
            infoText,
            style: style,
          ),
        ),
      );
    });
  }
}
