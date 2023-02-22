class SettingsVibbra {
  String? id;
  int limit;
  bool alertEmail;
  bool alertSMS;
  String phone;

  SettingsVibbra({
    this.id = "",
    required this.limit,
    required this.alertEmail,
    required this.alertSMS,
    required this.phone,
  });

  SettingsVibbra.fromJson(Map<String, Object?> json, String id)
      : this(
          id: id,
          limit: json['limit']! as int,
          alertEmail: json['alert_email']! as bool,
          alertSMS: json['alert_sms']! as bool,
          phone: json['phone']! as String,
        );
  Map<String, Object?> toJson() {
    return {
      'limit': limit,
      'phone': phone,
      'alert_email': alertEmail,
      'alert_sms': alertSMS
    };
  }
}
