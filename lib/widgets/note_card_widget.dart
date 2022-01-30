import 'package:flutter/material.dart';
import 'package:notes/model/note.dart';
import 'package:notes/service/config.dart';

class NoteCardWidget extends StatelessWidget {
  final Note note;

  const NoteCardWidget({
    Key? key,
    required this.note,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = lightColors[note.number];
    //final dots = getDescription(note.description);

    return Card(
      color: color,
      elevation: 0,
      child: Container(
        constraints: const BoxConstraints(maxHeight: 265),
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //const SizedBox(height: 4,),
            note.title.isNotEmpty ? Text(
              note.title,
              maxLines: 2,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700
              ),
              overflow: TextOverflow.ellipsis,
            ) : const SizedBox(),
            const SizedBox(height: 8,),
            note.description.isNotEmpty ? Text(
              note.description,
              maxLines: 10,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
              ),
              overflow: TextOverflow.ellipsis,
            ) : const SizedBox()
          ],
        ),
      ),
    );
  }

  // https://stackoverflow.com/questions/54091055/flutter-how-to-get-the-number-of-text-lines
  /*String getDescription(String str) {
    // Not the right way, in case of new lines, this will differ a lot
    final span = TextSpan(text: str, style: const TextStyle(fontSize: 16));
    final tp = TextPainter(text: span, maxLines: 10);
    return tp.didExceedMaxLines ? "..." : "";
  }*/
}
