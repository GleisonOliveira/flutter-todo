import 'package:flutter/material.dart';

class DividedRow extends StatelessWidget {
  final Function()? onTap;
  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;

  const DividedRow(
      {Key? key,
      this.onTap,
      required this.children,
      this.mainAxisAlignment = MainAxisAlignment.spaceBetween})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 18,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                mainAxisAlignment: mainAxisAlignment!,
                children: children,
              ),
            ),
            const Divider(
              height: 1,
            ),
          ],
        ),
      ),
    );
  }
}
