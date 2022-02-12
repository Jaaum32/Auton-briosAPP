import 'package:flutter/material.dart';

class InstPage extends StatefulWidget {
  const InstPage({Key? key}) : super(key: key);

  @override
  _InstPageState createState() => _InstPageState();
}

class _InstPageState extends State<InstPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Instruções',
            style: TextStyle(
                fontSize: 36, color: Colors.white, fontFamily: 'Comfortaa'),
          ),
          bottom: const TabBar(
            tabs: <Widget>[
              Text('Tenébrios'),
              Text('Caixas automatizadas'),
              Text('Aplicativo'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _instrucoesTenebrios(context),
            _instrucoesCaixaAssistida(context),
            _instrucoesAplicativo(context),
          ],
        ),
      ),
    );
  }

  _instrucoesTenebrios(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: ListView(
        children: [
          Text(
            'O Tenebrio molitor é um besouro, conhecido popularmente como larva-da-farinha, é considerada uma praga de grãos, farinha e outros tipos de farelos, por isso é encontrado em moinhos, armazéns e depósitos desses produtos (NASCIMENTO FILHO, 2020).\n O ciclo de vida da Larva da farinha como mostra a Figura 1, é composta por diversas fases, sendo elas ovo, larva, pupa e besouro, e se conclui entre 280 e 630 dias, as fases importantes comercialmente são as larvas, as larvas eclodem em torno de uma semana e se tornam larvas maduras em 3-4 meses, a fase larval pode durar até 18 meses. A larva madura é amarelada, tem 20 a 32 mm de comprimento e pesa entre 130-160mg, mas produtores comerciais usam de um hormônio que torna possível larvas de 2cm e 300mg (VILELLA, 2018).',
            textAlign: TextAlign.justify,
            style: const TextStyle(
                fontSize: 20, color: Colors.black54, fontFamily: 'Comfortaa'),
          ),
          Divider(
            color: Colors.transparent,
          ),
          Image.asset(
            'assets/images/ciclo.jpg',
            height: 250,
            width: 250,
          ),
          Divider(
            color: Colors.transparent,
          ),
          Text(
            'O tenébrio consegue converter resíduos vegetais de baixa qualidade em alimento rico em energia, proteínas e gorduras em um tempo relativamente curto, além de ser onívoro, podendo se alimentar dos grãos de cereais, hortaliças e ainda levedura de cerveja. Os tenébrios se proliferam com facilidade, gerando um grande número de descendentes, por conta disso é fácil produzir em grande escala (NASCIMENTO FILHO, 2020). Sobre seu valor nutricional, as larvas são compostas de alta quantidade de proteína bruta (47-60%) e de lipídeos (30-43%), além disso as larvas frescas possuem 60-70% de água, é rica também em aminoácidos essenciais e ácidos graxos mono e poli-insaturados. Mas como outros insetos têm baixo conteúdo de cálcio e baixa relação de calorias, sendo assim, apesar de serem muito nutritivos, uma alimentação não pode ser baseada apenas em produtos de tenébrios, pois pode acarretar uma deficiência em cálcio (VILELLA, 2018).',
            textAlign: TextAlign.justify,
            style: const TextStyle(
                fontSize: 20, color: Colors.black54, fontFamily: 'Comfortaa'),
          ),
          Image.asset(
            'assets/images/tenebrio.jpg',
            width: 450,
          ),
          Divider(
            color: Colors.transparent,
          ),
          Text(
            'O tenébrio é comumente utilizado e produzido industrialmente para alimentação de animais em zoológicos, principalmente aves, répteis, pequenos mamíferos, anfíbios e peixes. Sua forma de uso na alimentação é diversificada, podendo ser usado vivo, seco, enlatado ou em pó (VILELLA, 2018).',
            textAlign: TextAlign.justify,
            style: const TextStyle(
                fontSize: 20, color: Colors.black54, fontFamily: 'Comfortaa'),
          ),
        ],
      ),
    );
  }

  _instrucoesCaixaAssistida(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: ListView(
        children: [
          Image.asset(
            'assets/images/caixaA.png',
            width: 300,
          ),
          Image.asset(
            'assets/images/legenda.png',
            width: 450,
          ),
          Divider(
            color: Colors.transparent,
          ),
          Text(
            'Em desenvolvimento...',
            textAlign: TextAlign.justify,
            style: const TextStyle(
                fontSize: 20, color: Colors.black54, fontFamily: 'Comfortaa'),
          ),
        ],
      ),
    );
  }

  _instrucoesAplicativo(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: ListView(
        children: [
          Text(
            '1 - O primeiro passo para o uso do aplicativo é adicionar uma dieta, então vá para Dietas > Adicionar\n' +
                '2 - Agora adicione uma caixa, para isso vá para Caixas > Adicionar\n' +
                '3 - Agora você pode buscar sua caixa pelo código QR na tela Caixas e analisar seus dados, ou acessar esses dados apenas clicando em uma caixa, além disso, pode  analisar os eventos na tela Eventos\n' +
                '4 - Caso você complete uma atividade da tela Eventos, clique no check para excluir-la\n',
            textAlign: TextAlign.justify,
            style: const TextStyle(
                fontSize: 20, color: Colors.black54, fontFamily: 'Comfortaa'),
          ),
          Text(
            'Obs: Nos cards de Dietas e Caixas\n' +
                'Existe um botão representado por 3 pontos, onde você pode encontrar as funções de editar e excluir uma caixa.',
            textAlign: TextAlign.justify,
            style: const TextStyle(
                fontSize: 20, color: Colors.black54, fontFamily: 'Comfortaa'),
          )
        ],
      ),
    );
  }
}
