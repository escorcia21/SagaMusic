import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_egresados/domain/use_cases/controllers/authentication.dart';
import 'package:red_egresados/domain/use_cases/controllers/connectivity.dart';

class SignUpScreen extends StatefulWidget {
  final VoidCallback onViewSwitch;

  const SignUpScreen({Key? key, required this.onViewSwitch}) : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<SignUpScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final controller = Get.find<AuthController>();
  final connectivityController = Get.find<ConnectivityController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Creación de usuario",
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              key: const Key("signUpName"),
              controller: nameController,
              style: TextStyle(color: Colors.black),
              decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                  labelText: 'Nombre',
                  labelStyle: TextStyle(color: Colors.red)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              key: const Key("signUpEmail"),
              controller: emailController,
              style: TextStyle(color: Colors.black),
              decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colors.red)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              key: const Key("signUpPassword"),
              controller: passwordController,
              obscureText: true,
              obscuringCharacter: "*",
              style: TextStyle(color: Colors.black),
              decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                  labelText: 'Clave',
                  labelStyle: TextStyle(color: Colors.red)),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (connectivityController.connected) {
                        await controller.manager.signUp(
                            name: nameController.text,
                            email: emailController.text,
                            password: passwordController.text);
                      } else {
                        Get.showSnackbar(
                          GetBar(
                            message: "No estas conectado a la red.",
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                    child: const Text("Registrar"),
                  ),
                ),
              ),
            ],
          ),
          TextButton(
            onPressed: widget.onViewSwitch,
            child: const Text("Entrar"),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
