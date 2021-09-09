import 'package:flutter/material.dart';
import 'package:projeto_flutter/pages/dash2.dart';
import 'package:projeto_flutter/pages/estatisticas.dart';
import 'package:projeto_flutter/pages/lista_produtosCerveja.dart';
import 'package:projeto_flutter/pages/lista_produtosVinho.dart';
import 'package:projeto_flutter/pages/lista_produtosWhisky.dart';
import 'package:provider/provider.dart';
import '../controllers/user_controller.dart';
import 'dash.dart';
import 'list_usuarios_page.dart';
import 'lista_produtos.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
            UserAccountsDrawerHeader(
              accountName: Text(userController.model.nome),
              accountEmail: Text(userController.user!.email!),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text("Bootquim SoulBreja"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ListUsuariosPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.production_quantity_limits),
              title: Text("Produtos"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ListarProduto(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.dashboard),
              title: Text("Estatísticas Geral"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Estatisticas(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text("Produtos por Categoria"),
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
      body: Column(
        children: [
          Image.asset("logo2.jpeg"),
          SizedBox(height: 9),
          Text(
            "Categorias",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        image: new DecorationImage(
                            image: new AssetImage('cerveja.png'))),
                    height: 100,
                    width: 100,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ListarProdutoCerveja()));
                      },
                      child: Text(
                        '',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Text('Cervejas'),
                ],
              ),
              Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        image: new DecorationImage(
                            image: new AssetImage('vinho.png'))),
                    height: 100,
                    width: 100,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ListarProdutoVinho()));
                      },
                      child: Text(""),
                      style: TextButton.styleFrom(
                        primary: Colors.white,
                      ),
                    ),
                  ),
                  Text('Vinhos'),
                ],
              ),
              Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        image: new DecorationImage(
                            image: new AssetImage('uisque.png'))),
                    height: 100,
                    width: 100,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ListarProdutoWhisky()));
                      },
                      child: Text(""),
                      style: TextButton.styleFrom(
                        primary: Colors.white,
                      ),
                    ),
                  ),
                  Text('Whiskies'),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 40,
          ),
          Text(
            'Bem vindo, ${userController.model.nome}!',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
