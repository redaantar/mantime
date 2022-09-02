import 'package:flutter/material.dart';
import 'package:mantime/models/task_model.dart';
import 'package:mantime/theme/theme.dart';

class TaskTile extends StatelessWidget {
  final TaskModel task;
  final bool isComplete;
  const TaskTile({Key? key, required this.task, required this.isComplete})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 15),
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
              color: Colors.black,
              blurRadius: 2.0,
              spreadRadius: 0.0,
              offset: Offset(1.0, 1.0), // shadow direction: bottom right
            )
          ],
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(10),
            topLeft: Radius.circular(10),
            bottomRight: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          color: isComplete
              ? const Color.fromARGB(255, 67, 70, 76)
              : const Color.fromARGB(
                  255, 66, 198, 70)), //Color.fromARGB(255, 67, 70, 76)
      child: Container(
        decoration: BoxDecoration(
          color: task.color == 0
              ? blueColor
              : task.color == 1
                  ? pinkColor
                  : yellowColor,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(20),
            topLeft: Radius.circular(10),
            topRight: Radius.circular(20),
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                isComplete ? _todoTag() : _doneTag(),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  task.title.toString(),
                  style: titleTextStyle.copyWith(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.access_time,
                      color: Colors.white,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                        '${task.startTime.toString()} - ${task.endTime.toString()} ',
                        style: titleTextStyle.copyWith(
                            fontWeight: FontWeight.normal,
                            color: Colors.white,
                            fontSize: 14)),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.70,
                  child: Text(
                    task.description.toString(),
                    style: titleTextStyle.copyWith(
                        fontWeight: FontWeight.normal, color: Colors.white),
                  ),
                )
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.10,
                  child: !isComplete
                      ? const CircleAvatar(
                          backgroundColor: Color.fromARGB(255, 173, 219, 183),
                          child: Icon(
                            Icons.check,
                            color: Color.fromARGB(255, 66, 198, 70),
                          ))
                      : Container(),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  _doneTag() {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: const Color.fromARGB(255, 173, 219, 183)),
      child: Text(
        'Done',
        style: titleTextStyle.copyWith(
            color: const Color.fromARGB(255, 66, 198, 70)),
      ),
    );
  }

  _todoTag() {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: const Color.fromARGB(255, 245, 181, 178)),
      child: Text(
        'To do',
        style: titleTextStyle.copyWith(color: pinkColor),
      ),
    );
  }
}
