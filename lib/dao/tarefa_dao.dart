

import 'package:gerenciador_tarefas_si7/database/database_provider.dart';

import '../model/tarefa.dart';

class EventDao{
  final dbProvider = DatabaseProvider.instance;

  Future<bool> salvar(Event event) async{
    final db = await dbProvider.database;
    final valores = event.toMap();
    if (event.id == null){
      event.id = await db.insert(Event.nomeTabela, valores);
      return true;
    }else{
      final registrosAtualizados = await db.update(Event.nomeTabela, valores,
      where: '${Event.CAMPO_ID} = ?', whereArgs: [event.id]);
      return registrosAtualizados > 0;
    }
  }

  Future<bool> remover (int id) async{
    final db = await dbProvider.database;
    final registrosAtualizados = await db.delete(Event.nomeTabela,
    where:  '${Event.CAMPO_ID} = ?', whereArgs: [id]);
    return registrosAtualizados > 0;
  }

  Future<List<Event>> listar({
    String filtro = '',
    String campoOrdenacao = Event.CAMPO_ID,
    bool usarOrdemDecrescente = false,
}) async{
    String? where;
    if (filtro.isNotEmpty){
      where = "UPPER(${Event.CAMPO_DESCRICAO}) LIKE '${filtro.toUpperCase()}'";
    }

    var oderBy = campoOrdenacao;
    if (usarOrdemDecrescente){
      oderBy += ' DESC';
    }

    final db = await dbProvider.database;
    final resultado = await db.query(Event.nomeTabela,
        columns: [Event.CAMPO_ID, Event.CAMPO_DESCRICAO, Event.CAMPO_PRAZO],
        where: where,
        orderBy: oderBy,
    );
    return resultado.map((m) => Event.fromMap(m)).toList();
  }
}