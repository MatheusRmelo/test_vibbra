import 'package:flutter/material.dart';
import 'package:vibbra_test/views/expenses_categories/list_expenses_categories_page.dart';
import 'package:vibbra_test/views/partners/list_partners_page.dart';
import 'package:vibbra_test/views/settings_page.dart.dart';

class PreferencesPage extends StatefulWidget {
  const PreferencesPage({super.key});

  @override
  State<PreferencesPage> createState() => _PreferencesPageState();
}

class _PreferencesPageState extends State<PreferencesPage> {
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
              SettingsPage(),
            ],
          ),
        ));
  }
}
