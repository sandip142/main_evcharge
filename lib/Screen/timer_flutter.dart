import 'package:flutter/material.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';

class TimerAdd extends StatelessWidget {
  const TimerAdd({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          child: TimerCountdown(
              format: CountDownTimerFormat.hoursMinutesSeconds,
              endTime: DateTime.now().add(
                const Duration(
                  hours: 0,
                  minutes: 0,
                  seconds: 34,
                ),
              ),
              onEnd: () {
                print("Timer finished");
              },
            ),
        ),
      ),
    );
  }
}