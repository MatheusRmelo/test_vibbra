import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vibbra_test/controllers/company_controller.dart';
import 'package:vibbra_test/controllers/home_controller.dart';
import 'package:vibbra_test/utils/routes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        Navigator.pushNamedAndRemoveUntil(
            context, Routes.signIn, (route) => false);
      } else {
        var controller = context.read<CompanyController>();
        controller.isFirstUse().then((value) {
          if (value) {
            Navigator.pushNamedAndRemoveUntil(
                context, Routes.registerCompany, (route) => false);
          }
          if (mounted) {
            setState(() => _isLoading = false);
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home")),
      body: Center(
          child: _isLoading
              ? CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                  },
                  child: const Text("Logout"))),
    );
  }
}
