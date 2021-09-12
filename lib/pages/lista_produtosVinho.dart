import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:projeto_flutter/pages/add_vinho.dart';
import 'package:provider/provider.dart';
import 'package:projeto_flutter/models/produto.dart';
import 'edit_produto.dart';
import '../../../controllers/user_controller.dart';
import 'login_page.dart';

class ListarProdutoVinho extends StatefulWidget {
  @override
  _ListarProdutoVinhoState createState() => _ListarProdutoVinhoState();
}

class _ListarProdutoVinhoState extends State<ListarProdutoVinho> {
  late final userController = Provider.of<UserController>(
    context,
    listen: false,
  );

  TextEditingController textSeachController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Vinhos"),
        actions: [
          IconButton(
            onPressed: () async {
              await userController.logout();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginPage(),
                ),
              );
            },
            icon: Icon(Icons.exit_to_app),
          ),
        ],
      ),
    
    
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            Container(
              height: 60,
              child: TextField(
                textAlign: TextAlign.center,

                controller: textSeachController,

                onChanged: (wordToFilter) {
                  print('TEXTO DIGITADO: $wordToFilter');
                  filterList(wordToFilter);
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  labelText: 'Pesquisar Produto',
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection('produtos')

                   
                    .where('ownerKey', isEqualTo: userController.user!.uid)
                    .where('categoria', isEqualTo: "Vinho")
                   

                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                 
                  final produtos = snapshot.data!.docs.map((map) {
                    final data = map.data();
                    return ProdutoModel.fromMap(data, map.id);
                  }).toList();

                
                  produtosLocal = produtos;

                  return ListView.builder(
                    itemCount: textSeachController.text == ''
                        
                        ? produtos.length
                      
                        : produtosFiltrados.length,
                    itemBuilder: (context, index) {
                      final produto = textSeachController.text == ''

                          ? produtos[index]
                       
                          : produtosFiltrados[index];
                      return ListTile(
                        title: Text(produto.item),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text('Quantidade: '),
                            Text(produto.quantidade),
                            SizedBox(width: 6),
                            Text('Preço: '),
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
                                fit: BoxFit.contain,
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
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddVinho(),
            ),
          );
        },
      ),
    );
  }


  List<ProdutoModel> produtosLocal = [];
  List<ProdutoModel> produtosFiltrados = [];


  filterList(String filter) {
    produtosFiltrados = produtosLocal
        .where((ProdutoModel produto) =>
  
            produto.item.toLowerCase().contains(filter.toLowerCase()))
      
        .toList();

    setState(() {});
  }
}
