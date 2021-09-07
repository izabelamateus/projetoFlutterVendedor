import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:projeto_flutter/models/produto.dart';
import './list_usuarios_page.dart';
import 'edit_produto.dart';
import 'add_produto.dart';
import '../../../controllers/user_controller.dart';

class ListarProduto extends StatefulWidget {
  @override
  _ListarProdutoState createState() => _ListarProdutoState();
}

class _ListarProdutoState extends State<ListarProduto> {
  late final userController = Provider.of<UserController>(
    context,
    listen: false,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
           
            // UserAccountsDrawerHeader(
            //   accountName: Text(userController.model.nome),
            //   accountEmail: Text(userController.user!.email!),
            // ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text("Bootiquim SoulBreja"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ListUsuariosPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    
      appBar: AppBar(
        title: Text("Adicionar por categoria"),
        actions: [
          IconButton(
            onPressed: () async {
              await userController.logout();
            },
            icon: Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('Produtos')
            .where('ownerKey', isEqualTo: userController.user!.uid)
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
                  children: [
                   Text(produto.quantidade),
                    Text(produto.preco),
                  ],
                ),
                leading: produto.imagem != null
                    ? Image.memory(
                        produto.imagem!,
                        fit: BoxFit.cover,
                        width: 72,
                      )
                    : Container(
                        child: Icon(Icons.location_on),
                        width: 72,
                        height: double.maxFinite,
                        color: Colors.blue,
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
                },
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
              builder: (context) => AddProduto(),
            ),
          );
        },
      ),
    );
  }
}

