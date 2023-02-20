import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vibbra_test/controllers/auth_controller.dart';
import 'package:vibbra_test/controllers/company_controller.dart';
import 'package:vibbra_test/controllers/expense_category_controller.dart';
import 'package:vibbra_test/controllers/home_controller.dart';
import 'package:vibbra_test/controllers/partner_controller.dart';
import 'package:vibbra_test/controllers/settings_controller.dart';
import 'package:vibbra_test/firebase_options.dart';
import 'package:vibbra_test/utils/routes.dart';
import 'package:vibbra_test/views/auth/signin_dart.dart';
import 'package:vibbra_test/views/expenses_categories/form_expense_category_page.dart';
import 'package:vibbra_test/views/home_page.dart';
import 'package:vibbra_test/views/partners/form_partner_page.dart';
import 'package:vibbra_test/views/preferences_page.dart';
import 'package:vibbra_test/views/register_company_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AuthController()),
      ChangeNotifierProvider(create: (_) => HomeController()),
      ChangeNotifierProvider(create: (_) => CompanyController()),
      ChangeNotifierProvider(create: (_) => PartnerController()),
      ChangeNotifierProvider(create: (_) => ExpenseCategoryController()),
      ChangeNotifierProvider(create: (_) => SettingsController())
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: Routes.home,
      routes: {
        Routes.home: (context) => const HomePage(),
        Routes.signIn: (context) => const SignInPage(),
        Routes.registerCompany: ((context) => const RegisterCompanyPage()),
        Routes.preferences: (context) => const PreferencesPage(),
        Routes.partnersForm: (context) => const FormPartnerPage(),
        Routes.expensesCategoriesForm: (context) =>
            const FormExpenseCategoryPage(),
      },
    );
  }
}
