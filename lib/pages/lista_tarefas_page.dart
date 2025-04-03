import 'package:flutter/material.dart';
import 'package:gerenciador_tarefas_si7/dao/tarefa_dao.dart';
import 'package:gerenciador_tarefas_si7/model/tarefa.dart';
import 'package:gerenciador_tarefas_si7/pages/filtro_page.dart';
import 'package:gerenciador_tarefas_si7/widgets/conteudo_form_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListaTarefasPage extends StatefulWidget{

  @override
  _ListaTarefasPageState createState() => _ListaTarefasPageState();
}

class _ListaTarefasPageState extends State<ListaTarefasPage>{

  //Controladores
  static const ACAO_EDITAR = 'editar';
  static const ACAO_EXCLUIR = 'excluir';

  final tarefas = <Event> [];
  final _dao = EventDao();

  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefoneController = TextEditingController();

  final _ruaController = TextEditingController();
  final _numeroController = TextEditingController();
  final _bairroController = TextEditingController();
  final _cepController = TextEditingController();

  String? _estadoSelecionado;
  String? _cidadeSelecionada;

  final List<String> _estados = [
    'AC', 'AL', 'AP', 'AM', 'BA', 'CE', 'DF', 'ES', 'GO',
    'MA', 'MT', 'MS', 'MG', 'PA', 'PB', 'PR', 'PE', 'PI',
    'RJ', 'RN', 'RS', 'RO', 'RR', 'SC', 'SP', 'SE', 'TO'
  ];

  final Map<String, List<String>> _cidadesPorEstado = {
    'AC': ['Rio Branco', 'Cruzeiro do Sul', 'Sena Madureira'],
    'AL': ['Maceió', 'Arapiraca', 'Rio Largo'],
    'AP': ['Macapá', 'Santana', 'Laranjal do Jari'],
    'AM': ['Manaus', 'Parintins', 'Itacoatiara'],
    'BA': ['Salvador', 'Feira de Santana', 'Vitória da Conquista'],
    'CE': ['Fortaleza', 'Caucaia', 'Juazeiro do Norte'],
    'DF': ['Brasília', 'Ceilândia', 'Taguatinga'],
    'ES': ['Vitória', 'Vila Velha', 'Serra'],
    'GO': ['Goiânia', 'Aparecida de Goiânia', 'Anápolis'],
    'MA': ['São Luís', 'Imperatriz', 'São José de Ribamar'],
    'MT': ['Cuiabá', 'Várzea Grande', 'Rondonópolis'],
    'MS': ['Campo Grande', 'Dourados', 'Três Lagoas'],
    'MG': ['Belo Horizonte', 'Uberlândia', 'Contagem'],
    'PA': ['Belém', 'Ananindeua', 'Santarém'],
    'PB': ['João Pessoa', 'Campina Grande', 'Santa Rita'],
    'PR': ['Curitiba', 'Londrina', 'Maringá','Pato Branco','Palmas'],
    'PE': ['Recife', 'Jaboatão dos Guararapes', 'Olinda'],
    'PI': ['Teresina', 'Parnaíba', 'Picos'],
    'RJ': ['Rio de Janeiro', 'São Gonçalo', 'Duque de Caxias'],
    'RN': ['Natal', 'Mossoró', 'Parnamirim'],
    'RS': ['Porto Alegre', 'Caxias do Sul', 'Pelotas'],
    'RO': ['Porto Velho', 'Ji-Paraná', 'Ariquemes'],
    'RR': ['Boa Vista', 'Rorainópolis', 'Caracaraí'],
    'SC': ['Florianópolis', 'Joinville', 'Blumenau'],
    'SP': ['São Paulo', 'Guarulhos', 'Campinas'],
    'SE': ['Aracaju', 'Nossa Senhora do Socorro', 'Lagarto'],
    'TO': ['Palmas', 'Araguaína', 'Gurupi']
  };

  List<String> _cidadesDoEstadoSelecionado = [];
  // Lista para armazenar cadastros de pessoas
  final List<Map<String, dynamic>> _pessoasCadastradas = [];

  @override
  void initState(){
    super.initState();
    _atualizarLista();
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _telefoneController.dispose();
    _ruaController.dispose();
    _numeroController.dispose();
    _bairroController.dispose();
    _cepController.dispose();
    super.dispose();
  }

  void _atualizarLista() async{
    final prefs = await SharedPreferences.getInstance();
    final campoOrdenacao = prefs.getString(FiltroPage.CHAVE_CAMPO_ORDENACAO) ?? Event.CAMPO_ID;
    final usarOrdemDecrescente = prefs.getBool(FiltroPage.CHAVE_ORDENAR_DECRESCENTE) == true;
    final filtroDescricao = prefs.getString(FiltroPage.CHAVE_FILTRO_DESCRICAO) ?? '';

    final buscarTarefa = await _dao.listar(
        filtro: filtroDescricao,
        campoOrdenacao: campoOrdenacao,
        usarOrdemDecrescente: usarOrdemDecrescente
    );
    setState(() {
      tarefas.clear();
      if(buscarTarefa.isNotEmpty){
        tarefas.addAll(buscarTarefa);
      }
    });
  }

