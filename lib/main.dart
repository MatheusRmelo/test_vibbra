import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vibbra_test/controllers/auth_controller.dart';
import 'package:vibbra_test/controllers/company_controller.dart';
import 'package:vibbra_test/controllers/expense_category_controller.dart';
import 'package:vibbra_test/controllers/expense_controller.dart';
import 'package:vibbra_test/controllers/histories_controller.dart';
import 'package:vibbra_test/controllers/home_controller.dart';
import 'package:vibbra_test/controllers/invoice_controller.dart';
import 'package:vibbra_test/controllers/notification_controller.dart';
import 'package:vibbra_test/controllers/partner_controller.dart';
import 'package:vibbra_test/controllers/settings_controller.dart';
import 'package:vibbra_test/firebase_options.dart';
import 'package:vibbra_test/utils/routes.dart';
import 'package:vibbra_test/views/auth/signin_dart.dart';
import 'package:vibbra_test/views/auth/signup_page.dart';
import 'package:vibbra_test/views/expenses/expenses_category_select_page.dart';
import 'package:vibbra_test/views/expenses/expenses_company_select_page.dart';
import 'package:vibbra_test/views/expenses/expenses_form_page.dart';
import 'package:vibbra_test/views/expenses/expenses_page.dart';
import 'package:vibbra_test/views/expenses_categories/form_expense_category_page.dart';
import 'package:vibbra_test/views/histories/histories_page.dart';
import 'package:vibbra_test/views/home_page.dart';
import 'package:vibbra_test/views/invoices/invoice_company_page.dart';
import 'package:vibbra_test/views/invoices/invoice_form_page.dart';
import 'package:vibbra_test/views/invoices/invoice_list_page.dart';
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
      ChangeNotifierProvider(create: (_) => SettingsController()),
      ChangeNotifierProvider(create: (_) => InvoiceController()),
      ChangeNotifierProvider(create: (_) => ExpenseController()),
      ChangeNotifierProvider(create: (_) => HistoriesController()),
      ChangeNotifierProvider(create: (_) => NotificationController()),
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
        Routes.signUp: (context) => const SignUpPage(),
        Routes.registerCompany: ((context) => const RegisterCompanyPage()),
        Routes.preferences: (context) => const PreferencesPage(),
        Routes.partnersForm: (context) => const FormPartnerPage(),
        Routes.expensesCategoriesForm: (context) =>
            const FormExpenseCategoryPage(),
        Routes.invoiceCompany: (context) => const InvoiceCompanyPage(),
        Routes.invoiceForm: (context) => const InvoiceFormPage(),
        Routes.invoiceList: (context) => const InvoiceListPage(),
        Routes.expenses: (context) => const ExpensesPage(),
        Routes.expensesSelectCategory: (context) =>
            const ExpensesCategorySelectPage(),
        Routes.expensesForm: (context) => const ExpensesFormPage(),
        Routes.expensesSelectCompany: (context) =>
            const ExpensesCompanySelectPage(),
        Routes.histories: (context) => const HistoriesPage()
      },
    );
  }
}
