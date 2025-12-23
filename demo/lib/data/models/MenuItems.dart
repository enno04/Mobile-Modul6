class MenuItems {
  final int itemID;
  final String itemName;
  final String itemDescription;
  final int itemPrice;
  final String restaurantName;
  final int restaurantID;
  final String imageUrl;

  MenuItems({
    required this.itemID,
    required this.itemName,
    required this.itemDescription,
    required this.itemPrice,
    required this.restaurantName,
    required this.restaurantID,
    required this.imageUrl,
  });

  factory MenuItems.fromJson(Map<String, dynamic> json) {
    return MenuItems(
      itemID: json['itemID'] ?? 0,
      itemName: json['itemName'] ?? '',
      itemDescription: json['itemDescription'] ?? '',
      itemPrice: json['itemPrice'] ?? 0,
      restaurantName: json['restaurantName'] ?? '',
      restaurantID: json['restaurantID'] ?? 0,
      imageUrl: json['imageUrl'] ?? '',
    );
  }

  // Helper untuk convert List JSON ke List Model
  static List<MenuItems> fromJsonList(List list) {
    return list.map((item) => MenuItems.fromJson(item)).toList();
  }
}