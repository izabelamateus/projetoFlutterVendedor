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
  late final descricaoCont = TextEditingController()
    ..text = widget.produto.descricao;
  late final quantidadeCont = TextEditingController()
    ..text = widget.produto.quantidade.toString();
  late final precoCont = TextEditingController()
    ..text = widget.produto.preco.toString();
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
                  suffixIcon: Icon(Icons.location_on),
                  labelText: "Descrição",
                ),
              ),
              TextField(
                controller: quantidadeCont,
                decoration: InputDecoration(
                  labelText: "Quantidade",
                ),
                maxLines: 20,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: precoCont,
                decoration: InputDecoration(
                  labelText: "Preço",
                ),
                maxLines: 20,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: precoCont,
                decoration: InputDecoration(
                  labelText: "Promoção",
                ),
                maxLines: 20,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: categoriaCont,
                decoration: InputDecoration(
                  labelText: "Categoria",
                ),
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
