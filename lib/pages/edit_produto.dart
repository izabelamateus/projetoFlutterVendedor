import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../models/produto.dart';

class EditProdutoPage extends StatefulWidget {
  final ProdutoModel produto;

  EditProdutoPage({required this.produto});

  @override
  _EditProdutoPageState createState() => _EditProdutoPageState();
}

class _EditProdutoPageState extends State<EditProdutoPage> {
  late final itemCont = TextEditingController()..text = widget.produto.item;
  late final categoriaCont = TextEditingController()
    ..text = widget.produto.categoria;
  late final volumeCont = TextEditingController()..text = widget.produto.volume;
  late final descricaoCont = TextEditingController()
    ..text = widget.produto.descricao;
  late final quantidadeCont = TextEditingController()
    ..text = widget.produto.quantidade;
  late final precoCont = TextEditingController()..text = widget.produto.preco;

  bool promocao = false;
  late Uint8List? file = widget.produto.imagem;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Editar produto"),
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseFirestore.instance
                  .collection('Produtos')
                  .doc(widget.produto.key)
                  .delete();
              Navigator.pop(context);
            },
            icon: Icon(Icons.delete),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            children: [
              TextField(
                controller: itemCont,
                decoration: InputDecoration(
                  labelText: "Item",
                ),
              ),
              TextField(
                controller: descricaoCont,
                decoration: InputDecoration(
                  labelText: "Descrição",
                ),
              ),
              TextField(
                controller: quantidadeCont,
                decoration: InputDecoration(
                  labelText: "Quantidade",
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: precoCont,
                decoration: InputDecoration(
                  labelText: "Preço",
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: volumeCont,
                decoration: InputDecoration(
                  labelText: "Volume",
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: categoriaCont,
                decoration: InputDecoration(
                  labelText: "Categoria",
                ),
              ),
              Row(
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Switch(
                          activeColor: Colors.pink,
                          value: promocao,
                          onChanged: (value) {
                            setState(() {
                              promocao = value;
                            });
                          },
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
                  final atualizado = ProdutoModel(
                    ownerKey: widget.produto.ownerKey,
                    item: itemCont.text,
                    descricao: descricaoCont.text,
                    quantidade: widget.produto.quantidade,
                    preco: widget.produto.preco,
                    promocao: widget.produto.promocao,
                    categoria: widget.produto.categoria,
                    volume: widget.produto.volume,
                    imagem: file,
                  ).toMap();

                  await FirebaseFirestore.instance
                      .collection('Produtos')
                      .doc(widget.produto.key)
                      .update(atualizado);

                  Navigator.pop(context);
                },
                child: Text("Atualizar produto"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
