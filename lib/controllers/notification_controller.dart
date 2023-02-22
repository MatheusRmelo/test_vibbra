import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:vibbra_test/models/invoice.dart';
import 'package:vibbra_test/models/settings.dart';
import 'package:vibbra_test/utils/constants.dart';

class NotificationController extends ChangeNotifier {
  void checkLimitMail(
      {required SettingsVibbra? settings, required List<Invoice> invoices}) {
    int day = DateTime.now().day;

    double totalInvoices = 0;
    for (var element in invoices) {
      totalInvoices += element.value;
    }
    if (settings == null) {
      return;
    }
    double percent = (totalInvoices / settings.limit) * 100;

    if (day == 1) {
      if (settings.alertEmail) {
        sendEmailAlert(
            subject: "Limite de emissão para ser MEI",
            message:
                "Você pode emitir até ${settings.limit - totalInvoices} para continuar como MEI");
      }
      if (settings.alertSMS) {
        // sendSMSAlert(
        //     phone: settings.phone,
        //     message:
        //         "Voce pode emitir ate ${settings.limit - totalInvoices} para continuar como MEI");
      }
    } else if (percent >= 80) {
      if (settings.alertEmail) {
        sendEmailAlert(
            subject: "Cuidado com o limite de faturamento do MEI",
            message:
                "Porcentagem atual é $percent porcento para passar o limite MEI");
      }
      if (settings.alertSMS) {
        // sendSMSAlert(
        //     phone: settings.phone,
        //     message:
        //         "Porcentagem atual é $percent porcento para passar o limite MEI");
      }
    }
  }

  String _getBasicToken() {
    String credentials =
        "${APIConstants.clickSendUsername}:${APIConstants.clickSendKey}";
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    return stringToBase64.encode(credentials);
  }

  Future<bool> sendEmailAlert(
      {String subject = "Próximo ao limite de faturamento do MEI",
      String message =
          "Cuidado falta apenas 20 porcento para passar o limite MEI"}) async {
    Uri url = Uri.parse('${APIConstants.clickSendUrl}/v3/email/send');
    http.Response result = await http.post(url,
        body: jsonEncode({
          "to": [
            {
              "email": FirebaseAuth.instance.currentUser!.email,
              "name": FirebaseAuth.instance.currentUser!.displayName
            }
          ],
          "from": {
            "email_address_id": APIConstants.clickSendEmailId,
            "name": "Alerta MEI"
          },
          "subject": subject,
          "body": message,
        }),
        headers: {
          'Authorization': 'Basic ${_getBasicToken()}',
          'Content-Type': 'application/json'
        });
    return result.statusCode == 200;
  }

  Future<bool> sendSMSAlert(
      {required String phone,
      String message =
          "Cuidado falta apenas 20 porcento para passar o limite MEI"}) async {
    Uri url = Uri.parse('${APIConstants.clickSendUrl}/v3/sms/send');
    http.Response result = await http.post(url,
        body: jsonEncode({
          "messages": [
            {"source": "Vibbra APP", "body": message, "to": "+55$phone"},
          ]
        }),
        headers: {
          'Authorization': 'Basic ${_getBasicToken()}',
          'Content-Type': 'application/json'
        });
    return result.statusCode == 200;
  }
}
