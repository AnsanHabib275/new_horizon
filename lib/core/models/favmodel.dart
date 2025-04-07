class FavModel {
  final String productName;
  final int price;
  final List<String> imageUrl;
  final String productId;
  final String description;
  final String category;

  FavModel({
    required this.productName,
    required this.price,
    required this.imageUrl,
    required this.productId,
    required this.description,
    required this.category,
  });

  // Factory constructor to create a FavModel from a JSON object
  factory FavModel.fromJson(Map<String, dynamic> json) {
    return FavModel(
      productName: json['product_name'],
      price: json['price'],
      imageUrl: List<String>.from(json['image_url']),
      productId: json['product_id'],
      description: json['description'],
      category: json['category'],
    );
  }
}
