

import 'package:flutter/material.dart';
import 'package:gerenciador_tarefas_si7/model/tarefa.dart';
import 'package:gerenciador_tarefas_si7/pages/filtro_page.dart';
import 'package:gerenciador_tarefas_si7/widgets/conteudo_form_dialog.dart';

class ListaTarefasPage extends StatefulWidget{

  @override
  _ListaTarefasPageState createState() => _ListaTarefasPageState();
}

class _ListaTarefasPageState extends State<ListaTarefasPage>{

  static const ACAO_EDITAR = 'editar';
  static const ACAO_EXCLUIR = 'excluir';

  final tarefas = <Tarefa> [
  // Tarefa(id: 1, descricao: 'Tarefa avaliativa da disciplina'
   //, prazo: DateTime.now().add(const Duration(days: 5))
  //)
  ];

  var _ultimoId = 0;

  @override
  Widget build (BuildContext context){
    return Scaffold(
      appBar: _criarAppBar(),
      body: _criarBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: _abrirForm,
        tooltip: 'Nova Tarefa',
        child: const Icon(Icons.add),
      ),
    );
  }

  AppBar _criarAppBar() {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      centerTitle: true,
      title: const Text('Gerenciador de Tarefas'),
      actions: [
        IconButton(
            onPressed: _abrirFiltro,
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
          return PopupMenuButton<String>(
              child: ListTile(
                title: Text('${tarefa.id} - ${tarefa.descricao}'),
                subtitle: Text(tarefa.prazoFormatado.isNotEmpty ?
                'Prazo - ${tarefa.prazoFormatado}' :
                'Prazo - não cadastrado'),
              ),
            itemBuilder: (BuildContext context) => criarMenuPopUp(),
            onSelected: (String valorSelecionado){
                if (valorSelecionado == ACAO_EDITAR){
                  _abrirForm(tarefaAtual: tarefa, indice: index);
                }else{
                  _excluir(index);
                }
            },
          );
        },
        separatorBuilder: (BuildContext context, int index) => Divider(),

    );
  }

  void _abrirFiltro() {
    final navigator = Navigator.of(context);
    navigator.pushNamed(FiltroPage.ROUTE_NAME).then((alterouValores){
      if (alterouValores == true){
        /// TODO
      }
    }
    );
  }

  void _excluir (int indice){
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.warning, color: Colors.red),
                Padding(
                    padding: EdgeInsets.only(left: 10),
                  child: Text('Atenção'),
                ),
              ],
            ),
            content: const Text('Deseja realmente excluir esse registro?'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Não')
              ),
              TextButton(
                  onPressed: (){
                    Navigator.of(context).pop();
                    setState(() {
                      tarefas.removeAt(indice);
                    });
                  },
                  child: const Text('Sim')
              )
            ],
          );
        }
    );
  }

  List<PopupMenuEntry<String>> criarMenuPopUp(){
    return [
      const PopupMenuItem<String>(
        value: ACAO_EDITAR,
          child: Row(
            children: [
              Icon(Icons.edit, color: Colors.black),
              Padding(
                  padding: EdgeInsets.only(left: 10),
                child: Text('Editar'),
              )

            ],
          ),
      ),
      const PopupMenuItem<String>(
        value: ACAO_EXCLUIR,
        child: Row(
          children: [
            Icon(Icons.delete, color: Colors.red),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text('Excluir'),
            )

          ],
        ),
      ),
    ];
  }

  void _abrirForm({Tarefa? tarefaAtual, int? indice} ){
    final key = GlobalKey<ConteudoFormDialogState>();
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
              title: Text(tarefaAtual == null ? 'Nova tarefa':
              'Alterar a tarefa ${tarefaAtual.id}'),
            content: ConteudoFormDialog(key: key, tarefaAtual: tarefaAtual),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancelar'),
              ),
              TextButton(
              child: const Text('Salvar'),
                  onPressed: () {
                    if (key.currentState != null && key.currentState!.dadosValidados()) {
                      setState(() {
                        final novaTarefa = key.currentState!.novaTarefa;
                        if (indice == null){
                          novaTarefa.id = ++_ultimoId;
                          tarefas.add(novaTarefa);
                        }else{
                          tarefas[indice] = novaTarefa;
                        }
                      });
                    }
                    Navigator.of(context).pop();
                  },
              )
            ],
          );
        }
    );
  }

}