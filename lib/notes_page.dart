import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:notes/database/notes_database.dart';
import 'package:notes/edit_wrapper.dart';
import 'package:notes/widgets/note_card_widget.dart';

import 'model/note.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({Key? key}) : super(key: key);

  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  //late List<Note> notes;
  late List<Note> pinnedNotes;
  late List<Note> unPinnedNotes;
  late int len;
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    refreshNotes();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    NotesDatabase.instance.close();

    super.dispose();
  }

  Future refreshNotes() async {
    setState(() {
      isLoading = true;
    });

    //notes = await NotesDatabase.instance.readAllNotes();
    pinnedNotes = await NotesDatabase.instance.readPinnedNotes();
    unPinnedNotes = await NotesDatabase.instance.readUnPinnedNotes();
    len = pinnedNotes.length+unPinnedNotes.length;

    setState(() {
      isLoading = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes', style: TextStyle(fontSize: 24),),
        //actions: const [Icon(Icons.search), SizedBox(width: 12,)],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : len==0
              ? const Center(child: Text('No Notes', style: TextStyle(color: Colors.white, fontSize: 24),))
              : buildNotesPage(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (context)=>const AddEditNoteWrapper())
          );

          refreshNotes();
        },
      ),
    );
  }

  Widget buildNotesPage() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          pinnedNotes.isNotEmpty ? const Padding(
            padding: EdgeInsets.only(left: 22),
            child: Text("Pinned", style: TextStyle(color: Colors.white),),
          ) : const SizedBox(),
          pinnedNotes.isNotEmpty ? buildNotes(pinnedNotes) : const SizedBox(),
          unPinnedNotes.isNotEmpty ? const Padding(
            padding: EdgeInsets.only(left: 22),
            child: Text("Others", style: TextStyle(color: Colors.white),),
          ) : const SizedBox(),
          unPinnedNotes.isNotEmpty ? buildNotes(unPinnedNotes) : const SizedBox()
        ],
      ),
    );
  }
  Widget buildNotes(List<Note> list) => StaggeredGridView.countBuilder(
    physics: const BouncingScrollPhysics(),
    shrinkWrap: true,
    padding: const EdgeInsets.all(8),
    itemCount: list.length,
    staggeredTileBuilder: (index) => const StaggeredTile.fit(2),
    crossAxisCount: 4,
    mainAxisSpacing: 4,
    crossAxisSpacing: 4,
    itemBuilder: (context, index){
      final note = list[index];

      return InkWell(
        splashFactory: InkRipple.splashFactory,
        onTap: () async {
          await Navigator.of(context).push(
              MaterialPageRoute(builder: (context)=>AddEditNoteWrapper(note: note))
          );

          refreshNotes();
        },
        child: NoteCardWidget(note: note),
      );
    },
  );
}
