import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mantime/constants.dart';
import 'package:mantime/models/pomodoro_model.dart';
import 'package:mantime/services/notification_services.dart';
import 'package:mantime/theme/theme.dart';
import 'package:mantime/widgets/complete_pomodoro_icon.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class PomodoroPage extends StatefulWidget {
  const PomodoroPage({Key? key}) : super(key: key);

  @override
  State<PomodoroPage> createState() => _PomodoroPageState();
}

const _btnTextStart = 'START POMODORO';
const _btnTextResumePomodor = 'RESUME POMODORO';
const _btnTextResumeBreak = 'START POMODORO';
const _btnTextStartShrtBreak = 'TAKE SHORT BREAK';
const _btnTextStartLongBreak = 'TAKE LONG BREAK';
const _btnTextStartNewSet = 'START NEW SET';
const _btnTextPause = 'PAUSE';

class _PomodoroPageState extends State<PomodoroPage>
    with AutomaticKeepAliveClientMixin<PomodoroPage> {
  int remainingTime = pomodoroTotalTime;
  String mainBtnText = _btnTextStart;
  PomodoroModel pomodoroStatus = PomodoroModel.pausedPomodoro;
  Timer? _timer;
  int pomodoroNumber = 0;
  int setNumber = 0;

  @override
  void dispose() {
    if (_timer != null) {
      _timer!.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
        child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Text(
                'Pomodoro',
                style: headingTextStyle,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          'Pomodoro N⚬ : $pomodoroNumber',
          style: subHeadingTextStyle,
        ),
        Text(
          'Set : $setNumber',
          style: subHeadingTextStyle,
        ),
        const SizedBox(
          height: 20,
        ),
        Expanded(
          child: Column(
            children: [
              CircularPercentIndicator(
                  circularStrokeCap: CircularStrokeCap.round,
                  radius: 120.0,
                  lineWidth: 15.0,
                  percent: _getPomodoroPercentage(),
                  progressColor: statusColor[pomodoroStatus],
                  center: Text(
                    _secondsToFormatedString(remainingTime),
                    style: titleTextStyle.copyWith(fontSize: 25),
                  )),
              const SizedBox(
                height: 20,
              ),
              PomodoroIcons(
                  number: pomodoriPerset,
                  completed: pomodoroNumber - (setNumber * pomodoriPerset)),
              const SizedBox(
                height: 20,
              ),
              Text(
                statusDescription[pomodoroStatus]!,
                style: titleTextStyle,
              ),
              const SizedBox(
                height: 20,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                MaterialButton(
                  onPressed: () {
                    _onStartButtonPressed();
                  },
                  color: primaryColor,
                  height: 50,
                  minWidth: 150,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                  )),
                  child: Text(
                    mainBtnText,
                    style: titleTextStyle.copyWith(
                        color: Colors.white, fontWeight: FontWeight.normal),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                MaterialButton(
                  onPressed: () {
                    _onResetButtonPressed();
                  },
                  color: primaryColor,
                  height: 50,
                  minWidth: 80,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  )),
                  child: Text(
                    'Reset',
                    style: titleTextStyle.copyWith(
                        color: Colors.white, fontWeight: FontWeight.normal),
                  ),
                )
              ])
            ],
          ),
        ),
      ],
    ));
  }

  _secondsToFormatedString(int seconds) {
    int roundedMinutes = seconds ~/ 60;
    int remainingSeconds = seconds - (roundedMinutes * 60);
    String remainingSecondsFormated;
    if (remainingSeconds < 10) {
      remainingSecondsFormated = '0$remainingSeconds';
    } else {
      remainingSecondsFormated = remainingSeconds.toString();
    }
    return '$roundedMinutes:$remainingSecondsFormated';
  }

  double _getPomodoroPercentage() {
    int totalTime;
    switch (pomodoroStatus) {
      case PomodoroModel.runningPomodoro:
        totalTime = pomodoroTotalTime;
        break;
      case PomodoroModel.pausedPomodoro:
        totalTime = pomodoroTotalTime;
        break;
      case PomodoroModel.runnimgShortBreak:
        totalTime = shortBreakTime;
        break;
      case PomodoroModel.pausedShortBreak:
        totalTime = shortBreakTime;
        break;
      case PomodoroModel.runningLongBreak:
        totalTime = longBreakTime;
        break;
      case PomodoroModel.pausedLongBreak:
        totalTime = longBreakTime;
        break;
      case PomodoroModel.setFinished:
        totalTime = pomodoroTotalTime;
        break;
    }
    double percentage = (totalTime - remainingTime) / totalTime;
    return percentage;
  }

  _pausePomodoroCountDown() {
    pomodoroStatus = PomodoroModel.pausedPomodoro;
    if (_timer != null) {
      _timer!.cancel();
    }
    setState(() {
      mainBtnText = _btnTextResumePomodor;
    });
  }

  _onResetButtonPressed() {
    pomodoroNumber = 0;
    setNumber = 0;
    if (_timer != null) {
      _timer!.cancel();
    }
    _stopCountDown();
  }

  _stopCountDown() {
    pomodoroStatus = PomodoroModel.pausedPomodoro;
    setState(() {
      mainBtnText = _btnTextStart;
      remainingTime = pomodoroTotalTime;
    });
  }

  _onStartButtonPressed() {
    switch (pomodoroStatus) {
      case PomodoroModel.runningPomodoro:
        _pausePomodoroCountDown();
        break;
      case PomodoroModel.pausedPomodoro:
        _startPomodoroCountDown();
        break;
      case PomodoroModel.runnimgShortBreak:
        _pauseShortBreakCountDown();
        break;
      case PomodoroModel.pausedShortBreak:
        _startShortBreak();
        break;
      case PomodoroModel.runningLongBreak:
        _pauseLongBreakCountDown();
        break;
      case PomodoroModel.pausedLongBreak:
        _startLongBreak();
        break;
      case PomodoroModel.setFinished:
        setNumber++;
        _startPomodoroCountDown();
        break;
    }
  }

  _pauseShortBreakCountDown() {
    pomodoroStatus = PomodoroModel.pausedShortBreak;
    _pauseBreakCountDown();
  }

  _startShortBreak() {
    pomodoroStatus = PomodoroModel.runnimgShortBreak;
    setState(() {
      mainBtnText = _btnTextPause;
    });
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingTime > 0) {
        setState(() {
          mainBtnText = _btnTextPause;
          remainingTime--;
        });
      } else {
        _showNotification();
        remainingTime = pomodoroTotalTime;
        if (_timer != null) {
          _timer!.cancel();
        }
        pomodoroStatus = PomodoroModel.pausedPomodoro;
        setState(() {
          mainBtnText = _btnTextStart;
        });
      }
    });
  }

  _showNotification() {
    NotificationHelper helper = NotificationHelper();
    helper.displayNotification(
        title: "Timer completed", body: statusDescription[pomodoroStatus]!);
  }

  _startLongBreak() {
    pomodoroStatus = PomodoroModel.runningLongBreak;
    setState(() {
      mainBtnText = _btnTextPause;
    });
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingTime > 0) {
        setState(() {
          mainBtnText = _btnTextPause;
          remainingTime--;
        });
      } else {
        _showNotification();
        remainingTime = pomodoroTotalTime;
        if (_timer != null) {
          _timer!.cancel();
        }
        pomodoroStatus = PomodoroModel.setFinished;
        setState(() {
          mainBtnText = _btnTextStartNewSet;
        });
      }
    });
  }

  _pauseLongBreakCountDown() {
    pomodoroStatus = PomodoroModel.pausedLongBreak;
    _pauseBreakCountDown();
  }

  _pauseBreakCountDown() {
    if (_timer != null) {
      _timer!.cancel();
    }
    setState(() {
      mainBtnText = _btnTextResumeBreak;
    });
  }

  _startPomodoroCountDown() {
    pomodoroStatus = PomodoroModel.runningPomodoro;
    if (_timer != null) {
      _timer!.cancel();
    }

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingTime > 0) {
        setState(() {
          remainingTime--;
          mainBtnText = _btnTextPause;
        });
      } else {
        _showNotification();
        pomodoroNumber++;
        if (_timer != null) {
          _timer!.cancel();
        }
        if (pomodoroNumber % pomodoriPerset == 0) {
          pomodoroStatus = PomodoroModel.pausedLongBreak;
          setState(() {
            remainingTime = longBreakTime;
            mainBtnText = _btnTextStartLongBreak;
          });
        } else {
          pomodoroStatus = PomodoroModel.pausedShortBreak;
          setState(() {
            remainingTime = shortBreakTime;
            mainBtnText = _btnTextStartShrtBreak;
          });
        }
      }
    });
  }

  @override
  bool get wantKeepAlive => true;
}
