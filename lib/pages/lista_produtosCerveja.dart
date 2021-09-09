import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:projeto_flutter/pages/add_cerveja.dart';
import 'package:provider/provider.dart';
import 'package:projeto_flutter/models/produto.dart';
import 'edit_produto.dart';
import '../../../controllers/user_controller.dart';

class ListarProdutoCerveja extends StatefulWidget {
  @override
  _ListarProdutoCervejaState createState() => _ListarProdutoCervejaState();
}

class _ListarProdutoCervejaState extends State<ListarProdutoCerveja> {
  late final userController = Provider.of<UserController>(
    context,
    listen: false,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Cervejas"),
        actions: [
          IconButton(
            onPressed: () async {
              await userController.logout();
              Navigator.pop(context);
            },
            icon: Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('produtos')
            .where('ownerKey', isEqualTo: userController.user!.uid)
            .where('categoria', isEqualTo: "Cerveja")
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final produtos = snapshot.data!.docs.map((map) {
            final data = map.data();
            return ProdutoModel.fromMap(data, map.id);
          }).toList();

          return ListView.builder(
            itemCount: produtos.length,
            itemBuilder: (context, index) {
              final produto = produtos[index];
              return ListTile(
                title: Text(produto.item),
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text("Quantidade: "),
                    Text(produto.quantidade),
                    SizedBox(width: 6),
                    Text("Valor: "),
                    Text(produto.preco),
                    GestureDetector(
                        child: Icon(
                          Icons.edit,
                          color: Color(0xFFF2C6A0),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditProdutoPage(
                                produto: produto,
                              ),
                            ),
                          );
                        }),
                  ],
                ),
                leading: produto.imagem != null
                    ? Image.memory(
                        produto.imagem!,
                        fit: BoxFit.cover,
                        width: 72,
                      )
                    : Container(
                        child: Icon(Icons.photo),
                        width: 72,
                        height: double.maxFinite,
                        color: Colors.deepOrange,
                      ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddCerveja(),
            ),
          );
        },
      ),
    );
  }
}
