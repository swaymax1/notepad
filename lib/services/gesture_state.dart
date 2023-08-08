import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GestureState extends ChangeNotifier {
  GestureState() : selectedNotesRefs = [];

  List<DocumentReference> selectedNotesRefs;

  void addReference(DocumentReference reference) {
    selectedNotesRefs.add(reference);
    notifyListeners();
  }

  void removeReference(DocumentReference reference) {
    selectedNotesRefs.remove(reference);
    notifyListeners();
  }
}
