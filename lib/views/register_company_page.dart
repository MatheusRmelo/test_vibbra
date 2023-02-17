import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:vibbra_test/controllers/company_controller.dart';
import 'package:vibbra_test/models/company.dart';
import 'package:vibbra_test/utils/inputs_formatters/cnpj_input_formatter.dart';
import 'package:vibbra_test/utils/inputs_formatters/phone_input_formatter.dart';
import 'package:vibbra_test/utils/routes.dart';
import 'package:vibbra_test/views/widgets/custom_outlined_textfield.dart';
import 'package:vibbra_test/models/error.dart';

class RegisterCompanyPage extends StatefulWidget {
  const RegisterCompanyPage({super.key});

  @override
  State<RegisterCompanyPage> createState() => _RegisterCompanyPageState();
}

class _RegisterCompanyPageState extends State<RegisterCompanyPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController documentController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        actions: [TextButton(onPressed: () {}, child: const Text("Sair"))],
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Consumer<CompanyController>(
            builder: ((context, controller, child) => Column(
                  children: [
                    Container(
                        margin: const EdgeInsets.only(bottom: 32),
                        padding: const EdgeInsets.only(top: 16),
                        child: const Text("Cadastre sua empresa",
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
                        controller: phoneController,
                        prefixIcon: const Icon(Icons.phone),
                        keyboardType: TextInputType.phone,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                          PhoneInputFormatter()
                        ],
                        label: "Telefone",
                        placeholder: "Digite o seu telefone",
                        errors: controller.errors.errorsByCode("phone")),
                    Container(
                        width: double.infinity,
                        height: 48,
                        margin: const EdgeInsets.only(top: 40),
                        child: ElevatedButton(
                            onPressed: controller.isLoading
                                ? null
                                : () {
                                    controller
                                        .store(Company(
                                            name: nameController.text,
                                            document: documentController.text,
                                            phone: phoneController.text))
                                        .then((value) {
                                      if (value) {
                                        Navigator.pushNamedAndRemoveUntil(
                                            context,
                                            Routes.home,
                                            (route) => false);
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
                                : const Text("CADASTRAR EMPRESA")))
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
