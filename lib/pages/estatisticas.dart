import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dash.dart';
import 'dash2.dart';
import '../../../controllers/user_controller.dart';
import 'login_page.dart';

class Estatisticas extends StatefulWidget {
  @override
  _EstatisticasState createState() => _EstatisticasState();
}

class _EstatisticasState extends State<Estatisticas> {
  late final userController = Provider.of<UserController>(
    context,
    listen: false,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Estatísticas"),
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
      body: SingleChildScrollView(
        child: Material(
          child: Column(
            children: [
              Container(
                height: 10,
              ),
              Container(
                height: 40,
                child: Text('Vendas Trimestrais',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    )),
              ),
              LineChartSample(),
              Container(
                height: 10,
              ),
              Container(
                height: 40,
                child: Text('Receita por Categoria',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    )),
              ),
              PieChartSample3(),
            ],
          ),
        ),
      ),
    );
  }
}
