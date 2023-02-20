import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vibbra_test/controllers/invoice_controller.dart';
import 'package:vibbra_test/utils/routes.dart';
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
    var controller = context.read<InvoiceController>();
    controller.getInvoices();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<InvoiceController>(
        builder: ((context, controller, child) => Scaffold(
              appBar: AppBar(title: const Text("Notas fiscais")),
              body: controller.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : controller.invoices.isEmpty
                      ? Container(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                  "Você ainda não adicionou nenhuma nota fiscal",
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
                                      controller.invoiceEditing = null;
                                      Navigator.pushNamed(
                                          context, Routes.invoiceCompany);
                                    },
                                    child: const Text("Adicione nota fiscal")),
                              )
                            ],
                          ),
                        )
                      : Container(
                          padding: const EdgeInsets.all(16),
                          child: ListView.builder(
                            itemCount: controller.invoices.length,
                            itemBuilder: (context, index) => InvoiceCard(
                                invoice: controller.invoices[index],
                                isLoading:
                                    controller.isDeletingInvoicesIndex == index,
                                onDelete: () {
                                  controller.destroyInvoice(index);
                                },
                                onEdit: () {
                                  controller.invoiceEditing =
                                      controller.invoices[index];
                                  Navigator.pushNamed(
                                      context, Routes.invoiceForm);
                                }),
                          ),
                        ),
            )));
  }
}
