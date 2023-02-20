class ExpenseCategory {
  String? id;
  String name;
  String description;
  bool isDisabled;

  ExpenseCategory(
      {this.id,
      required this.name,
      required this.description,
      required this.isDisabled});

  ExpenseCategory.fromJson(Map<String, Object?> json, String id)
      : this(
          id: id,
          name: json['name']! as String,
          description: json['description']! as String,
          isDisabled: json['is_disabled']! as bool,
        );
  Map<String, Object?> toJson() {
    return {
      'name': name,
      'description': description,
      'is_disabled': isDisabled
    };
  }
}
