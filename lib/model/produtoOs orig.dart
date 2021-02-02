class ProdutoOs {
  // ignore: non_constant_identifier_names
  int cod_produto;
  int qtd;
  String desc;
  String numOs;
  String codOs;

  ProdutoOs({this.cod_produto, this.qtd, this.desc, this.numOs, this.codOs});

  ProdutoOs.fromJson(Map<String, dynamic> json) {
    cod_produto = json['Codigo_Produto'];
    qtd = json['Qtde'];
    desc = json['Descricao'];
    numOs = json['Numero_da_OS'];
    codOs = json['CodOS'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Codigo_Produto'] = this.cod_produto;
    data['Qtde'] = this.qtd;
    data['Descricao'] = this.desc;
    data['Numero_da_OS'] = this.numOs;
    data['CodOS'] = this.codOs;

    return data;
  }
}
