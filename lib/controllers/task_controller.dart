import 'dart:async';

import 'package:get/get.dart';
import 'package:mantime/database/database_helper.dart';
import 'package:mantime/models/task_model.dart';

class TaskController extends GetxController {
  var taskList = <TaskModel>[].obs;
  var completedTasksList = <List<Map>>[].obs;

  Future<int> addTask({TaskModel? task}) async {
    return await DataBaseHelper.insert(task);
  }

  void getTasks() async {
    List<Map<String, dynamic>> tasks = await DataBaseHelper.query();
    taskList.assignAll(tasks.map((data) => TaskModel.fromJson(data)).toList());
  }

  Future<void> getCompletedTasks() async {
    List<Map> completedTasks = await DataBaseHelper.completedQuery();
    completedTasksList.assign(completedTasks);
  }

  void deleteTask(TaskModel task) async {
    await DataBaseHelper.delete(task);
  }

  void markAsCompleted(int id, String selectedDate) async {
    await DataBaseHelper.completeTask(id, selectedDate);
  }
}
