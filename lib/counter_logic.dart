class CounterLogic {
  int _value;

  CounterLogic([this._value = 0]);

  int get value => _value;

  bool get isEven => _value % 2 == 0;

  void increment() => _value++;

  // Не уходит в минус
  void decrement() {
    if (_value > 0) _value--;
  }

  void add(int n) {
    if (n < 0) {
      throw ArgumentError('Number must be non-negative');
    }
    _value += n;
  }

  void reset() => _value = 0;
}
