import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class MyWidget extends HookWidget {
  Future<List<String>> loadFuncionarios = Future<List<String>>.delayed(
    Duration(seconds: 2),
    () => ['A', 'B', 'C'],
  );

  @override
  Widget build(BuildContext context) {
    final _choice = useState('C');
    return FutureBuilder<List<String>>(
      future: loadFuncionarios,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? DropdownButton(
                isExpanded: true,
                iconEnabledColor: Colors.blue[900],
                value: _choice.value,
                items: snapshot.data
                    .map(
                      (funcionario) => DropdownMenuItem(
                        value: funcionario,
                        child: Text(funcionario),
                      ),
                    )
                    .toList(),
                onChanged: (value) => _choice.value = value,
              )
            : Text('Loading...');
      },
    );
  }
}
