class FavoriteModel {
  final int id;
  final String name;
  final String description;
  final String image;
  final String rating;
  final String price;
  final bool isFavorite;

  FavoriteModel({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.rating,
    required this.price,
    required this.isFavorite,
  });
   static List<FavoriteModel> dummyFavorites = [
    FavoriteModel(
      id: 1,
      name: "Cheeseburger Wendys Burger",
      description:
      "Enjoy our delicious Hamburger Veggie Burger, made with a savory blend of fresh vegetables and herbs.",
      image: "http://sonic-zdi0.onrender.com/storage/products/cheeseburger.jpg",
      rating: "4.9",
      price: "140.00",
      isFavorite: true,
    ),
    FavoriteModel(
      id: 7,
      name: "Double Cheeseburger",
      description:
      "Two layers of juicy beef with melted cheese, fresh lettuce, and tomatoes.",
      image: "http://sonic-zdi0.onrender.com/storage/products/double_cheese.jpg",
      rating: "4.8",
      price: "150.00",
      isFavorite: true,
    ),
  ];

  factory FavoriteModel.fromJson(Map<String, dynamic> json) {
    return FavoriteModel(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      image: json['image'] as String,
      rating: json['rating'] as String,
      price: json['price'] as String,
      isFavorite: json['is_favorite'] as bool,
    );
  }
}