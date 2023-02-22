import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vibbra_test/controllers/histories_controller.dart';
import 'package:vibbra_test/views/histories/widgets/history_card.dart';

class HistoriesPage extends StatefulWidget {
  const HistoriesPage({super.key});

  @override
  State<HistoriesPage> createState() => _HistoriesPageState();
}

class _HistoriesPageState extends State<HistoriesPage> {
  @override
  void initState() {
    super.initState();
    var controller = context.read<HistoriesController>();
    controller.getHistories();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HistoriesController>(
        builder: ((context, controller, child) => Scaffold(
              appBar: AppBar(title: const Text("Histórico de lançamentos")),
              body: controller.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : controller.histories.isEmpty
                      ? Container(
                          padding: const EdgeInsets.all(16),
                          child: const Text(
                              "Você ainda não lançou nenhuma informação",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                        )
                      : Container(
                          padding: const EdgeInsets.all(16),
                          child: ListView.builder(
                            itemCount: controller.histories.length,
                            itemBuilder: (context, index) => HistoryCard(
                              history: controller.histories[index],
                            ),
                          ),
                        ),
            )));
  }
}
