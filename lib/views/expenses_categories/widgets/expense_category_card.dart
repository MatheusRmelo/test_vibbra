import 'package:flutter/material.dart';
import 'package:vibbra_test/models/expense_category.dart';

class ExpenseCategoryCard extends StatelessWidget {
  final ExpenseCategory expenseCategory;
  final bool isLoading;
  final Function onDelete;
  final Function onEdit;
  const ExpenseCategoryCard(
      {super.key,
      this.isLoading = false,
      required this.expenseCategory,
      required this.onEdit,
      required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
            color: const Color(0xFFEBEBEB),
            borderRadius: BorderRadius.circular(16)),
        child: Row(
          children: [
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  expenseCategory.name,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  expenseCategory.description,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(
                  height: 8,
                ),
                Chip(
                  label: Text(
                    expenseCategory.isDisabled ? 'Arquivada' : 'Ativa',
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor:
                      expenseCategory.isDisabled ? Colors.red : Colors.green,
                )
              ],
            )),
            isLoading
                ? const CircularProgressIndicator()
                : PopupMenuButton(
                    itemBuilder: (context) => const [
                      PopupMenuItem<int>(
                        value: 0,
                        child: Text("Editar",
                            style: TextStyle(color: Colors.black)),
                      ),
                      PopupMenuItem<int>(
                        value: 1,
                        child: Text("Excluir",
                            style: TextStyle(color: Colors.black)),
                      ),
                    ],
                    onSelected: (value) async {
                      if (value == 0) {
                        onEdit();
                      } else if (value == 1) {
                        await showDialog<String>(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: Text(
                                  "Deseja excluir a categoria de despesa ${expenseCategory.name.toUpperCase()}?",
                                  style: const TextStyle(color: Colors.black)),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Cancelar",
                                        style: TextStyle(color: Colors.red))),
                                SizedBox(
                                  height: 40,
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                      ),
                                      onPressed: () {
                                        onDelete();
                                        Navigator.pop(context);
                                      },
                                      child: const Text("Excluir categoria")),
                                )
                              ],
                            );
                          },
                        );
                      }
                    },
                  ),
          ],
        ));
  }
}
