class CategoryEntity{
  String categoryId;
  String name;
  int totalExpenses;
  String icon;
  String color;

  CategoryEntity({
    required this.categoryId,
    required this.name,
    required this.totalExpenses,
    required this.icon,
    required this.color
  });

  Map<String, Object> toDocument() {
    return {
      'categoryId': categoryId,
      'name': name,
      'totalExpenses': totalExpenses,
      'icon': icon,
      'color': color,
    };
  }

  static CategoryEntity fromDocument(Map<String, Object> doc) {
    return CategoryEntity(
      categoryId: doc['categoryId'] as String,
      name: doc['name'] as String,
      totalExpenses: doc['totalExpenses'] as int,
      icon: doc['icon'] as String,
      color: doc['color'] as String,
    );
  }
}