import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:projeto_flutter/models/produto.dart';
import 'edit_produto.dart';
import '../../../controllers/user_controller.dart';
import 'login_page.dart';

class ListarProduto extends StatefulWidget {
  @override
  _ListarProdutoState createState() => _ListarProdutoState();
}

class _ListarProdutoState extends State<ListarProduto> {
  late final userController = Provider.of<UserController>(
    context,
    listen: false,
  );


  //TextEditingController: criar o controller  para um campo de texto editável
  //Sempre que o usuário modifica um campo de texto com um TextEditingController associado ,
  //o campo de texto atualiza o valor e o controlador notifica seus ouvintes
  //controle irá "receber" o valor que é digitado
  TextEditingController textSeachController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista Geral de Produtos"),
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

                //sempre que digitar algo no textfield essa função "onChanged" será a cada caracter digitado
                // a cada filtragem tem que atulizar a tela
                //wordToFilter é variavel(nome escolhido) que vai pegar o for digitado
                //e passar  como parâmetro na função "filterList" para posteriormente
                // fazer o teste na função  "filterList(String filter)""
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

                    //listar todos os itens
                    .where('ownerKey', isEqualTo: userController.user!.uid)

                    //entrar logado na tela listar produtos
                    //uso o id do usuário(vendedor) cadastrado
                    //id fixo
                    // .where('ownerKey',
                    //     isEqualTo: 'Eu2VjX8dfCfVUiWcPmAhEr4t78C3')

                    //listar por categoria
                    // .where('Categoria', isEqualTo: "Vinho")

                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  //lista de produtos
                  final produtos = snapshot.data!.docs.map((map) {
                    final data = map.data();
                    return ProdutoModel.fromMap(data, map.id);
                  }).toList();

                  //produtosLocal : varaivel/lista criada para receber a lista de produtos do banco
                  // para ser possível pegar o conteúdo da lista fora do escopo
                  //e posteriormente a "lista secundária/segunda lista(cópia da primeira lista)" terá acesso ao
                  //conteúdo da lista produtos, através da lista "produtosLocal"(que recebe essa lista)
                  //pois essa segunda lista irá receber a lista "produtosFiltrados" que será renderizada através do TextEditingController,
                  //quando o usuário digitar no campo de pesquisa.
                  //
                  ///variavel/lista "produtosLocal" vai receber "lista de produtos"
                  ////variavel/lista "produtosLocal" está fora do escopo da "lista produtos"
                  //chama a "lista de produtos" e envia para a variavel/lista secundária ("produtosLocal")
                  //para ter acesso a "lista produtos" fora desse escopo.
                  produtosLocal = produtos;

                  return ListView.builder(
                 
              

                    itemCount: textSeachController.text == ''
                   //testar o campo de digitação:
                   //se controle estiver  vai pegar o tamanho  da lista geral/inteira
                         ? produtos.length
                        //se tiver algum caracter pega o tamanho da lista filtrada
                        : produtosFiltrados.length,
                   
                   
                    itemBuilder: (context, index) {
                     
                      final produto = textSeachController.text == ''
                     
//testar o campo de digitação
//se area de digitação/text field for vazio pegar produto
                          ? produtos[index]
                        //se não for vazio ira pega os itens do produto filtrado
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
    );
  }

//criar uma lista nova ("produtosLocal")foi criada apenas para receber a lista "principal de produtos"
  // cria lista "produtosFiltrados" que ira receber a lista "produtosLocal" produtosFiltrados que será renderizada quando o usuário
  //digitar no campo de pesquisa.
  List<ProdutoModel> produtosLocal = [];
  List<ProdutoModel> produtosFiltrados = [];


//filterList: recebe o caracter digitado no text field
  filterList(String filter) {
    produtosFiltrados = produtosLocal
        .where((ProdutoModel produto) =>
        //"contains" = contém
        // pega o parâmetro percorre na lista
        //pega o primeiro produto  e coloca em minuscula (toLowerCase)
        //verifica se contém o "filtro" que recebeu como parametro
        //
            produto.item.toLowerCase().contains(filter.toLowerCase()))
    //caso encontre o parametro ele retona uma lista
    //com os parametros encontrados
     .toList();
//altera o estado da tela
    setState(() {});
  }
}
