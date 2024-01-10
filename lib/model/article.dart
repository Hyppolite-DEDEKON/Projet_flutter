// model/article.dart
class Article {
  String name;
  String category;
  int quantity;
  bool isBought;

  Article(
      {required this.name,
      required this.category,
      required this.quantity,
      this.isBought = false});

  // Ajoute ces méthodes pour sérialiser/désérialiser l'objet Article
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'category': category,
      'quantity': quantity,
      'isBought': isBought,
    };
  }

  factory Article.fromMap(Map<String, dynamic> map) {
    return Article(
      name: map['name'],
      category: map['category'],
      quantity: map['quantity'],
      isBought: map['isBought'],
    );
  }
}
