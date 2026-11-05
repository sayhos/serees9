import 'product.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem(this.product, this.quantity);
}

class CartLogic {
  final Map<String, CartItem> _items = {};
  int _discountPercent = 0;

  List<CartItem> get items => _items.values.toList();

  bool get isEmpty => _items.isEmpty;

  int get totalItems =>
      _items.values.fold(0, (sum, item) => sum + item.quantity);

  int get subtotal => _items.values
      .fold(0, (sum, item) => sum + item.product.price * item.quantity);

  int get discountPercent => _discountPercent;

  int get discount => subtotal * _discountPercent ~/ 100;

  int get total => subtotal - discount;

  void add(Product product, [int quantity = 1]) {
    if (quantity <= 0) {
      throw ArgumentError('Quantity must be positive');
    }
    final existing = _items[product.id];
    if (existing == null) {
      _items[product.id] = CartItem(product, quantity);
    } else {
      existing.quantity += quantity;
    }
  }

  void removeOne(Product product) {
    final existing = _items[product.id];
    if (existing == null) return;
    existing.quantity--;
    if (existing.quantity <= 0) {
      _items.remove(product.id);
    }
  }

  // Промокод SPORT10 даёт скидку 10%
  bool applyPromo(String code) {
    if (code.trim().toUpperCase() == 'SPORT10') {
      _discountPercent = 10;
      return true;
    }
    return false;
  }

  void clear() {
    _items.clear();
    _discountPercent = 0;
  }
}
