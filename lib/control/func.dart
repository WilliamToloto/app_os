import 'package:app_novo/model/produtoOs.dart';

Future loadProdutos1(response, produtosList1,
    dataExpirada, osCod) async {
  ProdutosList produtosList = ProdutosList.fromJson(response.data);
  print(produtosList.produtos[0].qtd);
  print(produtosList.produtos.length);
  produtosList1 = produtosList.produtos;
  print(produtosList1[0].desc);
  print(produtosList1[0].cod_produto);
  print(produtosList1[0].codProd);

  String dataPrevisao = produtosList.produtos[0].dataPrevisao;
  DateTime.parse(dataPrevisao);
  print(dataPrevisao);
  if (DateTime.now().isBefore(DateTime.parse(dataPrevisao))) {
    print("eh menor");
    dataExpirada = "n";
  } else {
    dataExpirada = "s";
  }
  osCod = produtosList.produtos[0].codOs;
}
