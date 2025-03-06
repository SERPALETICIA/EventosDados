

import 'package:flutter/material.dart';
import 'package:gerenciador_tarefas_si7/model/tarefa.dart';

class ListaTarefasPage extends StatefulWidget{

  @override
  _ListaTarefasPageState createState() => _ListaTarefasPageState();
}

class _ListaTarefasPageState extends State<ListaTarefasPage>{

  final tarefas = <Tarefa> [
   // Tarefa(id: 1, descricao: 'Tarefa avaliativa da disciplina')
  ];

  var _ultimoId = 1;

  @override
  Widget build (BuildContext context){
    return Scaffold(
      appBar: _criarAppBar(),
      body: _criarBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Nova Tarefa',
        child: const Icon(Icons.add),
      ),
    );
  }

  AppBar _criarAppBar() {
    return AppBar(
      centerTitle: true,
      title: const Text('Gerenciador de Tarefas'),
      actions: [
        IconButton(
            onPressed: () {},
            icon: Icon(Icons.filter_list)
        )
      ],
    );
  }

  Widget _criarBody() {
    if (tarefas.isEmpty){
      return const Center(
        child: Text('Nenhuma tarefa cadastrada',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      );
    }
    return Container();
  }
}