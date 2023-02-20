class Partner {
  String? id;
  String name;
  String document;
  String socialReason;

  Partner(
      {this.id = "",
      required this.name,
      required this.document,
      required this.socialReason});

  Partner.fromJson(Map<String, Object?> json, String id)
      : this(
          id: id,
          name: json['name']! as String,
          document: json['document']! as String,
          socialReason: json['social_reason']! as String,
        );
  Map<String, Object?> toJson() {
    return {'name': name, 'document': document, 'social_reason': socialReason};
  }
}
