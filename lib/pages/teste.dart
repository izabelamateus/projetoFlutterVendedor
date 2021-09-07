import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:projeto_flutter/models/produto.dart';
import 'edit_produto.dart';
import '../../../controllers/user_controller.dart';
import 'lista_produtos.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // Remove the debug banner

        );
  }
}

class HomePage2 extends StatefulWidget {
  @override
  _HomePage2State createState() => _HomePage2State();
}

class _HomePage2State extends State<HomePage2> {
  late final userController = Provider.of<UserController>(
    context,
    listen: false,
  );
  // This holds a list of fiction users
  // You can use data fetched from a database or cloud as well
  // final List<Map<String, dynamic>> _allUsers = [
  //   {"id": 1, "name": "Andy", "age": 29},
  //   {"id": 2, "name": "Aragon", "age": 40},
  //   {"id": 3, "name": "Bob", "age": 5},
  //   {"id": 4, "name": "Barbara", "age": 35},
  //   {"id": 5, "name": "Candy", "age": 21},
  //   {"id": 6, "name": "Colin", "age": 55},
  //   {"id": 7, "name": "Audra", "age": 30},
  //   {"id": 8, "name": "Banana", "age": 14},
  //   {"id": 9, "name": "Caversky", "age": 100},
  //   {"id": 10, "name": "Becky", "age": 32},
  // ];

  // This list holds the data for the list view
  late Query<Map<String, dynamic>> _foundUsers;
  @override
  initState() {
    // at the beginning, all users are shown
    _foundUsers = FirebaseFirestore.instance
        .collection('produtos')
        .where('ownerKey', isEqualTo: userController.user!.uid);
    super.initState();
  }

  // This function is called whenever the text field changes
  void _runFilter(String enteredKeyword) {
    Query<Map<String, dynamic>> results;
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = _foundUsers;
    } else {
      results = _foundUsers.where((itens) =>
          itens[''].toLowerCase().contains(enteredKeyword.toLowerCase()));
      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      _foundUsers = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          onChanged: (value) => _runFilter(value),
          decoration: InputDecoration(
              labelText: 'Search', suffixIcon: Icon(Icons.search)),
        ),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('produtos')
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
                        child: Icon(Icons.photo),
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
    );
  }
}
