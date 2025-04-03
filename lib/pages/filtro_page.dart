

import 'package:flutter/material.dart';
import 'package:gerenciador_tarefas_si7/model/tarefa.dart';
import 'package:shared_preferences/shared_preferences.dart';
class FiltroPage extends StatefulWidget{

  static const ROUTE_NAME = '/filtro';
  static const  CHAVE_CAMPO_ORDENACAO = 'campoOrdenacao';
  static const  CHAVE_ORDENAR_DECRESCENTE = 'usarOrdemDecrescente';
  static const  CHAVE_FILTRO_DESCRICAO = 'filtroDescricao';

  @override
  _FiltroPageState createState() => _FiltroPageState();

}

@override
class _FiltroPageState extends State<FiltroPage>{
  final camposParaOrdenacao= {
    Event.CAMPO_ID: 'Código', Event.CAMPO_DESCRICAO: 'Descrição', Event.CAMPO_PRAZO: 'Data'
  };

  late final SharedPreferences prefs;
  final _descricaoController = TextEditingController();
  String _campoOrdenacao = Event.CAMPO_ID;
  bool _usarOrdemDecrescente = false;
  bool _alterouValores = false;

  @override
  void initState(){
    super.initState();
    _carregarSharedPreferences();
  }

  void _carregarSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      _campoOrdenacao = prefs.getString(FiltroPage.CHAVE_CAMPO_ORDENACAO) ??
          Event.CAMPO_ID;
      _usarOrdemDecrescente = prefs.getBool(FiltroPage.CHAVE_ORDENAR_DECRESCENTE) ??
      false;
      _descricaoController.text = prefs.getString(FiltroPage.CHAVE_FILTRO_DESCRICAO) ??
      '';
    });
  }

  @override
  Widget build(BuildContext context){
    return WillPopScope(
      onWillPop: _onVoltarClick,
      child: Scaffold(
        appBar: AppBar(
            centerTitle: false,
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            title: const Text('Filtro e Ordenação')
        ),
        body: _criaBody(),
      ),
    );
  }

  Widget _criaBody(){
    return ListView(
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 10, top: 10),
          child: Text('Campos para ordenação'),
        ),
        for (final campo in camposParaOrdenacao.keys)
          Row(
            children: [
              Radio(
                value: campo,
                groupValue: _campoOrdenacao,
                onChanged: _onCampoOrdenacaoChanged,
              ),
              Text(camposParaOrdenacao[campo] ?? ''),
            ],
          ),
        const Divider(),
        Row(
          children: [
            Checkbox(
              value: _usarOrdemDecrescente,
              onChanged: _onUsarOrdemDecrescenteChange,
            ),
            const Text('Usar ordem descrescente')
          ],
        ),
        const Divider(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: TextField(
            decoration: const InputDecoration(labelText: 'A descriçao começa com:'),
            controller: _descricaoController,
            onChanged: _onFiltroDescricaoChange,
          ),
        ),
        const Divider(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: TextField(
            decoration: const InputDecoration(labelText: 'Escolha uma cidade:'),
            controller: _descricaoController,
            onChanged: _onFiltroDescricaoChange,
          ),
        ),
      ],
    );
  }

  Future<bool> _onVoltarClick() async{
    Navigator.of(context).pop(_alterouValores);
    return true;
  }

  void _onFiltroDescricaoChange(String? valor){
    prefs.setString(FiltroPage.CHAVE_FILTRO_DESCRICAO, valor ?? '');
    _alterouValores = true;
  }

  void _onCampoOrdenacaoChanged(String? valor){
    prefs.setString(FiltroPage.CHAVE_CAMPO_ORDENACAO, valor ?? '');
    _alterouValores = true;
    setState(() {
      _campoOrdenacao = valor ?? '';
    });
  }

  void _onUsarOrdemDecrescenteChange(bool? valor){
    prefs.setBool(FiltroPage.CHAVE_ORDENAR_DECRESCENTE, valor == true);
    _alterouValores = true;
    setState(() {
      _usarOrdemDecrescente = valor == true;
    });
  }

}