import 'package:flutter/material.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:provider/provider.dart';
import '../account/signin_screen_view.dart';
import '../account/signin_screen_view_model.dart';
import 'welcome_screen_view_model.dart';

class WelcomeScreenView extends StatelessWidget {
  const WelcomeScreenView({Key? key}) : super(key: key);
  static String id = 'welcome_screen_view';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(context),
      bottomNavigationBar: _buildBottomNaviBar(context),
      resizeToAvoidBottomInset: false,
    );
  }

  Widget _buildBody(BuildContext context) {
    final viewModel = Provider.of<WelcomeScreenViewModel>(context);
    final pageController = PageController(initialPage: 0);
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ExpandablePageView(
            controller: pageController,
            onPageChanged: (index) => viewModel.onChangePageSelected(index),
            children: [
              _buildPageView(context,
                  'RenderPointerListener was given an infinite size during layout.'),
              _buildPageView(context,
                  'Im trying to create a carousel with items of variable heights.'),
              _buildPageView(context,
                  'When using PageView or ListView with horizontal scrolling.'),
            ],
          ),
          _buildDotIndicator(context),
        ],
      ),
    );
  }

  Widget _buildPageView(BuildContext context, String message) {
    TextStyle? style = Theme.of(context).textTheme.titleMedium;
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 215.0,
          height: 200.0,
          color: Theme.of(context).cardColor,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 80.0),
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: style,
          ),
        ),
      ],
    );
  }

  Widget _buildDotIndicator(BuildContext context) {
    return Consumer<WelcomeScreenViewModel>(builder: (context, model, child) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 4,
            backgroundColor: (model.selectedPageIndex == 0)
                ? Colors.blue
                : Theme.of(context).cardColor,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: CircleAvatar(
              radius: 4,
              backgroundColor: (model.selectedPageIndex == 1)
                  ? Colors.blue
                  : Theme.of(context).cardColor,
            ),
          ),
          CircleAvatar(
            radius: 4,
            backgroundColor: (model.selectedPageIndex == 2)
                ? Colors.blue
                : Theme.of(context).cardColor,
          ),
        ],
      );
    });
  }

  Widget _buildBottomNaviBar(BuildContext context) {
    final viewModel = Provider.of<SignInScreenViewModel>(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MyButton(
              label: 'Get Started',
              color: Colors.blue,
              onTap: () {
                viewModel.signInAnonymously(context);
              },
            ),
            const SizedBox(height: 8.0),
            MyButton(
              label: 'Sign In',
              color: Theme.of(context).cardColor,
              onTap: () {
                viewModel.clearController();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const SignInScreenView(),
                  ),
                );
              },
            ),
            const SizedBox(height: 40.0),
          ],
        ),
      ),
    );
  }
}

class MyButton extends StatefulWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;

  const MyButton(
      {Key? key, required this.label, required this.color, required this.onTap})
      : super(key: key);

  @override
  State<MyButton> createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  bool isTaped = false;

  @override
  Widget build(BuildContext context) {
    TextStyle? style = Theme.of(context).textTheme.titleMedium;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isTaped ? widget.color.withOpacity(0.6) : widget.color,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (e) => setState(() => isTaped = true),
        onTapCancel: () => setState(() => isTaped = false),
        onTapUp: (e) => setState(() => isTaped = false),
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Center(child: Text(widget.label, style: style)),
        ),
      ),
    );
  }
}

class MyTextButton extends StatefulWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;

  const MyTextButton(
      {Key? key, required this.label, required this.color, required this.onTap})
      : super(key: key);

  @override
  State<MyTextButton> createState() => _MyTextButton();
}

class _MyTextButton extends State<MyTextButton> {
  bool isTaped = false;

  @override
  Widget build(BuildContext context) {
    TextStyle? style = Theme.of(context).textTheme.titleMedium;
    return SizedBox(
      width: double.infinity,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (e) => setState(() => isTaped = true),
        onTapCancel: () => setState(() => isTaped = false),
        onTapUp: (e) => setState(() => isTaped = false),
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Center(
            child: Opacity(
              opacity: isTaped ? 0.5 : 0.85,
              child: Text(
                widget.label,
                style: style,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
