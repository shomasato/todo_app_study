import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../commons/view_model.dart';
import '../commons/week_model.dart';
import '../set_task/set_task_screen_view.dart';
import 'menu_view.dart';
import 'task_list_view.dart';

class HomeScreenView extends StatefulWidget {
  static String id = 'home_screen_view';

  const HomeScreenView({Key? key}) : super(key: key);

  @override
  State<HomeScreenView> createState() => _HomeScreenViewState();
}

class _HomeScreenViewState extends State<HomeScreenView>
    with TickerProviderStateMixin {
  User? user = FirebaseAuth.instance.currentUser;

  get uid => user!.uid.toString();

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: weeks.length, vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final viewModel = Provider.of<ViewModel>(context);
    final int today = viewModel.today();
    if (viewModel.isFirst) {
      _tabController.animateTo(today, duration: const Duration(seconds: 0));
      viewModel.isFirst = false;
    }
    _tabController.addListener(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final int tabIndex = _tabController.index;
        viewModel.checkToday(tabIndex);
        setState(() {});
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ViewModel>(builder: (context, model, child) {
      return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          //title: const Text('Weekstep'),
          bottom: TabBar(
            controller: _tabController,
            tabs: weeks.map((Week week) {
              return Tab(
                text: week.title,
              );
            }).toList(),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: weeks.map((Week week) {
            return TaskListView(uid: uid, wid: week.id);
          }).toList(),
        ),
        floatingActionButton: _buildFloatingActionButton(context),
        bottomNavigationBar: _buildBottomNaviBar(context),
        resizeToAvoidBottomInset: false,
      );
    });
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    final viewModel = Provider.of<ViewModel>(context);
    return Visibility(
      visible: viewModel.isFabView,
      child: FloatingActionButton(
        elevation: 0.0,
        onPressed: () => _tabController.animateTo(viewModel.today()),
        child: Icon(viewModel.isTabIndexRow
            ? Icons.arrow_forward_ios_sharp
            : Icons.arrow_back_ios_sharp),
      ),
    );
  }

  Widget _buildBottomNaviBar(BuildContext context) {
    final viewModel = Provider.of<ViewModel>(context);
    final int tabIndex = _tabController.index;
    return Container(
      color: Theme.of(context).cardColor,
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildBottomNaviItem(
              context,
              () {
                viewModel.changeHideSetting(!viewModel.isHide);
              },
              viewModel.isHide
                  ? Icons.hide_source_outlined
                  : Icons.circle_outlined,
            ),
            Expanded(
                child: _buildBottomNaviItem(context, () {
              viewModel.clearTaskTitleController();
              viewModel.initializeWeekday(tabIndex);
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SetTaskScreen(uid: uid)));
            }, Icons.add)),
            _buildBottomNaviItem(context, () {
              showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (context) => MenuView(uid: uid));
            }, Icons.menu),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNaviItem(
      BuildContext context, VoidCallback onTap, IconData icon) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 32.0),
        child: Icon(icon),
      ),
    );
  }


}
