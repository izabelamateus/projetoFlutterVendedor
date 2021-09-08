import 'package:flutter/material.dart';
import 'package:projeto_flutter/pages/lista_produtosCerveja.dart';
import 'package:projeto_flutter/pages/lista_produtosVinho.dart';
import 'package:projeto_flutter/pages/lista_produtosWhisky.dart';
import 'package:projeto_flutter/pages/teste.dart';
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
              title: Text("Estatísticas"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PieChartSample2(),
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
      body: Column(
        children: [
          Container(
            child: Text("colocar dashboard"),
            color: Colors.blue,
            height: 250,
          ),
          SizedBox(height: 9),
          Text(
            "Categorias",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                height: 100,
                width: 100,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ListarProdutoCerveja()));
                  },
                  child: Text("Cerveja"),
                  style: TextButton.styleFrom(
                    primary: Colors.white,
                    backgroundColor: Colors.purple,
                  ),
                ),
              ),
              Container(
                height: 100,
                width: 100,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ListarProdutoVinho()));
                  },
                  child: Text("Vinho"),
                  style: TextButton.styleFrom(
                    primary: Colors.white,
                    backgroundColor: Colors.purple,
                  ),
                ),
              ),
              Container(
                height: 100,
                width: 100,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ListarProdutoWhisky()));
                  },
                  child: Text("Whisky"),
                  style: TextButton.styleFrom(
                    primary: Colors.white,
                    backgroundColor: Colors.purple,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
