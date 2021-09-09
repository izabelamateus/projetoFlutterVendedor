import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/user_controller.dart';
import '../models/produto.dart';

class AddVinho extends StatefulWidget {
  @override
  _AddVinhoState createState() => _AddVinhoState();
}

class _AddVinhoState extends State<AddVinho> {
  String item = "",
      descricao = "",
      categoria = "Vinho",
      quantidade = "",
      volume = "",
      preco = "";
  bool promocao = false;

  Uint8List? file;

  late final userController = Provider.of<UserController>(
    context,
    listen: false,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Adicionar Vinho"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: "Item",
                ),
                onChanged: (texto) => item = texto,
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: "Descrição",
                ),
                onChanged: (texto) => descricao = texto,
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: "Quantidade",
                ),
                onChanged: (texto) => quantidade = texto,
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: "Preço",
                ),
                onChanged: (texto) => preco = texto,
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: "Volume",
                ),
                onChanged: (texto) => volume = texto,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          children: [
                            Text('Adicionar Produto na Promoção?'),
                            Switch(
                              activeColor: Colors.deepOrange,
                              value: promocao,
                              onChanged: (value) {
                                setState(() {
                                  promocao = value;
                                });
                              },
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 12.0,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () async {
                  final result =
                      await FilePicker.platform.pickFiles(type: FileType.image);

                  if (result != null) {
                    setState(() {
                      final bytes = result.files.first.bytes;
                      file = bytes;
                    });
                  }
                },
                child: Row(
                  children: [
                    Icon(file != null ? Icons.check : Icons.upload),
                    Text("Adicionar imagem"),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: () async {
                  final user = await FirebaseFirestore.instance
                      .collection('produtos')
                      .doc(userController.user!.uid)
                      .get();

                  // final data = user.data()!;

                  final novoProduto = ProdutoModel(
                    ownerKey: userController.user!.uid,
                    item: item,
                    descricao: descricao,
                    quantidade: quantidade,
                    preco: preco,
                    promocao: promocao,
                    categoria: categoria,
                    volume: volume,
                    imagem: file,
                  ).toMap();

                  await FirebaseFirestore.instance
                      .collection('produtos')
                      .add(novoProduto);

                  Navigator.pop(context);
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    width: 2.0,
                    color: Color(0xFFF2622E),
                    style: BorderStyle.solid,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text("Adicionar Vinho"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
