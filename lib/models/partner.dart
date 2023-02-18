class Partner {
  String name;
  String document;
  String socialReason;

  Partner(
      {required this.name, required this.document, required this.socialReason});

  Partner.fromJson(Map<String, Object?> json)
      : this(
          name: json['name']! as String,
          document: json['document']! as String,
          socialReason: json['social_reason']! as String,
        );
  Map<String, Object?> toJson() {
    return {'name': name, 'document': document, 'social_reason': socialReason};
  }
}
