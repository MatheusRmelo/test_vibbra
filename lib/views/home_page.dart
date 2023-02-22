import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:speed_dial_fab/speed_dial_fab.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'package:vibbra_test/controllers/company_controller.dart';
import 'package:vibbra_test/controllers/home_controller.dart';
import 'package:vibbra_test/models/expense.dart';
import 'package:vibbra_test/models/invoice.dart';
import 'package:vibbra_test/utils/routes.dart';
import 'package:vibbra_test/views/widgets/custom_datepicker_textfield.dart';
import 'package:vibbra_test/views/widgets/custom_yearpicker_textfield.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoading = true;
  int _year = DateTime.now().year;

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        Navigator.pushNamedAndRemoveUntil(
            context, Routes.signIn, (route) => false);
      } else {
        initialize();
      }
    });
  }

  Future<void> initialize() async {
    setState(() => _isLoading = true);
    var homeController = context.read<HomeController>();
    await homeController.getInvoices(year: _year);
    await homeController.getExpenses(year: _year);
    await homeController.getSettings();
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeController>(
        builder: ((context, controller, child) => Scaffold(
              appBar: AppBar(actions: [
                IconButton(
                    onPressed: () {
                      initialize();
                    },
                    icon: const Icon(Icons.refresh)),
                IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, Routes.histories);
                    },
                    icon: const Icon(Icons.restore)),
                IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, Routes.preferences);
                    },
                    icon: const Icon(Icons.settings)),
                IconButton(
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                    },
                    icon: const Icon(Icons.logout)),
              ], title: const Text("Home")),
              body: Center(
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : SingleChildScrollView(
                        child: Column(
                          children: [
                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                //Initialize the spark charts widget
                                child: CustomYearPickerTextField(
                                    label: 'Ano de consulta',
                                    value: _year.toString(),
                                    onChanged: ((String? value) {
                                      if (value != null) {
                                        setState(
                                            () => _year = int.parse(value));
                                        initialize();
                                      }
                                    }))),
                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                //Initialize the spark charts widget
                                child: SfCartesianChart(
                                    title: ChartTitle(
                                        text:
                                            'Limite faturamento (Em vermelho)'),
                                    // Render text (Limit line) using the annotation feature
                                    primaryYAxis: NumericAxis(
                                      // Render limit line
                                      plotBands: <PlotBand>[
                                        PlotBand(
                                            isVisible: true,
                                            start: (controller.settings == null
                                                    ? 81000
                                                    : controller
                                                        .settings!.limit) -
                                                10,
                                            end: controller.settings == null
                                                ? 81000
                                                : controller.settings!.limit,
                                            shouldRenderAboveSeries: false,
                                            color: const Color.fromRGBO(
                                                207, 85, 7, 1))
                                      ],
                                    ),
                                    series: <LineSeries<Invoice, int>>[
                                      LineSeries<Invoice, int>(
                                          dataSource: controller.invoices,
                                          xValueMapper: (Invoice invoice, _) =>
                                              invoice.month,
                                          yValueMapper: (Invoice invoice, _) =>
                                              invoice.value,
                                          // Enable data label
                                          dataLabelSettings:
                                              const DataLabelSettings(
                                                  isVisible: true))
                                    ])),
                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                //Initialize the spark charts widget
                                child: SfCartesianChart(
                                    primaryXAxis: CategoryAxis(),
                                    // Chart title
                                    title: ChartTitle(text: 'Notas fiscais'),
                                    series: <LineSeries<Invoice, String>>[
                                      LineSeries<Invoice, String>(
                                          dataSource: controller.invoices,
                                          xValueMapper: (Invoice invoice, _) =>
                                              DateFormat('MMMM').format(
                                                  DateTime(0, invoice.month)),
                                          yValueMapper: (Invoice invoice, _) =>
                                              invoice.value,
                                          // Enable data label
                                          dataLabelSettings:
                                              const DataLabelSettings(
                                                  isVisible: true))
                                    ])),
                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                //Initialize the spark charts widget
                                child: SfCartesianChart(
                                    primaryXAxis: CategoryAxis(),
                                    // Chart title
                                    title: ChartTitle(text: 'Despesas'),
                                    series: <LineSeries<Expense, String>>[
                                      LineSeries<Expense, String>(
                                          dataSource: controller.expenses,
                                          xValueMapper: (Expense expense, _) =>
                                              DateFormat('MMMM').format(
                                                  DateTime(0, expense.month)),
                                          yValueMapper: (Expense expense, _) =>
                                              expense.value,
                                          // Enable data label
                                          dataLabelSettings:
                                              const DataLabelSettings(
                                                  isVisible: true))
                                    ])),
                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                //Initialize the spark charts widget
                                child: SfCartesianChart(
                                    primaryXAxis: CategoryAxis(),
                                    // Chart title
                                    title: ChartTitle(text: 'Balanço simples'),
                                    series: <
                                        LineSeries<_BalenceGeneral, String>>[
                                      LineSeries<_BalenceGeneral, String>(
                                          dataSource: controller.invoices
                                              .map((e) => _BalenceGeneral(
                                                  e.month, e.value))
                                              .toList(),
                                          xValueMapper: (_BalenceGeneral
                                                      invoice,
                                                  _) =>
                                              DateFormat('MMMM').format(
                                                  DateTime(0, invoice.month)),
                                          yValueMapper:
                                              (_BalenceGeneral invoice, _) =>
                                                  invoice.value,
                                          // Enable data label
                                          dataLabelSettings:
                                              const DataLabelSettings(
                                                  isVisible: true)),
                                      LineSeries<_BalenceGeneral, String>(
                                          dataSource: controller.expenses
                                              .map((e) => _BalenceGeneral(
                                                  e.month, e.value))
                                              .toList(),
                                          xValueMapper: (_BalenceGeneral
                                                      expense,
                                                  _) =>
                                              DateFormat('MMMM').format(
                                                  DateTime(0, expense.month)),
                                          yValueMapper:
                                              (_BalenceGeneral expense, _) =>
                                                  expense.value,
                                          // Enable data label
                                          dataLabelSettings:
                                              const DataLabelSettings(
                                                  isVisible: true))
                                    ])),
                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                //Initialize the spark charts widget
                                child: SfCartesianChart(
                                    primaryXAxis: CategoryAxis(),
                                    // Chart title
                                    title: ChartTitle(
                                        text: 'Despesas por categoria'),
                                    series: <LineSeries<Expense, String>>[
                                      LineSeries<Expense, String>(
                                          dataSource: controller.expenses,
                                          xValueMapper: (Expense expense, _) =>
                                              expense.category!.name,
                                          yValueMapper: (Expense expense, _) =>
                                              expense.value,
                                          // Enable data label
                                          dataLabelSettings:
                                              const DataLabelSettings(
                                                  isVisible: true))
                                    ])),
                          ],
                        ),
                      ),
              ),
              floatingActionButton: SpeedDialFabWidget(
                secondaryIconsList: const [
                  Icons.note_add,
                  Icons.payment,
                  Icons.list_alt,
                  Icons.payments,
                ],
                secondaryIconsText: const [
                  "Lançar Nota Fiscal",
                  "Lançar Despesa",
                  "Notas fiscais",
                  "Despesas"
                ],
                secondaryIconsOnPress: [
                  () {
                    Navigator.pushNamed(context, Routes.invoiceCompany);
                  },
                  () {
                    Navigator.pushNamed(context, Routes.expensesSelectCategory);
                  },
                  () {
                    Navigator.pushNamed(context, Routes.invoiceList);
                  },
                  () {
                    Navigator.pushNamed(context, Routes.expenses);
                  },
                ],
              ),
            )));
  }
}

class _BalenceGeneral {
  _BalenceGeneral(this.month, this.value);

  final int month;
  final double value;
}
