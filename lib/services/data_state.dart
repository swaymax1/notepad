import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth_state.dart';

import '/models/note.dart';

class Data extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  StreamSubscription? _noteStreamSubscription;
  User? user;
  List<Note> _notes = [];
  List<Note> get notes => _notes;

  Data() {
    init();
  }

  void init() {
    user = Auth().user;
    if (user != null) {
      _noteStreamSubscription = _firestore
          .collection('notes')
          .where('uid', isEqualTo: user!.uid)
          .orderBy('timeStamp', descending: true)
          .snapshots()
          .listen((snapshot) {
        _notes = [];
        for (var doc in snapshot.docs) {
          _notes.add(Note(
              noteData: doc['data'],
              timeCreated: doc['timeStamp'],
              reference: doc.reference));
        }
        notifyListeners();
      });
    } else {
      _noteStreamSubscription?.cancel();
      _notes = [];
      notifyListeners();
    }
  }

  Future<DocumentReference> createNote() async {
    return _firestore.collection('notes').doc();
  }

  Future<void> setNote(
      {required DocumentReference reference,
      required String data,
      required int timeStamp}) {
    return reference
        .set({'uid': user!.uid, 'data': data, 'timeStamp': timeStamp});
  }

  Future<void> updateNote(
      {required DocumentReference reference, required String data}) {
    return reference.update({'data': data});
  }

  void deleteNotes(List<DocumentReference> notesReferences) {
    for (var reference in notesReferences) {
      reference.delete();
    }
  }
}
