import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../commons/view_model.dart';

class SignInScreenView extends StatelessWidget {
  const SignInScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SignIn')),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(context) {
    final viewModel = Provider.of<ViewModel>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 40),
          TextFormField(
            controller: viewModel.emailController,
            decoration: const InputDecoration(hintText: "Email"),
          ),
          const SizedBox(height: 40),
          TextFormField(
              controller: viewModel.passwordContorller,
              decoration: const InputDecoration(hintText: "Password")),
          const SizedBox(height: 40),
          Container(
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(12)),
              child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => viewModel.onTapSignInButton(context),
                  child: const Padding(
                      padding: EdgeInsets.all(32.0),
                      child: Center(
                          child: Text('SignIn',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 16)))))),
          const SizedBox(height: 40),
          Center(child: Text(viewModel.infoText)),
        ],
      ),
    );
  }
}
