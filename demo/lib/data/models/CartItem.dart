class CartItem {
  final int id;
  final String name;
  final int price;
  int qty;
  final String image;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.qty,
    required this.image
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'price': price,
    'qty': qty,
    'image': image,
  };

  factory CartItem.fromMap(Map<dynamic, dynamic> map) => CartItem(
    id: map['id'],
    name: map['name'],
    price: map['price'],
    qty: map['qty'],
    image: map['image'] ?? '',
  );
}