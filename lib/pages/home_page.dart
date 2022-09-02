import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mantime/controllers/task_controller.dart';
import 'package:mantime/pages/add_task_page.dart';
import 'package:mantime/pages/data_report_page.dart';
import 'package:mantime/pages/pomodoro_page.dart';
import 'package:mantime/pages/profile_page.dart';
import 'package:mantime/pages/tasks_page.dart';
import 'package:mantime/services/notification_services.dart';
import 'package:mantime/services/theme_services.dart';
import 'package:mantime/theme/theme.dart';

class HomePage extends StatefulWidget {
  static const homePage = 'HomePage';
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _bottomNavIndex = 0;
  bool isDark = GetStorage().read('isDarkMode') ?? false;
  final PageController _pageController = PageController(initialPage: 0);
  final _taskController = Get.put(TaskController());
  List<IconData> iconList = [
    Icons.home,
    Icons.access_time_filled,
    Icons.bar_chart,
    Icons.person
  ];
  late NotificationHelper notificationHelper;

  @override
  void initState() {
    notificationHelper = NotificationHelper();
    notificationHelper.initializeNotification();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: isDark ? null : Colors.white,
          gradient: isDark
              ? const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                      Color.fromARGB(255, 67, 70, 76),
                      Color.fromARGB(255, 34, 36, 39)
                    ])
              : null),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          actions: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 25, 5, 0),
              child: InkWell(
                borderRadius: BorderRadius.circular(30),
                onTap: () {
                  setState(() {
                    ThemeService().switchTheme();
                    isDark = GetStorage().read('isDarkMode');
                    _bottomNavIndex = _bottomNavIndex;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Icon(
                    isDark ? Icons.dark_mode : Icons.light_mode,
                    size: 30,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
              ),
            )
          ],
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            onPressed: () async {
              await Navigator.pushNamed(context, AddTaskPage.addTaskPage);
              _taskController.getTasks();
            },
            backgroundColor:
                const Color.fromARGB(255, 80, 67, 225), //RGB(80, 67, 225)
            child: const Icon(
              Icons.add,
              size: 30,
              color: Colors.white,
            )),
        bottomNavigationBar: AnimatedBottomNavigationBar(
          shadow: const Shadow(
            blurRadius: 10.0,
            color: Color.fromARGB(255, 67, 70, 76),
          ),
          inactiveColor: const Color.fromARGB(255, 90, 95, 98),
          activeColor: primaryColor,
          height: 60,
          iconSize: 30.0,
          blurEffect: true,
          leftCornerRadius: 32,
          rightCornerRadius: 32,
          backgroundColor:
              isDark ? const Color.fromARGB(255, 39, 41, 45) : Colors.white,
          icons: iconList,
          activeIndex: _bottomNavIndex,
          gapLocation: GapLocation.center,
          notchSmoothness: NotchSmoothness.softEdge,
          onTap: (index) {
            setState(() {
              _bottomNavIndex = index;
              _pageController.animateToPage(index,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.ease);
            });
            debugPrint('$_bottomNavIndex');
          },
          //other params
        ),
        body: PageView(
          controller: _pageController,
          children: [
            TasksPage(
              taskController: _taskController,
            ),
            const PomodoroPage(),
            DataReportPage(taskController: _taskController),
            const ProfilePage()
          ],
          onPageChanged: (newValue) {
            setState(() {
              _bottomNavIndex = newValue;
            });
          },
        ),
      ),
    );
  }
}
