import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:notepad/services/gesture_state.dart';
import 'package:notepad/utils/widgets.dart';
import 'package:provider/provider.dart';
import '../services/auth_state.dart';
import '../services/data_state.dart';
import '../models/note.dart';

enum ViewMode { grid, list }

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ViewMode viewMode = ViewMode.grid;
  SnackBar emptyNoteDeleteSnack = const SnackBar(
    content: Text(
      'Empty note deleted',
    ),
    duration: Duration(seconds: 1, milliseconds: 500),
    backgroundColor: Color.fromARGB(213, 255, 255, 255),
  );
  void navigate(BuildContext context, Note note, Data dataState) async {
    var arguments = await Navigator.pushNamed(context, '/note-edit',
            arguments: {'data': note.noteData, 'reference': note.reference})
        as Map<String, dynamic>;
    saveNote(
      dataState,
      arguments['data'],
      arguments['reference'],
      arguments['timeStamp'],
    );
  }

  void saveNote(Data dataState, String data, DocumentReference? reference,
      int timeStamp) async {
    bool created = reference == null;
    if (created) {
      if (data.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(emptyNoteDeleteSnack);
        }
        return;
      }
      reference = await dataState.createNote();
      dataState.setNote(reference: reference, data: data, timeStamp: timeStamp);
    } else {
      if (data.isEmpty) {
        dataState.deleteNotes([reference]);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(emptyNoteDeleteSnack);
        }
        return;
      }
      dataState.updateNote(reference: reference, data: data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<Data, GestureState, Auth>(
      builder: (context, dataState, gestureState, authState, child) {
        return Scaffold(
          drawer: Drawer(
            child: ListView(
              children: [
                const DrawerHeader(
                  child: Text('Keep'),
                ),
                ListTile(
                  title: const Text('Settings'),
                  onTap: () {
                    
                  },
                ),
                ListTile(
                  title: const Text('Sign out'),
                  onTap: () {
                    authState.signOutUser();
                  },
                ),
              ],
            ),
          ),
          appBar: SpacedAppBar(
            child: AppBar(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              title: TextFormField(
                autofocus: false,
                enabled: false,
                decoration: const InputDecoration(
                  hintText: 'Search your notes',
                  border: InputBorder.none,
                ),
              ),
              actions: [
                if (gestureState.selectedNotesRefs.isNotEmpty)
                  IconButton(
                      onPressed: () {
                        dataState.deleteNotes(gestureState.selectedNotesRefs);
                        gestureState.selectedNotesRefs = [];
                      },
                      icon: const Icon(Icons.delete)),
                if (gestureState.selectedNotesRefs.isEmpty)
                  IconButton(
                      tooltip:
                          viewMode == ViewMode.grid ? 'List View' : 'Grid View',
                      onPressed: () {
                        setState(() {
                          viewMode = viewMode == ViewMode.grid
                              ? ViewMode.list
                              : ViewMode.grid;
                        });
                      },
                      icon: viewMode == ViewMode.grid
                          ? const Icon(Icons.list_alt_rounded)
                          : const Icon(Icons.grid_view_rounded))
              ],
            ),
          ),
          body: viewMode == ViewMode.grid
              ? MasonryGridView.builder(
                  gridDelegate:
                      const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2),
                  itemCount: dataState.notes.length,
                  itemBuilder: (context, index) {
                    Note note = dataState.notes[index];
                    return NoteCardGesture(
                      note: note,
                      selectedNotesRefs: gestureState.selectedNotesRefs,
                      addReference: gestureState.addReference,
                      removeReference: gestureState.removeReference,
                      navigateToEdit: () {
                        navigate(context, note, dataState);
                      },
                    );
                  },
                )
              : ListView.builder(
                  itemCount: dataState.notes.length,
                  itemBuilder: (context, index) {
                    Note note = dataState.notes[index];
                    return NoteCardGesture(
                        note: note,
                        selectedNotesRefs: gestureState.selectedNotesRefs,
                        addReference: gestureState.addReference,
                        removeReference: gestureState.removeReference,
                        navigateToEdit: () {
                          navigate(context, note, dataState);
                        });
                  },
                ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              var arguments = await Navigator.pushNamed(context, '/note-edit')
                  as Map<String, dynamic>;
              saveNote(dataState, arguments['data'], arguments['reference'],
                  arguments['timeStamp']);
            },
            tooltip: 'Add note',
            backgroundColor: Colors.yellow,
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}

