import 'package:flutter/material.dart';
import 'package:mantime/models/pomodoro_model.dart';

const TextStyle knormalTextStyle = TextStyle(fontFamily: 'AlbertSans');
const pomodoroTotalTime = 25 * 60;
const shortBreakTime = 5 * 25;
const longBreakTime = 15 * 25;
const pomodoriPerset = 4;

const Map<PomodoroModel, String> statusDescription = {
  PomodoroModel.runningPomodoro: 'Time to be focused.',
  PomodoroModel.pausedPomodoro: 'Ready for a focused pomodoro?',
  PomodoroModel.runnimgShortBreak: 'Short break running, relax.',
  PomodoroModel.pausedShortBreak: 'It\'s your short break.',
  PomodoroModel.runningLongBreak: 'Long break running.',
  PomodoroModel.pausedLongBreak: 'It\'s your long break.',
  PomodoroModel.setFinished: 'Congrats, you did it, ready to start?'
};

const Map<PomodoroModel, MaterialColor> statusColor = {
  PomodoroModel.runningPomodoro: Colors.green,
  PomodoroModel.pausedPomodoro: Colors.orange,
  PomodoroModel.runnimgShortBreak: Colors.red,
  PomodoroModel.pausedShortBreak: Colors.orange,
  PomodoroModel.runningLongBreak: Colors.red,
  PomodoroModel.pausedLongBreak: Colors.orange,
  PomodoroModel.setFinished: Colors.orange
};
