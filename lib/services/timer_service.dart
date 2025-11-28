import 'dart:async';

class TimerService {
  int _secondsRemaining = 0;
  Timer? _timer;
  void Function()? _onFinished; // callback เมื่อหมดเวลา
  void Function(int)? _onTick;  // callback ทุก 1 วินาที

  /// เริ่มนับถอยหลัง
  void start({
    required int seconds,
    void Function()? onFinished,
    void Function(int)? onTick,
  }) {
    // ยกเลิก timer เดิมก่อน
    _timer?.cancel();

    _secondsRemaining = seconds;
    _onFinished = onFinished;
    _onTick = onTick;

    // แจ้งค่าเริ่มต้นก่อนเริ่มนับ
    _onTick?.call(_secondsRemaining);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _secondsRemaining--;

      // เรียก callback ทุกวินาที
      _onTick?.call(_secondsRemaining);

      if (_secondsRemaining <= 0) {
        timer.cancel();
        _onFinished?.call(); // หมดเวลาแล้ว trigger function
      }
    });
  }

  /// หยุดชั่วคราว
  void pause() {
    _timer?.cancel();
  }

  /// ยกเลิกทั้งหมด
  void cancel() {
    _timer?.cancel();
    _secondsRemaining = 0;
  }

  /// ดูค่าว่าเหลือกี่วินาที
  int get remainingSeconds => _secondsRemaining;
}
