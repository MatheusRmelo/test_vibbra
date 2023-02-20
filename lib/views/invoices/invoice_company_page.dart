import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vibbra_test/controllers/expense_category_controller.dart';
import 'package:vibbra_test/controllers/invoice_controller.dart';
import 'package:vibbra_test/models/expense_category.dart';
import 'package:vibbra_test/utils/routes.dart';
import 'package:vibbra_test/views/invoices/widgets/invoice_company_card.dart';
import 'package:vibbra_test/views/widgets/custom_checkbox_textfield.dart';
import 'package:vibbra_test/views/widgets/custom_outlined_textfield.dart';
import 'package:vibbra_test/models/error.dart';

class InvoiceCompanyPage extends StatefulWidget {
  const InvoiceCompanyPage({super.key});

  @override
  State<InvoiceCompanyPage> createState() => _InvoiceCompanyPageState();
}

class _InvoiceCompanyPageState extends State<InvoiceCompanyPage> {
  String _search = "";

  @override
  void initState() {
    super.initState();
    var controller = context.read<InvoiceController>();
    controller.getPartners();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<InvoiceController>(
        builder: ((context, controller, child) => Scaffold(
              appBar: AppBar(
                elevation: 0,
                title: const Text("Lançamento de nota fiscal"),
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
                              child: const Text("Escolha a empresa",
                                  style: TextStyle(fontSize: 24))),
                          CustomOutlinedTextField(
                              initialValue: _search,
                              onChanged: (String? value) {
                                setState(() {
                                  _search = value ?? "";
                                });
                                controller.handleSearchPartner(_search);
                              },
                              prefixIcon: const Icon(Icons.search),
                              label: "Pesquise a empresa",
                              placeholder: "Digite o nome ou CNPJ da empresa",
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
                                        itemCount: controller.partners
                                            .where((element) =>
                                                !(element.isHidden ?? false))
                                            .length,
                                        itemBuilder: (context, index) =>
                                            InvoiceCompanyCard(
                                                onClick: () {
                                                  controller.partner = controller
                                                      .partners
                                                      .where((element) =>
                                                          !(element.isHidden ??
                                                              false))
                                                      .toList()[index];
                                                },
                                                partner: controller.partners
                                                    .where((element) =>
                                                        !(element.isHidden ??
                                                            false))
                                                    .toList()[index],
                                                isActive: controller.partner ==
                                                        null
                                                    ? false
                                                    : controller.partner!.id ==
                                                        controller.partners
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
                      controller.partner == null || controller.isLoadingBtn
                          ? Colors.grey
                          : Theme.of(context).primaryColor,
                  onPressed:
                      controller.partner == null || controller.isLoadingBtn
                          ? null
                          : () {
                              controller.invoiceEditing = null;
                              Navigator.pushNamed(context, Routes.invoiceForm);
                            },
                  child: Icon(
                    Icons.navigate_next,
                    color: controller.partner == null || controller.isLoadingBtn
                        ? Colors.white54
                        : Colors.white,
                  )),
            )));
  }
}
