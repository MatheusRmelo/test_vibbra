import 'package:flutter/material.dart';

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
              Icon(Icons.directions_car),
              Icon(Icons.directions_transit),
              Icon(Icons.directions_bike),
            ],
          ),
        ));
  }
}
