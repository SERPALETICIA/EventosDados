

import 'package:flutter/material.dart';
import 'package:gerenciador_tarefas_si7/model/tarefa.dart';

class ListaTarefasPage extends StatefulWidget{

  @override
  _ListaTarefasPageState createState() => _ListaTarefasPageState();
}

class _ListaTarefasPageState extends State<ListaTarefasPage>{

  final tarefas = <Tarefa> [
   Tarefa(id: 1, descricao: 'Tarefa avaliativa da disciplina'
   //, prazo: DateTime.now().add(const Duration(days: 5))
  )
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
    return  ListView.separated(
      itemCount: tarefas.length,
        itemBuilder: (BuildContext context, int index){
          final tarefa = tarefas[index];
          return ListTile(
            title: Text('${tarefa.id} - ${tarefa.descricao}'),
            subtitle: Text(tarefa.prazoFormatado.isNotEmpty ?
            'Prazo - ${tarefa.prazoFormatado}' :
            'Prazo - não cadastrado'),
          );
        },
        separatorBuilder: (BuildContext context, int index) => Divider(),

    );
  }
}