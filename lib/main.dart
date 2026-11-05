import 'package:flutter/material.dart';
import 'cart_logic.dart';
import 'product.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Магазин спортивного питания',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
      ),
      home: const CatalogPage(),
    );
  }
}

class CatalogPage extends StatefulWidget {
  const CatalogPage({super.key});

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  final CartLogic _cart = CartLogic();

  Future<void> _openCart() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CartPage(cart: _cart)),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Магазин спортивного питания'),
        actions: [
          IconButton(
            key: const Key('cart_button'),
            tooltip: 'Открыть корзину',
            onPressed: _openCart,
            icon: Badge(
              label: Text('${_cart.totalItems}'),
              isLabelVisible: _cart.totalItems > 0,
              child: const Icon(Icons.shopping_cart),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          for (final product in catalog)
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: ListTile(
                title: Text(product.name),
                subtitle: Text('${product.price} ₸'),
                trailing: ElevatedButton(
                  key: Key('add_${product.id}'),
                  onPressed: () => setState(() => _cart.add(product)),
                  child: const Text('В корзину'),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class CartPage extends StatefulWidget {
  const CartPage({super.key, required this.cart});

  final CartLogic cart;

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final TextEditingController _promoController = TextEditingController();
  String _message = '';

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  void _applyPromo() {
    final ok = widget.cart.applyPromo(_promoController.text);
    setState(() {
      _message = ok ? 'Промокод применён: -10%' : 'Неверный промокод';
    });
  }

  @override
  Widget build(BuildContext context) {
    final cart = widget.cart;
    return Scaffold(
      appBar: AppBar(title: const Text('Корзина')),
      body: cart.isEmpty
          ? const Center(child: Text('Корзина пуста'))
          : Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      for (final item in cart.items)
                        ListTile(
                          title: Text(item.product.name),
                          subtitle:
                              Text('${item.quantity} × ${item.product.price} ₸'),
                          trailing: IconButton(
                            key: Key('remove_${item.product.id}'),
                            icon: const Icon(Icons.remove_circle_outline),
                            onPressed: () =>
                                setState(() => cart.removeOne(item.product)),
                          ),
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              key: const Key('promo_field'),
                              controller: _promoController,
                              decoration: const InputDecoration(
                                labelText: 'Промокод',
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            key: const Key('apply_promo'),
                            onPressed: _applyPromo,
                            child: const Text('Применить'),
                          ),
                        ],
                      ),
                      if (_message.isNotEmpty) Text(_message),
                      const SizedBox(height: 8),
                      Text('Сумма: ${cart.subtotal} ₸'),
                      Text('Скидка: -${cart.discount} ₸'),
                      Text(
                        'Итого: ${cart.total} ₸',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      TextButton(
                        key: const Key('clear_cart'),
                        onPressed: () => setState(cart.clear),
                        child: const Text('Очистить'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}