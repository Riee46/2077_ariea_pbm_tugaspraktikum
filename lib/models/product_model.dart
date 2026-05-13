class ProductModel {
  final int id;
  final String name;
  final int price;
  final String description;
  final String createdAt;
  final String updatedAt;

  ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    // Parsing price: bisa dari String atau int
    int parsedPrice;
    final priceValue = json['price'];
    if (priceValue is String) {
      // Hapus koma, konversi double lalu ke int
      // Contoh: "125.00" -> 125
      parsedPrice = double.tryParse(priceValue)?.toInt() ?? 0;
    } else if (priceValue is int) {
      parsedPrice = priceValue;
    } else if (priceValue is double) {
      parsedPrice = priceValue.toInt();
    } else {
      parsedPrice = 0;
    }

    return ProductModel(
      id: json['id'],
      name: json['name'],
      price: parsedPrice,
      description: json['description'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'description': description,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
