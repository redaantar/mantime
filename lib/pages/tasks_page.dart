import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mantime/controllers/task_controller.dart';
import 'package:mantime/models/task_model.dart';
import 'package:mantime/services/notification_services.dart';
import 'package:mantime/theme/theme.dart';
import 'package:mantime/widgets/task_tile.dart';

// ignore: must_be_immutable
class TasksPage extends StatefulWidget {
  TaskController taskController;
  TasksPage({Key? key, required this.taskController}) : super(key: key);

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage>
    with AutomaticKeepAliveClientMixin<TasksPage> {
  DateTime _selectedDate = DateTime.now();
  NotificationHelper notifyHelper = NotificationHelper();

  @override
  void initState() {
    super.initState();
    debugPrint('initstate');
    widget.taskController.getTasks();
    widget.taskController.getCompletedTasks();
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Home',
                    style: headingTextStyle,
                  ),
                  Text(
                    DateFormat.yMMMMd().format(DateTime.now()),
                    style: subHeadingTextStyle,
                  )
                ],
              )
            ],
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.only(left: 15, bottom: 5),
          child: DatePicker(
            DateTime.now(),
            height: 90,
            width: 70,
            initialSelectedDate: DateTime.now(),
            selectionColor: primaryColor,
            selectedTextColor: Colors.white,
            dateTextStyle: GoogleFonts.lato(
              textStyle: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey),
            ),
            dayTextStyle: GoogleFonts.lato(
              textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey),
            ),
            monthTextStyle: GoogleFonts.lato(
              textStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey),
            ),
            onDateChange: (date) {
              setState(() {
                _selectedDate = date;
              });
            },
          ),
        ),
        _showTasks()
      ],
    );
  }

  _showTasks() {
    return Expanded(child: Obx(() {
      return ListView.builder(
          itemCount: widget.taskController.taskList.length,
          itemBuilder: (_, index) {
            widget.taskController.getCompletedTasks();
            TaskModel task = widget.taskController.taskList[index];
            if (task.repeat == 'Daily') {
              DateTime date = DateFormat.jm().parse(task.startTime.toString());
              var myTime = DateFormat("HH:mm").format(date);
              notifyHelper.dailyScheduledNotification(
                  task,
                  int.parse(myTime.toString().split(':')[0]),
                  int.parse(myTime.toString().split(':')[1]));
              return AnimationConfiguration.staggeredList(
                  position: index,
                  child: SlideAnimation(
                    child: FadeInAnimation(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        GestureDetector(
                          onTap: () {
                            //
                            _item(index, task);
                            setState(() {});
                          },
                          child: TaskTile(
                              task: widget.taskController.taskList[index],
                              isComplete: _isTaskCompleted(
                                  _selectedDate.toString(), index)),
                        )
                      ],
                    )),
                  ));
            } else if (task.date == DateFormat.yMd().format(_selectedDate)) {
              return AnimationConfiguration.staggeredList(
                  position: index,
                  child: SlideAnimation(
                    child: FadeInAnimation(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        GestureDetector(
                          onTap: () {
                            _item(index, task);
                          },
                          child: TaskTile(
                              task: widget.taskController.taskList[index],
                              isComplete: _isTaskCompleted(
                                  _selectedDate.toString(), index)),
                        )
                      ],
                    )),
                  ));
            } else {
              return const SizedBox();
            }
          });
    }));
  }

  _bottomSheetButton(
      {required String text,
      required Color color,
      required VoidCallback onClick,
      required BuildContext context}) {
    return GestureDetector(
        onTap: onClick,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          height: 55,
          width: MediaQuery.of(context).size.width * 0.90,
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(15)),
          child: Center(
            child: Text(
              text,
              style: color == Colors.transparent
                  ? titleTextStyle
                  : titleTextStyle.copyWith(
                      color: Colors.white,
                    ),
            ),
          ),
        ));
  }

  bool _isTaskCompleted(String selectedDate, int index) {
    List completedTasks = widget.taskController.completedTasksList;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        // check whether the state object is in tree
        setState(() {
          // make changes here
        });
      }
    });
    if (completedTasks.isEmpty) {
      return true;
    } else {
      for (var item in completedTasks) {
        for (var it in item) {
          int listId = it['id'];
          String date = it['isCompletedDate'].toString().split(' ')[0];
          if (listId == widget.taskController.taskList[index].id &&
              date == selectedDate.toString().split(' ')[0]) {
            return false;
          }
        }
      }
    }
    return true;
  }

  _item(int index, TaskModel task) {
    _isTaskCompleted(_selectedDate.toString(), index)
        ? Get.bottomSheet(Container(
            height: MediaQuery.of(context).size.height * 0.40,
            color: Get.isDarkMode ? darkGreyColor : Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _bottomSheetButton(
                    text: 'Task completed',
                    color: primaryColor,
                    onClick: () {
                      widget.taskController
                          .markAsCompleted(task.id!, _selectedDate.toString());
                      widget.taskController.getCompletedTasks();
                      Get.back();
                    },
                    context: context),
                _bottomSheetButton(
                    text: 'Delete task',
                    color: Colors.red[300]!,
                    onClick: () async {
                      widget.taskController.deleteTask(task);
                      widget.taskController.getTasks();
                      Get.back();
                    },
                    context: context),
                const SizedBox(
                  height: 10,
                ),
                _bottomSheetButton(
                    text: 'Cancel',
                    color: Colors.transparent,
                    onClick: () {
                      Get.back();
                    },
                    context: context)
              ],
            ),
          ))
        : Get.bottomSheet(Container(
            height: MediaQuery.of(context).size.height * 0.26,
            color: Get.isDarkMode ? darkGreyColor : Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _bottomSheetButton(
                    text: 'Delete task',
                    color: Colors.red[300]!,
                    onClick: () async {
                      widget.taskController.deleteTask(task);
                      widget.taskController.getTasks();
                      Get.back();
                    },
                    context: context),
                const SizedBox(
                  height: 10,
                ),
                _bottomSheetButton(
                    text: 'Cancel',
                    color: Colors.transparent,
                    onClick: () {
                      Get.back();
                    },
                    context: context)
              ],
            ),
          ));
    widget.taskController.getTasks();
  }

  @override
  bool get wantKeepAlive => true;
}
