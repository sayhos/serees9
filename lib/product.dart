class Product {
  final String id;
  final String name;
  final int price; // цена в тенге

  const Product({required this.id, required this.name, required this.price});
}

const List<Product> catalog = [
  Product(id: 'whey', name: 'Протеин Whey 1 кг', price: 12000),
  Product(id: 'creatine', name: 'Креатин 300 г', price: 8000),
  Product(id: 'bcaa', name: 'BCAA 400 г', price: 9500),
  Product(id: 'gainer', name: 'Гейнер 3 кг', price: 15000),
  Product(id: 'bar', name: 'Протеиновый батончик', price: 800),
];
