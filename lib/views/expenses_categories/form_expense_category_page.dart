import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vibbra_test/controllers/expense_category_controller.dart';
import 'package:vibbra_test/models/expense_category.dart';
import 'package:vibbra_test/views/widgets/custom_checkbox_textfield.dart';
import 'package:vibbra_test/views/widgets/custom_outlined_textfield.dart';
import 'package:vibbra_test/models/error.dart';

class FormExpenseCategoryPage extends StatefulWidget {
  const FormExpenseCategoryPage({super.key});

  @override
  State<FormExpenseCategoryPage> createState() =>
      _FormExpenseCategoryPageState();
}

class _FormExpenseCategoryPageState extends State<FormExpenseCategoryPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController socialReason = TextEditingController();
  bool _isDisabled = false;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    var controller = context.read<ExpenseCategoryController>();
    if (controller.expenseCategoryEditing != null && mounted) {
      setState(() {
        _isEditing = true;
        nameController.text = controller.expenseCategoryEditing!.name;
        descriptionController.text =
            controller.expenseCategoryEditing!.description;
        _isDisabled = controller.expenseCategoryEditing!.isDisabled;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Consumer<ExpenseCategoryController>(
            builder: ((context, controller, child) => Column(
                  children: [
                    Container(
                        margin: const EdgeInsets.only(bottom: 32),
                        padding: const EdgeInsets.only(top: 16),
                        child: Text(
                            "${_isEditing ? 'Edite' : 'Cadastrar'} uma categoria de despesa",
                            style: const TextStyle(fontSize: 24))),
                    CustomOutlinedTextField(
                        controller: nameController,
                        prefixIcon: const Icon(Icons.person),
                        label: "Nome",
                        placeholder: "Digite o nome",
                        errors: controller.errors.errorsByCode("name")),
                    Container(
                        margin: const EdgeInsets.symmetric(vertical: 16),
                        child: CustomOutlinedTextField(
                            controller: descriptionController,
                            prefixIcon: const Icon(Icons.description),
                            label: "Descrição",
                            placeholder: "Digite uma descrição",
                            errors:
                                controller.errors.errorsByCode("description"))),
                    CustomCheckboxTextField(
                        isActive: _isDisabled,
                        label: "Arquivado",
                        onChanged: (bool value) {
                          setState(() => _isDisabled = value);
                        }),
                    Container(
                        width: double.infinity,
                        height: 48,
                        margin: const EdgeInsets.only(top: 40),
                        child: ElevatedButton(
                            onPressed: controller.isLoading
                                ? null
                                : () {
                                    controller
                                        .submit(ExpenseCategory(
                                            name: nameController.text,
                                            description:
                                                descriptionController.text,
                                            isDisabled: _isDisabled))
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
                                : Text(
                                    "${_isEditing ? 'EDITAR' : 'CADASTRAR'} CATEGORIA DE DESPESA")))
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
