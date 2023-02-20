import 'package:flutter/material.dart';
import 'package:vibbra_test/views/expenses_categories/list_expenses_categories_page.dart';
import 'package:vibbra_test/views/partners/list_partners_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
              title: const Text("Preferências"),
              bottom: const TabBar(
                tabs: [
                  Tab(
                    icon: Icon(Icons.business_center),
                    child:
                        Text("Empresas parceiras", textAlign: TextAlign.center),
                  ),
                  Tab(
                    icon: Icon(Icons.payment),
                    child: Text("Categorias de despesas",
                        textAlign: TextAlign.center),
                  ),
                  Tab(
                    icon: Icon(Icons.settings),
                    child: Text("Configurações", textAlign: TextAlign.center),
                  ),
                ],
              )),
          body: const TabBarView(
            children: [
              ListPartnersPage(),
              ListExpensesCategories(),
              Icon(Icons.directions_bike),
            ],
          ),
        ));
  }
}
