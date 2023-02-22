import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:vibbra_test/controllers/auth_controller.dart';
import 'package:vibbra_test/models/error.dart';
import 'package:vibbra_test/utils/routes.dart';
import 'package:vibbra_test/views/widgets/custom_outlined_textfield.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({
    super.key,
  });

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool _obscureText = true;
  TextEditingController emailController = TextEditingController(text: '');
  TextEditingController passwordController = TextEditingController(text: '');

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        Navigator.pushNamedAndRemoveUntil(
            context, Routes.home, (route) => false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: null, elevation: 0, backgroundColor: Colors.transparent),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Consumer<AuthController>(
          builder: ((context, controller, child) => SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Entre agora e automatize suas nota fiscais",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      const Text(
                        "Facilite sua vida como MEI",
                        style: TextStyle(fontSize: 24),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      CustomOutlinedTextField(
                          prefixIcon: const Icon(Icons.email),
                          label: "E-mail",
                          placeholder: "Digite o seu e-mail",
                          errors: controller.errors.errorsByCode('email'),
                          controller: emailController),
                      const SizedBox(
                        height: 16,
                      ),
                      CustomOutlinedTextField(
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureText
                                  ? Icons.visibility_off
                                  : Icons.remove_red_eye,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              setState(() => _obscureText = !_obscureText);
                            },
                          ),
                          obscureText: _obscureText,
                          label: 'Senha',
                          placeholder: "Digite a sua senha",
                          errors: controller.errors.errorsByCode('password'),
                          controller: passwordController),
                      Container(
                        width: double.infinity,
                        height: 48,
                        margin: const EdgeInsets.only(top: 24),
                        child: ElevatedButton(
                            onPressed: controller.isLoadingEmail
                                ? null
                                : () {
                                    controller
                                        .signInWithEmailAndPassword(
                                            emailController.text,
                                            passwordController.text)
                                        .then((value) {
                                      if (controller.errors
                                          .errorsByCode('general')
                                          .isNotEmpty) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                backgroundColor: Colors.red,
                                                content: Text(
                                                  controller.errors
                                                      .errorsByCode('general')
                                                      .first
                                                      .message,
                                                  style: const TextStyle(
                                                      color: Colors.white),
                                                )));
                                      }
                                    });
                                  },
                            child: controller.isLoadingEmail
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: const [
                                        SizedBox(
                                          height: 24,
                                          width: 24,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 16,
                                        ),
                                        Text("Carregando...",
                                            style:
                                                TextStyle(color: Colors.white))
                                      ])
                                : const Text('Entrar')),
                      ),
                      Container(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: const Divider()),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                            onPressed: controller.isLoadingGmail
                                ? null
                                : () {
                                    controller.signInWithGoogle().then((value) {
                                      if (controller.errors
                                          .errorsByCode('general')
                                          .isNotEmpty) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                backgroundColor: Colors.red,
                                                content: Text(
                                                  controller.errors
                                                      .errorsByCode('general')
                                                      .first
                                                      .message,
                                                  style: const TextStyle(
                                                      color: Colors.white),
                                                )));
                                      }
                                    });
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                            ),
                            child: controller.isLoadingGmail
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: const [
                                        SizedBox(
                                          height: 24,
                                          width: 24,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 16,
                                        ),
                                        Text("Carregando...",
                                            style:
                                                TextStyle(color: Colors.white))
                                      ])
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                          margin:
                                              const EdgeInsets.only(right: 8),
                                          child: const Icon(
                                            Ionicons.logo_google,
                                            color: Colors.black,
                                          )),
                                      const Text("Continuar com o Google",
                                          style:
                                              TextStyle(color: Colors.black)),
                                    ],
                                  )),
                      ),
                      Container(
                          width: double.infinity,
                          height: 48,
                          margin: const EdgeInsets.only(top: 8),
                          child: ElevatedButton(
                              onPressed: controller.isLoadingFacebook
                                  ? null
                                  : () {
                                      controller
                                          .signInWithFacebook()
                                          .then((value) {
                                        if (controller.errors
                                            .errorsByCode('general')
                                            .isNotEmpty) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  backgroundColor: Colors.red,
                                                  content: Text(
                                                    controller.errors
                                                        .errorsByCode('general')
                                                        .first
                                                        .message,
                                                    style: const TextStyle(
                                                        color: Colors.white),
                                                  )));
                                        }
                                      });
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                              ),
                              child: controller.isLoadingFacebook
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: const [
                                          SizedBox(
                                            height: 24,
                                            width: 24,
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 16,
                                          ),
                                          Text("Carregando...",
                                              style: TextStyle(
                                                  color: Colors.white))
                                        ])
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                            margin:
                                                const EdgeInsets.only(right: 8),
                                            child: const Icon(
                                              Ionicons.logo_facebook,
                                              color: Colors.white,
                                            )),
                                        const Text("Continuar com o Facebook",
                                            style:
                                                TextStyle(color: Colors.white)),
                                      ],
                                    ))),
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(top: 16),
                        child: TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, Routes.signUp);
                            },
                            child: const Text(
                                "Ainda não tem conta? Crie uma agora!")),
                      )
                    ]),
              )),
        ),
      ),
    );
  }
}
