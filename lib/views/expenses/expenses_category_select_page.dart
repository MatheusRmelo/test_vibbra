import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vibbra_test/controllers/expense_controller.dart';
import 'package:vibbra_test/controllers/invoice_controller.dart';
import 'package:vibbra_test/utils/routes.dart';
import 'package:vibbra_test/views/expenses/widgets/expense_category_select_card.dart';
import 'package:vibbra_test/views/expenses_categories/widgets/expense_category_card.dart';
import 'package:vibbra_test/views/invoices/widgets/invoice_company_card.dart';
import 'package:vibbra_test/views/widgets/custom_outlined_textfield.dart';
import 'package:vibbra_test/models/error.dart';

class ExpensesCategorySelectPage extends StatefulWidget {
  const ExpensesCategorySelectPage({super.key});

  @override
  State<ExpensesCategorySelectPage> createState() =>
      _ExpensesCategorySelectPageState();
}

class _ExpensesCategorySelectPageState
    extends State<ExpensesCategorySelectPage> {
  String _search = "";

  @override
  void initState() {
    super.initState();
    var controller = context.read<ExpenseController>();
    controller.getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseController>(
        builder: ((context, controller, child) => Scaffold(
              appBar: AppBar(
                elevation: 0,
                title: const Text("Lançamento de despesa"),
              ),
              body: Container(
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: Column(
                        children: [
                          Container(
                              margin: const EdgeInsets.only(bottom: 32),
                              padding: const EdgeInsets.only(top: 16),
                              child: const Text(
                                  "Escolha a categoria de despesa",
                                  style: TextStyle(fontSize: 24))),
                          CustomOutlinedTextField(
                              initialValue: _search,
                              onChanged: (String? value) {
                                setState(() {
                                  _search = value ?? "";
                                });
                                controller.handleSearchCategory(_search);
                              },
                              prefixIcon: const Icon(Icons.search),
                              label: "Pesquise a categoria",
                              placeholder:
                                  "Digite o nome ou descrição da categoria",
                              errors: controller.errors.errorsByCode("search")),
                          Expanded(
                              flex: 1,
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 16),
                                child: controller.isLoading
                                    ? const Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    : ListView.builder(
                                        itemCount: controller.expensesCategories
                                            .where((element) =>
                                                !(element.isHidden ?? false))
                                            .length,
                                        itemBuilder: (context, index) =>
                                            ExpenseCategorySelectCard(
                                                onClick: () {
                                                  controller.category = controller
                                                      .expensesCategories
                                                      .where((element) =>
                                                          !(element.isHidden ??
                                                              false))
                                                      .toList()[index];
                                                },
                                                category: controller
                                                    .expensesCategories
                                                    .where((element) =>
                                                        !(element.isHidden ??
                                                            false))
                                                    .toList()[index],
                                                isActive: controller.category ==
                                                        null
                                                    ? false
                                                    : controller.category!.id ==
                                                        controller
                                                            .expensesCategories
                                                            .where((element) =>
                                                                !(element
                                                                        .isHidden ??
                                                                    false))
                                                            .toList()[index]
                                                            .id),
                                      ),
                              )),
                        ],
                      )),
                ),
              ),
              floatingActionButton: FloatingActionButton(
                  backgroundColor:
                      controller.category == null || controller.isLoadingBtn
                          ? Colors.grey
                          : Theme.of(context).primaryColor,
                  onPressed:
                      controller.category == null || controller.isLoadingBtn
                          ? null
                          : () {
                              controller.expenseEditing = null;
                              Navigator.pushNamed(context, Routes.expensesForm);
                            },
                  child: Icon(
                    Icons.navigate_next,
                    color:
                        controller.category == null || controller.isLoadingBtn
                            ? Colors.white54
                            : Colors.white,
                  )),
            )));
  }
}
