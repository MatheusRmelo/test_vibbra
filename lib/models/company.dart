class Company {
  String name;
  String document;
  String phone;

  Company({required this.name, required this.document, required this.phone});

  Company.fromJson(Map<String, Object?> json)
      : this(
          name: json['name']! as String,
          document: json['document']! as String,
          phone: json['phone']! as String,
        );
  Map<String, Object?> toJson() {
    return {'name': name, 'document': document, 'phone': phone};
  }
}
