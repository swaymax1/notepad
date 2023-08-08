import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/note.dart';

class NoteCard extends StatelessWidget {
  NoteCard({super.key, required this.note, required this.isSelected});

  final Note note;
  bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      padding: const EdgeInsets.all(20),
      constraints: const BoxConstraints(
        maxHeight: 300,
        minHeight: 100,
      ),
      decoration: BoxDecoration(
          border: Border.all(
              color: isSelected ? Colors.blue : Theme.of(context).primaryColor),
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(15)),
      child: Text(
        note.noteData,
        style: Theme.of(context).textTheme.bodyText1,
      ),
    );
  }
}

class SpacedAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SpacedAppBar({super.key, required this.child});

  final AppBar child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      child: child,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(70);
}

class NoteCardGesture extends StatelessWidget {
  NoteCardGesture(
      {super.key,
      required this.note,
      required this.selectedNotesRefs,
      required this.addReference,
      required this.removeReference,
      required this.navigateToEdit});

  List<DocumentReference> selectedNotesRefs;
  Note note;
  dynamic addReference;
  dynamic removeReference;
  dynamic navigateToEdit;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (selectedNotesRefs.contains(note.reference)) {
          removeReference(note.reference);
        } else if (selectedNotesRefs.isNotEmpty) {
          addReference(note.reference);
        } else {
          navigateToEdit();
        }
      },
      onLongPress: () {
        addReference(note.reference);
      },
      child: NoteCard(
        note: note,
        isSelected: selectedNotesRefs.contains(note.reference),
      ),
    );
  }
}
