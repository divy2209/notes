import 'package:flutter/material.dart';
import 'package:notes/edit_note_page.dart';
import 'package:notes/model/note.dart';
import 'package:notes/service/color_provider.dart';
import 'package:provider/provider.dart';

class AddEditNoteWrapper extends StatelessWidget {
  final Note? note;
  const AddEditNoteWrapper({Key? key, this.note}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ChooseColor>(
      create: (_) => ChooseColor(),
      child: AddEditNotePage(note: note),
    );
  }
}
