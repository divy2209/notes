import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes/database/notes_database.dart';
import 'package:notes/service/color_provider.dart';
import 'package:notes/service/config.dart';
import 'package:notes/widgets/note_form_widget.dart';
import 'package:provider/provider.dart';

import 'model/note.dart';

class AddEditNotePage extends StatefulWidget {
  final Note? note;

  const AddEditNotePage({
    Key? key,
    this.note
  }) : super(key: key);

  @override
  _AddEditNotePageState createState() => _AddEditNotePageState();
}

class _AddEditNotePageState extends State<AddEditNotePage> {
  final _formKey = GlobalKey<FormState>();
  late bool isImportant;
  late int number;
  late String title;
  late String description;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    isImportant = widget.note?.isImportant ?? false;
    number = widget.note?.number ?? 0;
    title = widget.note?.title ?? '';
    description = widget.note?.description ?? '';
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var data = Provider.of<ChooseColor>(context, listen: false);
    data.assign(number);
    return WillPopScope(
      onWillPop: addOrUpdateNote,
      child: Consumer<ChooseColor>(
        builder: (_,__,___){
          return Scaffold(
            backgroundColor: lightColors.elementAt(number),
            appBar: AppBar(
              actions: [pinButton(), deleteButton()],
            ),
            bottomNavigationBar: Transform.translate(
              offset: Offset(0.0, -1 * MediaQuery.of(context).viewInsets.bottom),
              child: SizedBox(
                height: 60,
                width: size.width,
                child: Center(
                  child: Row(
                    children: [
                      SizedBox(width: size.width*0.02,),
                      colorButton(),
                      SizedBox(width: size.width*0.22,),
                      Text("Created " + DateFormat.yMMMd().format(widget.note?.createdTime ?? DateTime.now()).toString(),
                        style: const TextStyle(color: Colors.white, fontSize: 13),)
                    ],
                  ),
                ),
              ),
            ),
            body: Form(
              key: _formKey,
              child: NoteFormWidget(
                  isImportant: isImportant,
                  number: number,
                  title: title,
                  description: description,
                  /*onChangedImportant: (isImportant) =>
                setState(() => this.isImportant = isImportant),*/
                  //onChangedNumber: (number) => setState(() => this.number = number),
                  onChangedTitle: (title) => setState(() => this.title = title),
                  onChangedDescription: (description) => setState(() => this.description = description)
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildButton() {
    final isFormValid = title.isNotEmpty && description.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          onPrimary: Colors.white,
          primary: isFormValid ? null : Colors.grey.shade700
        ),
        onPressed: addOrUpdateNote,
        child: const Text('Save'),
      ),
    );
  }

  void unFocus() {
    WidgetsBinding.instance!.focusManager.primaryFocus?.unfocus();
    /*FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      currentFocus.focusedChild!.unfocus();
    }*/
  }

  Future<bool> addOrUpdateNote() async {
    //final isValid = _formKey.currentState!.validate();
    if((title.isEmpty || title.trim().isEmpty) && (description.isEmpty || description.trim().isEmpty)){
      if(widget.note!=null){
        await NotesDatabase.instance.delete(widget.note!.id);
      }
    } else {
      final isUpdating = widget.note != null;

      if(isUpdating){
        await updateNote();
      } else {
        await addNote();
      }
    }

    Navigator.of(context).pop();
    unFocus();

    /*if(isValid){
      final isUpdating = widget.note != null;

      if(isUpdating){
        await updateNote();
      } else {
        await addNote();
      }
      Navigator.of(context).pop();
      unFocus();
    }*/
    return Future.value(false);
  }

  Future updateNote() async {
    final note = widget.note!.copy(
      isImportant: isImportant,
      number: number,
      title: title,
      description: description
    );

    await NotesDatabase.instance.update(note);
  }

  Future addNote() async {
    final note = Note(
      title: title,
      isImportant: isImportant,
      number: number,
      description: description,
      createdTime: DateTime.now()
    );

    await NotesDatabase.instance.create(note);
  }

  Widget deleteButton() => IconButton(
    icon: const Icon(Icons.delete),
    onPressed: () async {
      if(widget.note!=null) {
        await NotesDatabase.instance.delete(widget.note!.id);
      }
      Navigator.of(context).pop();
      unFocus();
    },
  );

  Widget pinButton() => IconButton(
    icon: isImportant ? const Icon(Icons.push_pin) : const Icon(Icons.push_pin_outlined),
    onPressed: () async {
      setState(() {
        isImportant = !isImportant;
      });
    },
  );

  Widget colorButton() => IconButton(
    icon: const Icon(Icons.palette_outlined, color: Colors.white, size: 26,),
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    hoverColor: Colors.transparent,
    onPressed: (){
      unFocus();
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setModalState){
              return Material(
                color: lightColors.elementAt(number),
                child: SizedBox(
                  height: 120,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10,),
                      Row(
                        children: const [
                          SizedBox(width: 10,),
                          Text("Colour", style: TextStyle(color: Colors.white),),
                        ],
                      ),
                      SizedBox(
                        height: 60,
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: lightColors.length,
                          itemBuilder: ((context, index) {
                            return color(index, setModalState);
                            /*if(number!=0 && index==0) {
                              return noColor(setModalState);
                            } else {
                              return color(index, setModalState);
                            }*/
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
      );
    },
  );

  Widget color(int index, StateSetter setModalState) => InkResponse(
    splashFactory: InkRipple.splashFactory,
    radius: 15,
    onTap: (){
      setModalState(() {
        number = index;
      });
      Provider.of<ChooseColor>(context, listen: false).changeColor(index);
    },
    splashColor: Colors.white.withOpacity(0.5),
    child: Container(
      width: 30,
      height: 30,
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: index==number ? Colors.blue : Colors.white
      ),
      child: Center(
        child: Container(
          width: index==number ? 26 : 28,
          height: index==number ? 26 : 28,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: lightColors.elementAt(index)
          ),
          child: index==number ? const Icon(Icons.check, color: Colors.blue, size: 20,) : null
        ),
      ),
    ),
  );

  /*Widget noColor(StateSetter setModalState) => InkResponse(
    splashFactory: InkRipple.splashFactory,
    radius: 15,
    onTap: () {
      setModalState(() {
        number = 0;
      });
      Provider.of<ChooseColor>(context, listen: false).changeColor(0);
    },
    splashColor: Colors.white.withOpacity(0.5),
    child: Container(
      width: 30,
      height: 30,
      margin: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white
      ),
      child: Center(
        child: Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: lightColors.elementAt(0),
          ),
          child: const Icon(Icons.format_color_reset_outlined, color: Colors.white, size: 20,),
        ),
      ),
    ),
  );*/
}
