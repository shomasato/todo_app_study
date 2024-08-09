import 'package:flutter/material.dart';

class NoteView extends StatelessWidget {
  const NoteView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextStyle? style = Theme.of(context).textTheme.titleMedium;
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 40.0, horizontal: 24.0),
              child: TextField(
                autofocus: true,
                maxLines: null,
                style: style,
                decoration: const InputDecoration(
                  hintText: 'Add Note',
                  border: InputBorder.none,
                ),
              ),
            ),
            Container(
              width: double.infinity,
              color: Theme.of(context).cardColor,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Center(
                    child: Text(
                      'OK',
                      style: style,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
