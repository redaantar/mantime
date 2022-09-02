import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mantime/controllers/task_controller.dart';
import 'package:mantime/models/task_model.dart';
import 'package:mantime/theme/theme.dart';
import 'package:timelines/timelines.dart';

class DataReportPage extends StatefulWidget {
  final TaskController taskController;
  const DataReportPage({Key? key, required this.taskController})
      : super(key: key);

  @override
  State<DataReportPage> createState() => _DataReportPageState();
}

class _DataReportPageState extends State<DataReportPage> {
  @override
  void initState() {
    widget.taskController.getTasks();
    widget.taskController.getCompletedTasks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Text(
            'History',
            style: headingTextStyle,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Expanded(
          child: Obx(
            () => Timeline.tileBuilder(
              theme: TimelineThemeData(color: Theme.of(context).primaryColor),
              builder: TimelineTileBuilder.connectedFromStyle(
                firstConnectorStyle: ConnectorStyle.transparent,
                connectionDirection: ConnectionDirection.after,
                contentsAlign: ContentsAlign.alternating,
                oppositeContentsBuilder: (context, index) {
                  TaskModel task = widget.taskController.taskList[index];
                  if (index % 2 == 0) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: _completIcon(
                                isCompleted:
                                    task.isCompleted == 1 ? true : false),
                          ),
                          Text(
                            '${task.startTime}\n${task.endTime}',
                            style: subHeadingTextStyle.copyWith(fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${task.startTime}\n${task.endTime}',
                            style: subHeadingTextStyle.copyWith(fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: _completIcon(
                                isCompleted:
                                    task.isCompleted == 1 ? true : false),
                          )
                        ],
                      ),
                    );
                  }
                },
                contentsBuilder: (context, index) {
                  widget.taskController.getCompletedTasks();
                  TaskModel task = widget.taskController.taskList[index];
                  if (index % 2 == 0) {
                    return GestureDetector(
                      onTap: () {
                        _showBottomSheet(index, task);
                      },
                      child: Container(
                        padding: const EdgeInsets.only(right: 15),
                        margin: const EdgeInsets.only(left: 5),
                        decoration: BoxDecoration(
                            color: task.isCompleted == 1
                                ? const Color.fromARGB(255, 66, 198, 70)
                                : const Color.fromARGB(255, 67, 70, 76),
                            borderRadius: BorderRadius.circular(10)),
                        height: MediaQuery.of(context).size.height * 0.15,
                        width: MediaQuery.of(context).size.width * 0.42,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  '${task.title}',
                                  style: titleTextStyle.copyWith(
                                      color: Colors.white,
                                      fontSize: 19,
                                      fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const Divider(
                                indent: 10,
                                endIndent: 10,
                                color: Color.fromARGB(255, 171, 171, 171),
                                thickness: 1,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 7),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.date_range,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(
                                      width: 2,
                                    ),
                                    Text(
                                      '${task.date}',
                                      style: subHeadingTextStyle.copyWith(
                                          fontSize: 17,
                                          color: Colors.grey[300]),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  } else {
                    return GestureDetector(
                      onTap: () {
                        _showBottomSheet(index, task);
                      },
                      child: Container(
                        padding: const EdgeInsets.only(left: 15),
                        margin: const EdgeInsets.only(right: 5),
                        decoration: BoxDecoration(
                            color: task.isCompleted == 1
                                ? const Color.fromARGB(255, 66, 198, 70)
                                : const Color.fromARGB(255, 67, 70, 76),
                            borderRadius: BorderRadius.circular(10)),
                        height: MediaQuery.of(context).size.height * 0.15,
                        width: MediaQuery.of(context).size.width * 0.42,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  '${task.title}',
                                  style: titleTextStyle.copyWith(
                                      color: Colors.white,
                                      fontSize: 19,
                                      fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const Divider(
                                color: Color.fromARGB(255, 171, 171, 171),
                                endIndent: 10,
                                indent: 10,
                                thickness: 1,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 7),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.date_range,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(
                                      width: 2,
                                    ),
                                    Text(
                                      '${task.date}',
                                      style: subHeadingTextStyle.copyWith(
                                          fontSize: 17,
                                          color: Colors.grey[300]),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                },
                connectorStyleBuilder: (context, index) =>
                    ConnectorStyle.solidLine,
                indicatorStyleBuilder: (context, index) =>
                    IndicatorStyle.outlined,
                itemCount: widget.taskController.taskList.length,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        )
      ],
    );
  }

  Widget _completIcon({required bool isCompleted}) {
    if (isCompleted) {
      return const CircleAvatar(
          backgroundColor: Color.fromARGB(255, 173, 219, 183),
          child: Icon(
            Icons.check,
            color: Color.fromARGB(255, 66, 198, 70),
          ));
    } else {
      return const CircleAvatar(
        backgroundColor: Color.fromARGB(255, 245, 181, 178),
        child: Icon(
          Icons.close,
          color: pinkColor,
        ),
      );
    }
  }

  _showBottomSheet(int index, TaskModel task) {
    Get.bottomSheet(Container(
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
}