  void _atualizarCidades(String estado) {
    setState(() {
      _estadoSelecionado = estado;
      _cidadesDoEstadoSelecionado = _cidadesPorEstado[estado] ?? [];
      _cidadeSelecionada = null;
    });
  }

  @override
  Widget build (BuildContext context){
    return Scaffold(
      appBar: _criarAppBar(),
      drawer: _criarDrawerCadastro(),
      body: _criarBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: _abrirForm,
        tooltip: 'Novo Evento',
        child: const Icon(Icons.add),
      ),
    );
  }

  AppBar _criarAppBar() {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      leading: Builder(
        builder: (context) => IconButton(
          icon: Icon(Icons.menu),
          tooltip: 'Menu de cadastro',
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
      ),
      centerTitle: true,
      title: const Text('Go Event'),
      actions: [
        IconButton(
            onPressed: _abrirFiltro,
            icon: const Icon(Icons.filter_list)
        )
      ],

    );
  }

  Widget _criarDrawerCadastro() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Menu de Cadastro',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Gerencie seus cadastros',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person_add, color: Colors.blue),
            title: const Text('Novo Cadastro'),
            subtitle: const Text('Adicione um novo cadastro'),
            onTap: () {
              Navigator.pop(context); // Fecha o drawer
              _abrirModalCadastro();
            },
          ),
          ListTile(
            leading: const Icon(Icons.people, color: Colors.green),
            title: const Text('Visualizar Cadastros'),
            subtitle: const Text('Veja todos os cadastros realizados'),
            onTap: () {
              Navigator.pop(context); // Fecha o drawer
              _mostrarListaCadastros();
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline, color: Colors.orange),
            title: const Text('Sobre'),
            onTap: () {
              Navigator.pop(context);
              // Mostrar informações sobre o app
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Sobre o App'),
                  content: const Text('Go Event - Seu app de gestão de eventos'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _abrirModalCadastro() {
    _nomeController.clear();
    _emailController.clear();
    _telefoneController.clear();
    _ruaController.clear();
    _numeroController.clear();
    _bairroController.clear();
    _cepController.clear();

    setState(() {
      _estadoSelecionado = null;
      _cidadeSelecionada = null;
      _cidadesDoEstadoSelecionado = [];
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: const Row(
                  children: [
                    Icon(Icons.person_add, color: Colors.blue),
                    SizedBox(width: 10),
                    Text('Cadastro'),
                  ],
                ),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Dados pessoais
                      const Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Dados Pessoais',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      TextField(
                        controller: _nomeController,
                        decoration: const InputDecoration(
                          labelText: 'Nome',
                          icon: Icon(Icons.person),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          icon: Icon(Icons.email),
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _telefoneController,
                        decoration: const InputDecoration(
                          labelText: 'Telefone',
                          icon: Icon(Icons.phone),
                        ),
                        keyboardType: TextInputType.phone,
                      ),

                      // Divisor
                      const Divider(height: 25),

                      const Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Endereço',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      TextField(
                        controller: _ruaController,
                        decoration: const InputDecoration(
                          labelText: 'Rua',
                          icon: Icon(Icons.route),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Flexible(
                            flex: 1,
                            child: TextField(
                              controller: _numeroController,
                              decoration: const InputDecoration(
                                labelText: 'Número',
                                icon: Icon(Icons.tag),
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Flexible(
                            flex: 2,
                            child: TextField(
                              controller: _cepController,
                              decoration: const InputDecoration(
                                labelText: 'CEP',
                                prefixIcon: Icon(Icons.local_post_office),
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _bairroController,
                        decoration: const InputDecoration(
                          labelText: 'Bairro',
                          icon: Icon(Icons.location_on),
                        ),
                      ),
                      const SizedBox(height: 15),

                      // Dropdown para Estado
                      Row(
                        children: [
                          const Icon(Icons.map, color: Colors.black54),
                          const SizedBox(width: 16),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              decoration: const InputDecoration(
                                labelText: 'Estado',
                                border: OutlineInputBorder(),
                              ),
                              value: _estadoSelecionado,
                              hint: const Text('Selecione o Estado'),
                              items: _estados.map((String estado) {
                                return DropdownMenuItem<String>(
                                  value: estado,
                                  child: Text(estado),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _estadoSelecionado = newValue;
                                  if (newValue != null) {
                                    _cidadesDoEstadoSelecionado = _cidadesPorEstado[newValue] ?? [];
                                    _cidadeSelecionada = null;
                                  }
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),

                      // Dropdown para Cidade
                      Row(
                        children: [
                          const Icon(Icons.location_city, color: Colors.black54),
                          const SizedBox(width: 16),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              decoration: const InputDecoration(
                                labelText: 'Cidade',
                                border: OutlineInputBorder(),
                                hintStyle: TextStyle(color: Colors.grey),
                              ),
                              value: _cidadeSelecionada,
                              hint: Text(
                                  _estadoSelecionado == null
                                      ? 'Selecione um estado primeiro'
                                      : 'Selecione a Cidade'
                              ),
                              items: _cidadesDoEstadoSelecionado.map((String cidade) {
                                return DropdownMenuItem<String>(
                                  value: cidade,
                                  child: Text(cidade),
                                );
                              }).toList(),
                              onChanged: _estadoSelecionado == null
                                  ? null
                                  : (String? newValue) {
                                setState(() {
                                  _cidadeSelecionada = newValue;
                                });
                              },
                              isExpanded: true,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancelar'),
                  ),
                  TextButton(
                    onPressed: () {
                      if (_validarFormulario()) {
                        _salvarCadastroPessoa();
                        Navigator.of(context).pop();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Por favor, preencha os campos que estão em branco'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    child: const Text('Salvar'),
                  ),
                ],
              );
            }
        );
      },
    );
  }

  bool _validarFormulario() {
    // Validações básicas
    if (_nomeController.text.isEmpty) return false;
    if (_emailController.text.isEmpty) return false;
    if (_telefoneController.text.isEmpty) return false;
    if (_estadoSelecionado == null || _cidadeSelecionada == null) return false;

    return true;
  }

  void _salvarCadastroPessoa() {
    final nome = _nomeController.text;
    final email = _emailController.text;
    final telefone = _telefoneController.text;

    // Capturar dados de endereço
    final rua = _ruaController.text;
    final numero = _numeroController.text;
    final bairro = _bairroController.text;
    final cep = _cepController.text;
    final cidade = _cidadeSelecionada ?? '';
    final estado = _estadoSelecionado ?? '';

    // Formatar o endereço completo para exibição
    final enderecoCompleto =
        '$rua, $numero - $bairro\n$cidade/$estado - CEP: $cep';

    // Criar uma estrutura de dados para a pessoa cadastrada
    final pessoa = {
      'nome': nome,
      'email': email,
      'telefone': telefone,
      'endereco': {
        'rua': rua,
        'numero': numero,
        'bairro': bairro,
        'cep': cep,
        'cidade': cidade,
        'estado': estado,
      },
      'enderecoCompleto': enderecoCompleto,
      'dataCadastro': DateTime.now(),
    };

    // Adicionar a pessoa à lista de cadastros
    setState(() {
      _pessoasCadastradas.add(pessoa);
    });

    // Mensagem de confirmação
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Cadastro realizado com sucesso: $nome'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _mostrarListaCadastros() {
    if (_pessoasCadastradas.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nenhum cadastro encontrado'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.people, color: Colors.green),
              SizedBox(width: 10),
              Text('Cadastros Realizados'),
            ],
          ),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _pessoasCadastradas.length,
              itemBuilder: (context, index) {
                final pessoa = _pessoasCadastradas[index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: Text(pessoa['nome'][0].toUpperCase()),
                    ),
                    title: Text(pessoa['nome']),
                    subtitle: Text(pessoa['email']),
                    trailing: IconButton(
                      icon: const Icon(Icons.info_outline),
                      onPressed: () {
                        _mostrarDetalhesCadastro(pessoa);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Fechar'),
            ),
          ],
        );
      },
    );
  }

  void _mostrarDetalhesCadastro(Map<String, dynamic> pessoa) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              const Icon(Icons.person, color: Colors.blue),
              const SizedBox(width: 10),
              Text('Detalhes - ${pessoa['nome']}'),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Divider(),
                const Text(
                  'Dados Pessoais',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                _itemDetalhe('Nome', pessoa['nome']),
                _itemDetalhe('Email', pessoa['email']),
                _itemDetalhe('Telefone', pessoa['telefone']),

                const Divider(),
                const Text(
                  'Endereço',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                _itemDetalhe('Rua', pessoa['endereco']['rua']),
                _itemDetalhe('Número', pessoa['endereco']['numero']),
                _itemDetalhe('Bairro', pessoa['endereco']['bairro']),
                _itemDetalhe('CEP', pessoa['endereco']['cep']),
                _itemDetalhe('Cidade', pessoa['endereco']['cidade']),
                _itemDetalhe('Estado', pessoa['endereco']['estado']),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Fechar'),
            ),
          ],
        );
      },
    );
  }

  Widget _itemDetalhe(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  Widget _criarBody() {
    if (tarefas.isEmpty){
      return const Center(
        child: Text('Nenhum Evento Cadastrado',
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
              _abrirForm(tarefaAtual: tarefa);
            }else{
              _excluir(tarefa);
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
        _atualizarLista();
      }
    }
    );
  }

  void _excluir (Event event){
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
                    if (event == null){
                      return;
                    }
                    _dao.remover(event.id!).then((sucess){
                      if (sucess){
                        _atualizarLista();
                      }
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

  void _abrirForm({Event? tarefaAtual}){
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
                    Navigator.of(context).pop();
                    final novaTarefa = key.currentState!.novoEvent;
                    _dao.salvar(novaTarefa).then((sucess){
                      if (sucess){
                        _atualizarLista();
                      }
                    });
                  }
                },
              )
            ],
          );
        }
    );
  }
}