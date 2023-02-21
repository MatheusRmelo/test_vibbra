import 'package:flutter/material.dart';
import 'package:vibbra_test/models/expense_category.dart';

class ExpenseCategorySelectCard extends StatelessWidget {
  final ExpenseCategory category;
  final bool isActive;
  final Function onClick;
  const ExpenseCategorySelectCard(
      {super.key,
      this.isActive = false,
      required this.category,
      required this.onClick});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onClick();
      },
      child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
              color: isActive
                  ? Theme.of(context).primaryColor
                  : const Color(0xFFEBEBEB),
              borderRadius: BorderRadius.circular(16)),
          child: Row(
            children: [
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category.name,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isActive ? Colors.white : Colors.black),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    category.description,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isActive ? Colors.white : Colors.black),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                ],
              )),
            ],
          )),
    );
  }
}
