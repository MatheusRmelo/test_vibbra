import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vibbra_test/controllers/expense_category_controller.dart';
import 'package:vibbra_test/controllers/partner_controller.dart';
import 'package:vibbra_test/utils/routes.dart';
import 'package:vibbra_test/views/expenses_categories/widgets/expense_category_card.dart';
import 'package:vibbra_test/views/partners/widgets/partner_card.dart';

class ListExpensesCategories extends StatefulWidget {
  const ListExpensesCategories({super.key});

  @override
  State<ListExpensesCategories> createState() => _ListExpensesCategoriesState();
}

class _ListExpensesCategoriesState extends State<ListExpensesCategories> {
  @override
  void initState() {
    super.initState();
    var controller = context.read<ExpenseCategoryController>();
    controller.getExpensesCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseCategoryController>(
        builder: ((context, controller, child) => Scaffold(
              body: controller.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : controller.expensesCategories.isEmpty
                      ? Container(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                  "Você ainda não adicionou nenhuma categoria de despesa",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              Container(
                                width: double.infinity,
                                height: 40,
                                margin: const EdgeInsets.only(top: 16),
                                child: ElevatedButton(
                                    onPressed: () {
                                      controller.expenseCategoryEditing = null;
                                      Navigator.pushNamed(context,
                                          Routes.expensesCategoriesForm);
                                    },
                                    child: const Text(
                                        "Adicione uma categoria de despesa")),
                              )
                            ],
                          ),
                        )
                      : Container(
                          padding: const EdgeInsets.all(16),
                          child: ListView.builder(
                            itemCount: controller.expensesCategories.length,
                            itemBuilder: (context, index) =>
                                ExpenseCategoryCard(
                                    expenseCategory:
                                        controller.expensesCategories[index],
                                    isLoading:
                                        controller.isDeletingIndex == index,
                                    onDelete: () {
                                      controller.destroyPartner(index);
                                    },
                                    onEdit: () {
                                      controller.expenseCategoryEditing =
                                          controller.expensesCategories[index];
                                      Navigator.pushNamed(context,
                                          Routes.expensesCategoriesForm);
                                    }),
                          ),
                        ),
              floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    controller.expenseCategoryEditing = null;
                    Navigator.pushNamed(context, Routes.expensesCategoriesForm);
                  },
                  child: const Icon(Icons.add)),
            )));
  }
}
