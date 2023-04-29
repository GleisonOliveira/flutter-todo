import 'package:flutter/material.dart';

class Notes extends StatelessWidget {
  const Notes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        LayoutBuilder(
          builder: (BuildContext context, BoxConstraints contraints) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
              constraints: BoxConstraints(
                minWidth: 150,
                minHeight: 150,
                maxHeight: contraints.maxHeight - 50,
                maxWidth: contraints.maxWidth - 100,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Material(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              icon: Icon(Icons.arrow_back),
                            ),
                            const Text("Notas"),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
