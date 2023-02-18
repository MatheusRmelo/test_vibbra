import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:vibbra_test/controllers/company_controller.dart';
import 'package:vibbra_test/controllers/partner_controller.dart';
import 'package:vibbra_test/models/company.dart';
import 'package:vibbra_test/models/partner.dart';
import 'package:vibbra_test/utils/inputs_formatters/cnpj_input_formatter.dart';
import 'package:vibbra_test/utils/inputs_formatters/phone_input_formatter.dart';
import 'package:vibbra_test/views/widgets/custom_outlined_textfield.dart';
import 'package:vibbra_test/models/error.dart';

class CreatePartnerPage extends StatefulWidget {
  const CreatePartnerPage({super.key});

  @override
  State<CreatePartnerPage> createState() => _CreatePartnerPageState();
}

class _CreatePartnerPageState extends State<CreatePartnerPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController documentController = TextEditingController();
  TextEditingController socialReason = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Consumer<PartnerController>(
            builder: ((context, controller, child) => Column(
                  children: [
                    Container(
                        margin: const EdgeInsets.only(bottom: 32),
                        padding: const EdgeInsets.only(top: 16),
                        child: const Text("Cadastre uma empresa parceira",
                            style: TextStyle(fontSize: 24))),
                    CustomOutlinedTextField(
                        controller: documentController,
                        prefixIcon: const Icon(Icons.business),
                        label: "CNPJ",
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                          CnpjInputFormatter()
                        ],
                        keyboardType: TextInputType.number,
                        placeholder: "Digite o seu CNPJ",
                        errors: controller.errors.errorsByCode("document")),
                    Container(
                        margin: const EdgeInsets.symmetric(vertical: 16),
                        child: CustomOutlinedTextField(
                            controller: nameController,
                            prefixIcon: const Icon(Icons.badge),
                            label: "Nome da empresa",
                            placeholder: "Digite o nome da empresa",
                            errors: controller.errors.errorsByCode("name"))),
                    CustomOutlinedTextField(
                        controller: socialReason,
                        prefixIcon: const Icon(Icons.feed),
                        label: "Razão social",
                        placeholder: "Digite a razão social",
                        errors:
                            controller.errors.errorsByCode("social_reason")),
                    Container(
                        width: double.infinity,
                        height: 48,
                        margin: const EdgeInsets.only(top: 40),
                        child: ElevatedButton(
                            onPressed: controller.isLoading
                                ? null
                                : () {
                                    controller
                                        .store(Partner(
                                            name: nameController.text,
                                            document: documentController.text,
                                            socialReason: socialReason.text))
                                        .then((value) {
                                      if (value) {
                                        Navigator.pop(context);
                                      }
                                    });
                                  },
                            child: controller.isLoading
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                            style:
                                                TextStyle(color: Colors.white))
                                      ])
                                : const Text("CADASTRAR EMPRESA PARCEIRA")))
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
