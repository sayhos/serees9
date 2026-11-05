import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/cart_logic.dart';
import 'package:flutter_application_1/product.dart';

void main() {
  const whey = Product(id: 'whey', name: 'Протеин', price: 12000);
  const bar = Product(id: 'bar', name: 'Батончик', price: 800);

  group('CartLogic Unit Tests', () {
    late CartLogic cart;

    setUp(() {
      cart = CartLogic();
    });

    test('New cart is empty and total is 0', () {
      expect(cart.isEmpty, true);
      expect(cart.total, 0);
      expect(cart.totalItems, 0);
    });

    test('Add one product updates subtotal', () {
      cart.add(whey);
      expect(cart.subtotal, 12000);
      expect(cart.totalItems, 1);
    });

    test('Adding same product twice merges quantity', () {
      cart.add(whey);
      cart.add(whey, 2);
      expect(cart.items.length, 1);
      expect(cart.totalItems, 3);
      expect(cart.subtotal, 36000);
    });

    test('Different products are summed', () {
      cart.add(whey);
      cart.add(bar, 5);
      expect(cart.subtotal, 16000);
    });

    test('Add with zero or negative quantity throws', () {
      expect(() => cart.add(whey, 0), throwsArgumentError);
      expect(() => cart.add(whey, -2), throwsArgumentError);
    });

    test('removeOne decreases quantity and removes item at zero', () {
      cart.add(bar, 2);
      cart.removeOne(bar);
      expect(cart.totalItems, 1);
      cart.removeOne(bar);
      expect(cart.isEmpty, true);
    });

    test('removeOne on missing product does nothing', () {
      cart.removeOne(whey);
      expect(cart.isEmpty, true);
    });

    test('Promo SPORT10 gives 10% discount', () {
      cart.add(whey);
      expect(cart.applyPromo('SPORT10'), true);
      expect(cart.discount, 1200);
      expect(cart.total, 10800);
    });

    test('Promo is case-insensitive and ignores spaces', () {
      cart.add(whey);
      expect(cart.applyPromo('  sport10 '), true);
      expect(cart.total, 10800);
    });

    test('Invalid promo is rejected', () {
      cart.add(whey);
      expect(cart.applyPromo('WRONG'), false);
      expect(cart.discount, 0);
      expect(cart.total, 12000);
    });

    test('clear empties cart and resets promo', () {
      cart.add(whey);
      cart.applyPromo('SPORT10');
      cart.clear();
      expect(cart.isEmpty, true);
      expect(cart.discountPercent, 0);
    });
  });
}
