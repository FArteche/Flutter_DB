import 'package:flutter/material.dart';
import 'package:trabalho_2/Pessoa.dart';
import 'package:trabalho_2/PessoaDAO.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "SQLite CRUD",
      home: Pagina1(),
    );
  }
}

class Pagina1 extends StatefulWidget {
  const Pagina1({super.key});
  @override
  State<Pagina1> createState() => _Pagina1State();
}

class _Pagina1State extends State<Pagina1> {
  final Pessoadao _pessoaDAO = Pessoadao();

  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _cpfcontroller = TextEditingController();
  final TextEditingController _cartaoController = TextEditingController();

  Pessoa? _pessoaAtual;

  @override
  void initState() {
    super.initState();
    _loadPessoas();
  }

  List<Pessoa> _listaPessoas = [];

  void _loadPessoas() async {
    List<Pessoa> listaTemp = await _pessoaDAO.selectPessoa();
    setState(() {
      _listaPessoas = listaTemp;
    });
  }

  void _editarPessoa(Pessoa pessoa) {
    setState(
      () {
        _pessoaAtual = pessoa;
        _nomeController.text = pessoa.nome;
        _cpfcontroller.text = pessoa.cpf;
        _cartaoController.text = pessoa.credcard;
      },
    );
  }

  Future<void> _deletePessoa(int index) async {
    await _pessoaDAO.deletePessoa(
      Pessoa(
        id: index,
        nome: '',
        cpf: '',
        credcard: '',
      ),
    );
    _loadPessoas();
  }

  Future<void> _salvarOuEditar() async {
    if (_pessoaAtual == null) {
      await _pessoaDAO.insertPessoa(
        Pessoa(
            nome: _nomeController.text,
            cpf: _cpfcontroller.text,
            credcard: _cartaoController.text),
      );
    } else {
      _pessoaAtual?.nome = _nomeController.text;
      _pessoaAtual?.cpf = _cpfcontroller.text;
      _pessoaAtual?.credcard = _cartaoController.text;
      await _pessoaDAO.updatePessoa(_pessoaAtual!);
    }
    _nomeController.clear();
    _cpfcontroller.clear();
    _cartaoController.clear();
    setState(
      () {
        _pessoaAtual = null;
      },
    );
    _loadPessoas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AppBar?'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: _nomeController,
              decoration: const InputDecoration(labelText: 'Nome'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: _cpfcontroller,
              decoration: const InputDecoration(labelText: 'CPF'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: _cartaoController,
              decoration: const InputDecoration(labelText: 'Nº Cartao'),
            ),
          ),
          ElevatedButton(
            onPressed: _salvarOuEditar,
            child: Text(_pessoaAtual == null ? 'Salvar' : 'Atualizar'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _listaPessoas.length,
              itemBuilder: (context, index) {
                final Pessoa pessoa = _listaPessoas[index];
                return ListTile(
                  title: Text('Nome: ${pessoa.nome} - CPF: ${pessoa.cpf}'),
                  trailing: IconButton(
                    onPressed: () {
                      _deletePessoa(pessoa.id!);
                    },
                    icon: const Icon(Icons.delete),
                  ),
                  onTap: () {
                    _editarPessoa(pessoa);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
