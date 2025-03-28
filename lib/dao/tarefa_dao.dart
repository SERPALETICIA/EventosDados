

import 'package:gerenciador_tarefas_si7/database/database_provider.dart';

import '../model/tarefa.dart';

class TarefaDao{
  final dbProvider = DatabaseProvider.instance;

  Future<bool> salvar(Tarefa tarefa) async{
    final db = await dbProvider.database;
    final valores = tarefa.toMap();
    if (tarefa.id == null){
      tarefa.id = await db.insert(Tarefa.nomeTabela, valores);
      return true;
    }else{
      final registrosAtualizados = await db.update(Tarefa.nomeTabela, valores,
      where: '${Tarefa.CAMPO_ID} = ?', whereArgs: [tarefa.id]);
      return registrosAtualizados > 0;
    }
  }

  Future<bool> remover (int id) async{
    final db = await dbProvider.database;
    final registrosAtualizados = await db.delete(Tarefa.nomeTabela,
    where:  '${Tarefa.CAMPO_ID} = ?', whereArgs: [id]);
    return registrosAtualizados > 0;
  }

  Future<List<Tarefa>> listar({
    String filtro = '',
    String campoOrdenacao = Tarefa.CAMPO_ID,
    bool usarOrdemDecrescente = false,
}) async{
    String? where;
    if (filtro.isNotEmpty){
      where = "UPPER(${Tarefa.CAMPO_DESCRICAO}) LIKE '${filtro.toUpperCase()}'";
    }

    var oderBy = campoOrdenacao;
    if (usarOrdemDecrescente){
      oderBy += ' DESC';
    }

    final db = await dbProvider.database;
    final resultado = await db.query(Tarefa.nomeTabela,
        columns: [Tarefa.CAMPO_ID, Tarefa.CAMPO_DESCRICAO, Tarefa.CAMPO_PRAZO],
        where: where,
        orderBy: oderBy,
    );
    return resultado.map((m) => Tarefa.fromMap(m)).toList();
  }
}