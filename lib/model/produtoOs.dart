class ProdutosList {
  final List<ProdutoOs> produtos;

  ProdutosList({
    this.produtos,
  });

  factory ProdutosList.fromJson(List<dynamic> parsedJson) {
    List<ProdutoOs> produtos = new List<ProdutoOs>();
    produtos = parsedJson.map((i) => ProdutoOs.fromJson(i)).toList();

    return new ProdutosList(
      produtos: produtos,
    );
  }
}

class ProdutoOs {
  // ignore: non_constant_identifier_names
  final String cod_produto;
  final String codProd;
  final String qtd;
  final String desc;
  final String numOs;
  final int codOs;
  final int codFuncionario;
  final String funcionario;
  final String cliente;
  final String status;
  final String dataPrevisao;

  // ignore: non_constant_identifier_names
  ProdutoOs(
      {this.cod_produto,
      this.codProd,
      this.qtd,
      this.desc,
      this.numOs,
      this.codOs,
      this.codFuncionario,
      this.funcionario,
      this.cliente,
      this.status,
      this.dataPrevisao});

  factory ProdutoOs.fromJson(Map<String, dynamic> json) {
    return new ProdutoOs(
        cod_produto: json['Codigo_Produto'].toString(),
        codProd: json['CodProd'],
        qtd: json['Qtde'].toString(),
        desc: json['Descricao'],
        numOs: json['Numero_da_OS'],
        codOs: json['CodOS'],
        codFuncionario: json['CodFuncionario'],
        funcionario: json['Nomefuncionario'],
        cliente: json['Cliente'],
        status: json['status'],
        dataPrevisao: json['DataPrevisao'].toString());
  }
}

//   ProdutoOs.fromJson(Map<String, dynamic> json) {
//     cod_produto = json['Codigo_Produto'];
//     qtd = json['Qtde'];
//     desc = json['Descricao'];
//     numOs = json['Numero_da_OS'];
//     codOs = json['CodOS'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['Codigo_Produto'] = this.cod_produto;
//     data['Qtde'] = this.qtd;
//     data['Descricao'] = this.desc;
//     data['Numero_da_OS'] = this.numOs;
//     data['CodOS'] = this.codOs;

//     return data;
//   }
// }
