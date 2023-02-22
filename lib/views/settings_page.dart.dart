import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:vibbra_test/controllers/expense_category_controller.dart';
import 'package:vibbra_test/controllers/settings_controller.dart';
import 'package:vibbra_test/models/expense_category.dart';
import 'package:vibbra_test/models/settings.dart';
import 'package:vibbra_test/views/widgets/custom_checkbox_textfield.dart';
import 'package:vibbra_test/views/widgets/custom_outlined_textfield.dart';
import 'package:vibbra_test/models/error.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  TextEditingController limitController = TextEditingController(text: "81000");
  TextEditingController phoneController = TextEditingController(text: "");

  bool _alertInEmail = false;
  bool _alertInSMS = false;

  @override
  void initState() {
    super.initState();
    var controller = context.read<SettingsController>();
    controller.get().then((value) {
      if (mounted && controller.settings != null) {
        setState(() {
          limitController.text = controller.settings!.limit.toString();
          _alertInEmail = controller.settings!.alertEmail;
          _alertInSMS = controller.settings!.alertSMS;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Consumer<SettingsController>(
        builder: ((context, controller, child) => controller.isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Column(
                children: [
                  const SizedBox(
                    height: 32,
                  ),
                  CustomOutlinedTextField(
                      controller: limitController,
                      prefixIcon: const Icon(Icons.attach_money),
                      label: "Limite máximo de faturamento",
                      placeholder: "Digite o limite máximo de faturamento",
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      errors: controller.errors.errorsByCode("limit")),
                  const SizedBox(
                    height: 16,
                  ),
                  CustomOutlinedTextField(
                      controller: phoneController,
                      prefixIcon: const Icon(Icons.phone),
                      label: "Telefone para alerta",
                      placeholder: "Digite o seu telefone com DD",
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      errors: controller.errors.errorsByCode("phone")),
                  Container(
                      margin: const EdgeInsets.symmetric(vertical: 16),
                      child: const Divider()),
                  const Text("Alerta de faturamento",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(
                    height: 16,
                  ),
                  CustomCheckboxTextField(
                      isActive: _alertInEmail,
                      label: "E-mail",
                      onChanged: (bool value) {
                        setState(() => _alertInEmail = value);
                      }),
                  CustomCheckboxTextField(
                      isActive: _alertInSMS,
                      label: "SMS",
                      onChanged: (bool value) {
                        setState(() => _alertInSMS = value);
                      }),
                  Container(
                      width: double.infinity,
                      height: 48,
                      margin: const EdgeInsets.only(top: 40),
                      child: ElevatedButton(
                          onPressed: controller.isLoadingBtn
                              ? null
                              : () {
                                  if (limitController.text.isEmpty) {
                                    controller.addError(Error(
                                        code: 'limit|required',
                                        message: "Limite é obrigatório"));
                                    return;
                                  }

                                  controller
                                      .submit(SettingsVibbra(
                                          limit:
                                              int.parse(limitController.text),
                                          phone: phoneController.text,
                                          alertEmail: _alertInEmail,
                                          alertSMS: _alertInSMS))
                                      .then((value) {
                                    if (value) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              backgroundColor: Colors.green,
                                              content: Text(
                                                  "Sucesso ao salvar configuração")));
                                    }
                                  });
                                },
                          child: controller.isLoadingBtn
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: const [
                                      SizedBox(
                                        height: 24,
                                        width: 24,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 16,
                                      ),
                                      Text("Carregando...",
                                          style: TextStyle(color: Colors.white))
                                    ])
                              : const Text("SALVAR CONFIGURAÇÕES")))
                ],
              ))),
      ),
    );
  }
}
