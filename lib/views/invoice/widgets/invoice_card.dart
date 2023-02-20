import 'package:flutter/material.dart';
import 'package:vibbra_test/models/invoice.dart';
import 'package:vibbra_test/models/partner.dart';

class InvoiceCard extends StatelessWidget {
  final Invoice invoice;
  final bool isLoading;
  final Function onDelete;
  final Function onEdit;
  const InvoiceCard(
      {super.key,
      this.isLoading = false,
      required this.invoice,
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
                  "${invoice.number.toString()} - R\$ ${invoice.value.toStringAsFixed(2)}",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  invoice.companyValue != null
                      ? "${invoice.companyValue!.name} - ${invoice.companyValue!.document}"
                      : "",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
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
                                  "Deseja excluir a nota fiscal ${invoice.number.toString()}?",
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
                                      child:
                                          const Text("Excluir a nota fiscal")),
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
