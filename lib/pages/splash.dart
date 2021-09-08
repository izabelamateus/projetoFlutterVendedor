import 'package:animated_card/animated_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:projeto_flutter/pages/login_page.dart';


class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
//iniciar estado
  //estado inicial
  void initState() {
    //quando a tela inicializar (ensureInitialized)
    //primeiro frame for redentizado(addPostFrameCallback)
    //vair esperar 2 segundos(soma o tempo total da animação e acrescenta o tempo que a tela ficara
    //congelada para entrar na home)
    //e navegar na homePage
    // addPostFrameCallback - pega o primeiro frame e
    // e quando aparecer na tela
    //começa a contar os segundos
    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback(
      (timeStamp) {
        Future.delayed(Duration(seconds: 3)).then(
          (value) => Navigator.of(context).push(
            MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
          ),
        );
      },
    );
// método que é chamado uma vez
// quando o widget com estado é inserido
//na árvore de widgets.
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(

          //não tem collum ou row que permita
          // que tenha tamanho finito
          //ocupa o máximo de tamanho que
          //tem disponível
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.black,
          ),
          child: AnimatedCard(
            duration: Duration(seconds: 1),
            direction: AnimatedCardDirection.top,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    "assets/LOGO.png",
                    height: 160,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedCard(
                        duration: Duration(seconds: 2),
                        direction: AnimatedCardDirection.bottom,
                        child: Text(
                          "SoulCode",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
