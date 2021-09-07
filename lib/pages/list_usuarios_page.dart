import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../controllers/user_controller.dart';
import 'package:projeto_flutter/models/user_model.dart';

class ListUsuariosPage extends StatefulWidget {
  @override
  _ListUsuariosPageState createState() => _ListUsuariosPageState();
}

class _ListUsuariosPageState extends State<ListUsuariosPage> {
  late final userController = Provider.of<UserController>(
    context,
    listen: false,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Usuários"),
      ),
      body: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
        future: FirebaseFirestore.instance.collection('usuarios').get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final usuarios = snapshot.data!.docs.map(
            (documento) {
              final dados = documento.data();
              return UserModel.fromMap(dados);
            },
          ).toList();

          return ListView.builder(
              itemCount: usuarios.length,
              itemBuilder: (context, index) {
                final usuario = usuarios[index];

                var cor = usuario.key == userController.model.key
                    ? Colors.red
                    : Colors.white;

                return ListTile(
                  leading: Icon(Icons.person),
                  title: Text(usuario.nome),
                  tileColor: cor,
                );
              });
        },
      ),
    );
  }
}

