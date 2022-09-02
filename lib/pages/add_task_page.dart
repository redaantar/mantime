import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mantime/controllers/task_controller.dart';
import 'package:mantime/models/task_model.dart';
import 'package:mantime/theme/theme.dart';
import 'package:mantime/widgets/titled_input_field.dart';
import 'package:intl/intl.dart';

class AddTaskPage extends StatefulWidget {
  static const addTaskPage = "AddTaskPage";
  const AddTaskPage({
    Key? key,
  }) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TaskController _taskController = TaskController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _startTime = DateFormat('hh:mm a').format(DateTime.now());
  String _endTime = '9:30 AM';
  int _selectedRemind = 5;
  String dropdownValue = '5 minutes early';
  List<int> listRemind = [
    5,
    10,
    15,
    20,
  ];
  List<String> listRepeat = ['None', 'Daily', 'Weekly', 'Monthly', 'Yearly'];
  String _selectedRepeat = 'None';
  int _selectedColor = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.only(top: 5),
            child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_ios),
                color: Get.isDarkMode ? Colors.white : Colors.black),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Container(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(
                height: 15,
              ),
              Text(
                'Add Task',
                style: headingTextStyle,
              ),
              const SizedBox(
                height: 10,
              ),
              TitledInputField(
                title: 'Title',
                hint: 'Enter your title',
                controller: _titleController,
              ),
              TitledInputField(
                title: 'Description',
                hint: 'Enter your note',
                controller: _descriptionController,
              ),
              TitledInputField(
                title: 'Date',
                hint: DateFormat.yMd().format(_selectedDate),
                widget: IconButton(
                    onPressed: () {
                      _getDataFromUser();
                    },
                    icon: const Icon(Icons.calendar_today_outlined)),
              ),
              Row(
                children: [
                  Expanded(
                    child: TitledInputField(
                      title: "Start time",
                      hint: _startTime,
                      widget: IconButton(
                          onPressed: () {
                            _getTimeFromUser(isStartTime: true);
                          },
                          icon: const Icon(Icons.access_time_rounded)),
                    ),
                  ),
                  const SizedBox(width: 7),
                  Expanded(
                    child: TitledInputField(
                      title: "End time",
                      hint: _endTime,
                      widget: IconButton(
                          onPressed: () {
                            _getTimeFromUser(isStartTime: false);
                          },
                          icon: const Icon(Icons.access_time_rounded)),
                    ),
                  )
                ],
              ),
              TitledInputField(
                title: 'Remind',
                hint: "$_selectedRemind minutes early",
                widget: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: DropdownButton(
                    underline: Container(),
                    items:
                        listRemind.map<DropdownMenuItem<String>>((int value) {
                      return DropdownMenuItem<String>(
                        value: value.toString(),
                        child: Text('$value min'),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedRemind = int.parse(newValue!.toString());
                      });
                    },
                    icon: const Icon(Icons.keyboard_arrow_down),
                  ),
                ),
              ),
              TitledInputField(
                title: 'Repeat',
                hint: _selectedRepeat,
                widget: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: DropdownButton(
                    underline: Container(),
                    items: listRepeat
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedRepeat = newValue!;
                      });
                    },
                    icon: const Icon(Icons.keyboard_arrow_down),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Color",
                        style: titleTextStyle,
                      ),
                      Wrap(
                        children: List<Widget>.generate(3, (index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedColor = index;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8, top: 8),
                              child: CircleAvatar(
                                  radius: 14,
                                  backgroundColor: index == 0
                                      ? blueColor
                                      : index == 1
                                          ? pinkColor
                                          : yellowColor,
                                  child: index == _selectedColor
                                      ? const Icon(
                                          Icons.done,
                                          color: Colors.white,
                                        )
                                      : Container()),
                            ),
                          );
                        }),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: MaterialButton(
                      onPressed: () {
                        _dataFormValidator();
                      },
                      color: primaryColor,
                      height: 50,
                      minWidth: 150,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      child: Text(
                        'Add task',
                        style: titleTextStyle.copyWith(
                            color: Colors.white, fontWeight: FontWeight.normal),
                      ),
                    ),
                  )
                ],
              )
            ]),
          ),
        ),
      ),
    );
  }

  _addTaskTodb() async {
    debugPrint(DateFormat.yMd().format(_selectedDate));
    await _taskController.addTask(
        task: TaskModel(
      title: _titleController.text.toString(),
      description: _descriptionController.text.toString(),
      color: _selectedColor,
      date: DateFormat.yMd().format(_selectedDate),
      isCompleted: 0,
      startTime: _startTime,
      endTime: _endTime,
      repeat: _selectedRepeat,
      remind: _selectedRemind,
    ));
  }

  _getDataFromUser() async {
    DateTime? pickerDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2021),
        lastDate: DateTime(2122));

    if (pickerDate != null) {
      setState(() {
        _selectedDate = pickerDate;
      });
      debugPrint(_selectedDate.toString());
    }
  }

  _getTimeFromUser({required bool isStartTime}) async {
    var pickedTime = await showTimePicker(
        initialEntryMode: TimePickerEntryMode.dial,
        context: context,
        initialTime: TimeOfDay(
            hour: int.parse(_startTime.split(':')[0]),
            minute: int.parse(_startTime.split(':')[1].split(' ')[0])));
    if (!mounted) return;
    String? formatedTime = pickedTime?.format(context);
    if (pickedTime != null) {
      switch (isStartTime) {
        case true:
          setState(() {
            _startTime = formatedTime!;
          });
          break;
        case false:
          setState(() {
            _endTime = formatedTime!;
          });
      }
    }
  }

  _dataFormValidator() {
    if (_titleController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty) {
      _addTaskTodb();
      Navigator.pop(context);
      Get.snackbar('Task added succesfully', '',
          icon: const Icon(
            Icons.check_circle_outline,
            color: Colors.green,
          ),
          colorText: Colors.green);
    } else if (_titleController.text.isEmpty ||
        _descriptionController.text.isEmpty) {
      Get.snackbar(
        "Warning",
        '',
        messageText: Text(
          'Title and Description is required',
          style: titleTextStyle.copyWith(
              color: Colors.red, fontWeight: FontWeight.normal),
        ),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        colorText: Colors.red,
        icon: const Icon(
          Icons.warning_amber,
          color: Colors.red,
        ),
      );
    }
  }
}
