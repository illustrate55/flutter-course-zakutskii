class Drink {
  final String id;
  final String title;
  final String subtitle;
  final String description;
  final String category;
  final int coverColor; // Цвет обложки в формате ARGB (например, 0xFF0000FF)

  const Drink({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.category,
    required this.coverColor,
  });

  factory Drink.fromFirestore(Map<String, dynamic> json, String id) {
    return Drink(
      id: id,
      title: json['title'] ?? 'Без названия',
      subtitle: json['subtitle'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? 'Разное',
      coverColor: json['coverColor'] ?? 0xFF000000, 
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'subtitle': subtitle,
      'description': description,
      'category': category,
      'coverColor': coverColor,
    };
  }
}