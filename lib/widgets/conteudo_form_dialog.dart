

import 'package:flutter/material.dart';

import '../model/tarefa.dart';

class ConteudoFormDialog extends StatefulWidget{
  final Tarefa? tarefaAtual;

  ConteudoFormDialog({ Key? key, this.tarefaAtual}) : super(key: key);

  @override
  ConteudoFormDialogState createState() => ConteudoFormDialogState();
}

class ConteudoFormDialogState extends State<ConteudoFormDialog>{

}