import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Note {
  Note({required this.noteData, required this.timeCreated, this.reference});

  String noteData;
  final int timeCreated;
  DocumentReference? reference;

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      noteData: map['data'] as String,
      timeCreated: map['timeStamp'] as int,
      reference: map['reference'],
    );
  }
}
