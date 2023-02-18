import 'package:flutter/material.dart';
import 'package:vibbra_test/models/partner.dart';

class PartnerCard extends StatelessWidget {
  final Partner partner;
  final Function onDelete;
  final Function onEdit;
  const PartnerCard(
      {super.key,
      required this.partner,
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
                  partner.document,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  partner.name,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 16,
                ),
                Text(
                  partner.socialReason,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            )),
            PopupMenuButton(
              itemBuilder: (context) => const [
                PopupMenuItem<int>(
                  value: 0,
                  child: Text("Editar", style: TextStyle(color: Colors.black)),
                ),
                PopupMenuItem<int>(
                  value: 1,
                  child: Text("Excluir", style: TextStyle(color: Colors.black)),
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
                        backgroundColor:
                            Theme.of(context).colorScheme.secondary,
                        content: Text(
                            "Deseja excluir a empresa parceira ${partner.name}?",
                            style: const TextStyle(color: Colors.black)),
                        actions: [
                          TextButton(
                              onPressed: () {
                                onDelete();
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
                                  Navigator.pop(context);
                                },
                                child: const Text("Excluir atividade")),
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
