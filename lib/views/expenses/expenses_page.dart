import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vibbra_test/controllers/expense_controller.dart';
import 'package:vibbra_test/controllers/invoice_controller.dart';
import 'package:vibbra_test/utils/routes.dart';
import 'package:vibbra_test/views/expenses/widgets/expense_card.dart';
import 'package:vibbra_test/views/invoices/widgets/invoice_card.dart';

class ExpensesPage extends StatefulWidget {
  const ExpensesPage({super.key});

  @override
  State<ExpensesPage> createState() => _ExpensesPageState();
}

class _ExpensesPageState extends State<ExpensesPage> {
  @override
  void initState() {
    super.initState();
    var controller = context.read<ExpenseController>();
    controller.getExpenses();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseController>(
        builder: ((context, controller, child) => Scaffold(
              appBar: AppBar(title: const Text("Despesas")),
              body: controller.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : controller.expenses.isEmpty
                      ? Container(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                  "Você ainda não adicionou nenhuma despesa",
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
                                      controller.expenseEditing = null;
                                      Navigator.pushNamed(context,
                                          Routes.expensesSelectCategory);
                                    },
                                    child: const Text("Adicione uma despesa")),
                              )
                            ],
                          ),
                        )
                      : Container(
                          padding: const EdgeInsets.all(16),
                          child: ListView.builder(
                            itemCount: controller.expenses.length,
                            itemBuilder: (context, index) => ExpenseCard(
                                expense: controller.expenses[index],
                                isLoading:
                                    controller.isDeletingInvoicesIndex == index,
                                onDelete: () {
                                  controller.destroyInvoice(index);
                                },
                                onEdit: () {
                                  controller.expenseEditing =
                                      controller.expenses[index];
                                  Navigator.pushNamed(
                                      context, Routes.expensesForm);
                                }),
                          ),
                        ),
            )));
  }
}
