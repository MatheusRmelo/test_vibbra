import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vibbra_test/controllers/partner_controller.dart';
import 'package:vibbra_test/utils/routes.dart';
import 'package:vibbra_test/views/partners/widgets/partner_card.dart';

class ListPartnersPage extends StatefulWidget {
  const ListPartnersPage({super.key});

  @override
  State<ListPartnersPage> createState() => _ListPartnersPageState();
}

class _ListPartnersPageState extends State<ListPartnersPage> {
  @override
  void initState() {
    super.initState();
    var controller = context.read<PartnerController>();
    controller.getPartners();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PartnerController>(
        builder: ((context, controller, child) => Scaffold(
              body: controller.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : controller.partners.isEmpty
                      ? Container(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                  "Você ainda não adicionou nenhuma empresa parceira",
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
                                      controller.partnerEditing = null;
                                      Navigator.pushNamed(
                                          context, Routes.partnersForm);
                                    },
                                    child: const Text(
                                        "Adicione empresa parceira")),
                              )
                            ],
                          ),
                        )
                      : Container(
                          padding: const EdgeInsets.all(16),
                          child: ListView.builder(
                            itemCount: controller.partners.length,
                            itemBuilder: (context, index) => PartnerCard(
                                partner: controller.partners[index],
                                isLoading: controller.isDeletingIndex == index,
                                onDelete: () {
                                  controller.destroyPartner(index);
                                },
                                onEdit: () {
                                  controller.partnerEditing =
                                      controller.partners[index];
                                  Navigator.pushNamed(
                                      context, Routes.partnersForm);
                                }),
                          ),
                        ),
              floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    controller.partnerEditing = null;
                    Navigator.pushNamed(context, Routes.partnersForm);
                  },
                  child: const Icon(Icons.add)),
            )));
  }
}
