class Pessoa {
  int? id;
  String nome;
  String cpf;
  String credcard;

  Pessoa(
      {this.id, required this.nome, required this.cpf, required this.credcard});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'cpf': cpf,
      'credcard': credcard,
    };
  }

  factory Pessoa.fromMap(Map<String, dynamic> map) {
    return Pessoa(
      nome: map['nome'],
      cpf: map['cpf'],
      credcard: map['credcard'],
    );
  }
}
