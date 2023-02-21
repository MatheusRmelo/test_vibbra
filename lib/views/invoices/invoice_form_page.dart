import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:vibbra_test/controllers/company_controller.dart';
import 'package:vibbra_test/controllers/invoice_controller.dart';
import 'package:vibbra_test/controllers/partner_controller.dart';
import 'package:vibbra_test/models/company.dart';
import 'package:vibbra_test/models/invoice.dart';
import 'package:vibbra_test/models/partner.dart';
import 'package:vibbra_test/utils/inputs_formatters/cnpj_input_formatter.dart';
import 'package:vibbra_test/utils/inputs_formatters/phone_input_formatter.dart';
import 'package:vibbra_test/utils/routes.dart';
import 'package:vibbra_test/views/widgets/custom_datepicker_textfield.dart';
import 'package:vibbra_test/views/widgets/custom_dropdown_textfield.dart';
import 'package:vibbra_test/views/widgets/custom_outlined_textfield.dart';
import 'package:vibbra_test/models/error.dart';

class InvoiceFormPage extends StatefulWidget {
  const InvoiceFormPage({super.key});

  @override
  State<InvoiceFormPage> createState() => _InvoiceFormPageState();
}

class _InvoiceFormPageState extends State<InvoiceFormPage> {
  TextEditingController valueController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController receiveDateController = TextEditingController();
  List<String> months = [
    "Janeiro",
    "Feveiro",
    "Março",
    "Abril",
    "Main",
    "Junho",
    "Julho",
    "Agosto",
    "Setembro",
    "Outubro",
    "Novembro",
    "Dezembro"
  ];
  String month = "Janeiro";
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    var controller = context.read<InvoiceController>();
    if (controller.invoiceEditing != null && mounted) {
      setState(() {
        _isEditing = true;
        valueController.text = controller.invoiceEditing!.value.toString();
        numberController.text = controller.invoiceEditing!.number.toString();
        descriptionController.text = controller.invoiceEditing!.description;
        receiveDateController.text = controller.invoiceEditing!.receiveDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Lançamento de nota fiscal"),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Consumer<InvoiceController>(
            builder: ((context, controller, child) => Column(
                  children: [
                    Container(
                        margin: const EdgeInsets.only(bottom: 32),
                        padding: const EdgeInsets.only(top: 16),
                        child: const Text("Informações da nota fiscal",
                            style: TextStyle(fontSize: 24))),
                    CustomOutlinedTextField(
                        controller: valueController,
                        prefixIcon: const Icon(Icons.attach_money),
                        label: "Valor da nota",
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        keyboardType: TextInputType.number,
                        placeholder: "Digite o valor da nota",
                        errors: controller.errors.errorsByCode("value")),
                    Container(
                        margin: const EdgeInsets.symmetric(vertical: 16),
                        child: CustomOutlinedTextField(
                            controller: numberController,
                            prefixIcon: const Icon(Icons.numbers),
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            keyboardType: TextInputType.number,
                            label: "Número da nota fiscal",
                            placeholder: "Digite o número da nota fiscal",
                            errors: controller.errors.errorsByCode("number"))),
                    CustomOutlinedTextField(
                        controller: descriptionController,
                        prefixIcon: const Icon(Icons.feed),
                        label: "Descrição do serviço prestado",
                        placeholder: "Digite a descrição do serviço prestado",
                        errors: controller.errors.errorsByCode("description")),
                    const SizedBox(
                      height: 16,
                    ),
                    // CustomDropdownTextField(
                    //   label: 'Mês de competência',
                    //   list: months,
                    //   value: month,
                    //   onChanged: (String? value) {
                    //     if (value != null) {
                    //       setState(() {
                    //         month = value;
                    //       });
                    //     }
                    //   },
                    // ),
                    const SizedBox(
                      height: 16,
                    ),
                    CustomDatePickerTextField(
                      label: 'Data do recebimento',
                      placeholder: "Digite a data do recebimento",
                      controller: receiveDateController,
                    ),
                    Container(
                        width: double.infinity,
                        height: 48,
                        margin: const EdgeInsets.only(top: 40),
                        child: ElevatedButton(
                            onPressed: controller.isLoadingBtn
                                ? null
                                : () {
                                    controller.cleanErrors();
                                    if (valueController.text.isEmpty) {
                                      controller.addError(Error(
                                          code: 'value|required',
                                          message: "Valor é obrigatório"));
                                      return;
                                    }
                                    if (numberController.text.isEmpty) {
                                      controller.addError(Error(
                                          code: 'number|required',
                                          message:
                                              "Número da nota fiscal é obrigatório"));
                                      return;
                                    }

                                    controller
                                        .submit(Invoice(
                                            value: double.parse(
                                                valueController.text),
                                            number: int.parse(
                                                numberController.text),
                                            month: DateTime.parse(
                                                    receiveDateController.text)
                                                .month,
                                            receiveDate:
                                                receiveDateController.text,
                                            description:
                                                descriptionController.text))
                                        .then((value) {
                                      if (value) {
                                        Navigator.pushNamedAndRemoveUntil(
                                            context,
                                            Routes.invoiceList,
                                            (route) =>
                                                route.settings.name ==
                                                Routes.home);
                                      }
                                    });
                                  },
                            child: controller.isLoadingBtn
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
                                : Text(
                                    "${_isEditing ? 'EDITAR' : 'LANÇAR'} NOTA FISCAL")))
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
