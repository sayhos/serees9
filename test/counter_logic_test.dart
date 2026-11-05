import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/counter_logic.dart';

void main() {
  group('CounterLogic Unit Tests', () {
    test('Initial value is 0', () {
      expect(CounterLogic().value, 0);
    });

    test('Increment increases value by 1', () {
      final c = CounterLogic();
      c.increment();
      c.increment();
      expect(c.value, 2);
    });

    test('Decrement decreases value', () {
      final c = CounterLogic(5);
      c.decrement();
      expect(c.value, 4);
    });

    test('Decrement does not go below zero', () {
      final c = CounterLogic();
      c.decrement();
      expect(c.value, 0);
    });

    test('Add adds number', () {
      final c = CounterLogic(3);
      c.add(7);
      expect(c.value, 10);
    });

    test('Add with negative number throws', () {
      final c = CounterLogic();
      expect(() => c.add(-1), throwsArgumentError);
    });

    test('Reset sets value to 0', () {
      final c = CounterLogic(9);
      c.reset();
      expect(c.value, 0);
    });

    test('isEven works correctly', () {
      expect(CounterLogic(4).isEven, true);
      expect(CounterLogic(3).isEven, false);
    });
  });
}
