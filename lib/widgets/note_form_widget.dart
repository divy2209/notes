import 'package:flutter/material.dart';

class NoteFormWidget extends StatelessWidget {
  final bool? isImportant;
  final int? number;
  final String? title;
  final String? description;
  final ValueChanged<String> onChangedTitle;
  final ValueChanged<String> onChangedDescription;

  const NoteFormWidget({
    Key? key,
    this.isImportant = false,
    this.number = 0,
    this.title = "",
    this.description = "",
    required this.onChangedTitle,
    required this.onChangedDescription
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            buildTitle(),
            const SizedBox(height: 8,),
            buildDescription(),
            const SizedBox(height: 16,)
          ],
        ),
      ),
    );
  }

  Widget buildTitle() => TextFormField(
    cursorColor: Colors.white,
    maxLines: 1,
    initialValue: title,
    style: const TextStyle(
      color: Colors.white70,
      fontWeight: FontWeight.bold,
      fontSize: 24
    ),
    decoration: const InputDecoration(
      border: InputBorder.none,
      hintText: 'Title',
      hintStyle: TextStyle(color: Colors.white70)
    ),
    validator: (title) =>
        title != null && title.isEmpty ? 'The title cannot be empty' : null,
    onChanged: onChangedTitle,
  );

  Widget buildDescription() => TextFormField(

    cursorColor: Colors.white,
    maxLines: null,
    initialValue: description,
    style: const TextStyle(color: Colors.white60, fontSize: 18),
    decoration: const InputDecoration(
      border: InputBorder.none,
      hintText: 'Type something....',
      hintStyle: TextStyle(color: Colors.white60)
    ),
    validator: (title) => title != null && title.isEmpty
      ? 'The description cannot be empty'
      : null,
    onChanged: onChangedDescription,
  );
}
