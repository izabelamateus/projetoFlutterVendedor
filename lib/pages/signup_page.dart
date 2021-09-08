import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user_model.dart';
import '../../../controllers/user_controller.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  String nome = "";
  String email = "";
  String senha = "";

  late final userController = Provider.of<UserController>(
    context,
    listen: false,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Criar conta"),
      ),
      body: Column(
        children: [
          Image.asset(
            "logo2.jpeg"
          ),
          Form(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Nome'),
                    onChanged: (texto) => nome = texto,
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Email'),
                    onChanged: (texto) => email = texto,
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Senha'),
                    obscureText: true,
                    onChanged: (texto) => senha = texto,
                  ),
                  SizedBox(height: 12,),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                       primary: Color(0xFFF2622E),
                       minimumSize: Size(150, 50),
                     ), 
                    onPressed: () async {
                      final user = UserModel(nome: nome);
                      await userController.signup(email, senha, user);

                      Navigator.pop(context);
                    },
                    child: Text("Criar conta"),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
