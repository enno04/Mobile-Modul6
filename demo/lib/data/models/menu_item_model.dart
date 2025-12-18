class MenuItem {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final int price; // dalam rupiah
  final bool isAvailable;

  MenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.isAvailable,
  });

  factory MenuItem.fromMap(Map<String, dynamic> map) {
    return MenuItem(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      imageUrl: map['image_url'] as String,
      price: map['price'] as int,
      isAvailable: map['is_available'] as bool,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image_url': imageUrl,
      'price': price,
      'is_available': isAvailable,
    };
  }
}
