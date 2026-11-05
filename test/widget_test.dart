import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/main.dart';

void main() {
  testWidgets('Catalog shows title, products and buttons', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Магазин спортивного питания'), findsOneWidget);
    expect(find.text('Протеин Whey 1 кг'), findsOneWidget);
    expect(find.text('Креатин 300 г'), findsOneWidget);
    expect(find.text('12000 ₸'), findsOneWidget);
    expect(find.byKey(const Key('add_whey')), findsOneWidget);
    expect(find.byKey(const Key('cart_button')), findsOneWidget);
    // Пока ничего не добавлено, значок количества скрыт
    expect(find.text('0'), findsNothing);
  });

  testWidgets('Add button increases cart badge', (tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.byKey(const Key('add_whey')));
    await tester.tap(find.byKey(const Key('add_whey')));
    await tester.pump();

    expect(find.text('2'), findsOneWidget);
  });

  testWidgets('Empty cart shows empty message', (tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.byKey(const Key('cart_button')));
    await tester.pumpAndSettle();

    expect(find.text('Корзина'), findsOneWidget);
    expect(find.text('Корзина пуста'), findsOneWidget);
  });

  testWidgets('Cart shows added items and total (two screens, many elements)',
      (tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.byKey(const Key('add_whey')));
    await tester.tap(find.byKey(const Key('add_creatine')));
    await tester.pump();

    await tester.tap(find.byKey(const Key('cart_button')));
    await tester.pumpAndSettle();

    expect(find.text('Протеин Whey 1 кг'), findsOneWidget);
    expect(find.text('Креатин 300 г'), findsOneWidget);
    expect(find.text('Итого: 20000 ₸'), findsOneWidget);
  });

  testWidgets('Valid promo code applies discount', (tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.byKey(const Key('add_whey')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('cart_button')));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('promo_field')), 'SPORT10');
    await tester.tap(find.byKey(const Key('apply_promo')));
    await tester.pump();

    expect(find.text('Промокод применён: -10%'), findsOneWidget);
    expect(find.text('Итого: 10800 ₸'), findsOneWidget);
  });

  testWidgets('Invalid promo code shows error (invalid input)',
      (tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.byKey(const Key('add_whey')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('cart_button')));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('promo_field')), 'ABC');
    await tester.tap(find.byKey(const Key('apply_promo')));
    await tester.pump();

    expect(find.text('Неверный промокод'), findsOneWidget);
    expect(find.text('Итого: 12000 ₸'), findsOneWidget);
  });

  testWidgets('Remove button decreases quantity', (tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.byKey(const Key('add_whey')));
    await tester.tap(find.byKey(const Key('add_whey')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('cart_button')));
    await tester.pumpAndSettle();

    expect(find.text('2 × 12000 ₸'), findsOneWidget);

    await tester.tap(find.byKey(const Key('remove_whey')));
    await tester.pump();

    expect(find.text('1 × 12000 ₸'), findsOneWidget);
  });

  testWidgets('Clear button empties the cart', (tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.byKey(const Key('add_bar')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('cart_button')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('clear_cart')));
    await tester.pump();

    expect(find.text('Корзина пуста'), findsOneWidget);
  });
}
