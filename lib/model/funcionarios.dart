class FuncionariosList {
  final List<Funcionarios> funcionarios;

  FuncionariosList({
    this.funcionarios,
  });

  factory FuncionariosList.fromJson(List<dynamic> parsedJson) {
    List<Funcionarios> funcionarios = new List<Funcionarios>();
    funcionarios = parsedJson.map((i) => Funcionarios.fromJson(i)).toList();

    return new FuncionariosList(
      funcionarios: funcionarios,
    );
  }
}

class Funcionarios {
  final int codigo;
  final String nome;

  Funcionarios({this.codigo, this.nome});

  factory Funcionarios.fromJson(Map<String, dynamic> json) {
    return new Funcionarios(codigo: json['Codigo'], nome: json['Nome']);
  }
}
