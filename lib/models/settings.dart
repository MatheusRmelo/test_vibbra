class SettingsVibbra {
  String? id;
  int limit;
  bool alertEmail;
  bool alertSMS;

  SettingsVibbra(
      {this.id = "",
      required this.limit,
      required this.alertEmail,
      required this.alertSMS});

  SettingsVibbra.fromJson(Map<String, Object?> json, String id)
      : this(
          id: id,
          limit: json['limit']! as int,
          alertEmail: json['alert_email']! as bool,
          alertSMS: json['alert_sms']! as bool,
        );
  Map<String, Object?> toJson() {
    return {'limit': limit, 'alert_email': alertEmail, 'alert_sms': alertSMS};
  }
}
