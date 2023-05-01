import 'package:flutter/material.dart';

class PrimaryLabel extends StatelessWidget {
  const PrimaryLabel({Key? key, this.value = ""}) : super(key: key);
  final String value;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Material(
        color: Theme
            .of(context)
            .primaryColor
            .withAlpha(30),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            value,
            style: Theme
                .of(context)
                .textTheme
                .bodySmall!,
          ),
        ),
      ),
    );
  }
}
