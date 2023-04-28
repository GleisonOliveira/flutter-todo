import 'package:flutter/material.dart';

class Empty extends StatelessWidget {
  const Empty({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 80),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.info,
            size: 60,
            color: Colors.grey.shade300,
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            "Sua lista está vazia, tente adicionar alguma tarefa.",
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
