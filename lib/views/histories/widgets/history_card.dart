import 'package:flutter/material.dart';
import 'package:vibbra_test/models/history.dart';

class HistoryCard extends StatelessWidget {
  final History history;
  const HistoryCard({super.key, required this.history});

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
            Container(
              margin: const EdgeInsets.only(right: 16),
              child: Icon(history.type == LaunchType.invoice
                  ? Icons.list_alt
                  : Icons.payments),
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  history.title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  history.subTitle,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            )),
            Chip(
                backgroundColor: history.type == LaunchType.expense
                    ? Colors.red
                    : Colors.green,
                label: Text(
                  history.type == LaunchType.expense
                      ? "Despesa"
                      : "Nota fiscal",
                  style: const TextStyle(color: Colors.white),
                ))
          ],
        ));
  }
}
