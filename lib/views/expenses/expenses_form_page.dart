import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:vibbra_test/controllers/expense_controller.dart';
import 'package:vibbra_test/controllers/invoice_controller.dart';
import 'package:vibbra_test/models/expense.dart';
import 'package:vibbra_test/models/invoice.dart';
import 'package:vibbra_test/utils/routes.dart';
import 'package:vibbra_test/views/widgets/custom_checkbox_textfield.dart';
import 'package:vibbra_test/views/widgets/custom_datepicker_textfield.dart';
import 'package:vibbra_test/views/widgets/custom_dropdown_textfield.dart';
import 'package:vibbra_test/views/widgets/custom_outlined_textfield.dart';
import 'package:vibbra_test/models/error.dart';

class ExpensesFormPage extends StatefulWidget {
  const ExpensesFormPage({super.key});

  @override
  State<ExpensesFormPage> createState() => _ExpensesFormPageState();
}

class _ExpensesFormPageState extends State<ExpensesFormPage> {
  TextEditingController valueController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController paymentDateController = TextEditingController();
  TextEditingController competenseDateController = TextEditingController();

  bool _withCompany = false;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    var controller = context.read<ExpenseController>();
    if (controller.expenseEditing != null && mounted) {
      setState(() {
        _isEditing = true;
        valueController.text = controller.expenseEditing!.value.toString();
        nameController.text = controller.expenseEditing!.name;
        paymentDateController.text = controller.expenseEditing!.datePayment;
        competenseDateController.text =
            controller.expenseEditing!.dateCompetence;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Lançamento de despesa"),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Consumer<ExpenseController>(
            builder: ((context, controller, child) => Column(
                  children: [
                    Container(
                        margin: const EdgeInsets.only(bottom: 32),
                        padding: const EdgeInsets.only(top: 16),
                        child: const Text("Informações da despesa",
                            style: TextStyle(fontSize: 24))),
                    CustomOutlinedTextField(
                        controller: valueController,
                        prefixIcon: const Icon(Icons.attach_money),
                        label: "Valor da despesa",
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        keyboardType: TextInputType.number,
                        placeholder: "Digite o valor da despesa",
                        errors: controller.errors.errorsByCode("value")),
                    Container(
                        margin: const EdgeInsets.symmetric(vertical: 16),
                        child: CustomOutlinedTextField(
                            controller: nameController,
                            prefixIcon: const Icon(Icons.numbers),
                            label: "Nome da despesa",
                            placeholder: "Digite o nome da despesa",
                            errors: controller.errors.errorsByCode("name"))),
                    const SizedBox(
                      height: 16,
                    ),
                    CustomDatePickerTextField(
                      label: 'Data de pagamento',
                      placeholder: "Informe da data de pagamento",
                      controller: paymentDateController,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    CustomDatePickerTextField(
                      label: 'Data de competência',
                      placeholder: "Informe da data de competência",
                      controller: competenseDateController,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(
                              context, Routes.expensesSelectCompany);
                        },
                        child: const Text("Víncular com empresa parceira")),
                    controller.partner != null ||
                            (_isEditing &&
                                controller.expenseEditing != null &&
                                controller.expenseEditing!.company != null)
                        ? Column(
                            children: [
                              const Text("Vínculado com",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Text(_isEditing &&
                                      controller.expenseEditing != null &&
                                      controller.expenseEditing!.company != null
                                  ? "${controller.expenseEditing!.company!.name} - ${controller.expenseEditing!.company!.document}"
                                  : "${controller.partner!.name} - ${controller.partner!.document}")
                            ],
                          )
                        : Container(),
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
                                    if (nameController.text.isEmpty) {
                                      controller.addError(Error(
                                          code: 'name|required',
                                          message: "Nome é obrigatório"));
                                      return;
                                    }

                                    controller
                                        .submit(Expense(
                                      value: double.parse(valueController.text),
                                      name: nameController.text,
                                      datePayment: paymentDateController.text,
                                      dateCompetence:
                                          competenseDateController.text,
                                    ))
                                        .then((value) {
                                      if (value) {
                                        Navigator.pushNamedAndRemoveUntil(
                                            context,
                                            Routes.expenses,
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
                                    "${_isEditing ? 'EDITAR' : 'LANÇAR'} DESPESA")))
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
