import 'package:flutter/material.dart';
import 'package:notes/Note.dart';
import 'package:notes/main.dart';
//import 'package:notes/main.dart';
import 'package:sqflite/sqflite.dart';

var database;
// Define a function that inserts dogs into the database
Future<void> insertNote(Note note) async {
  // Get a reference to the database.
  final db = await database;

  // Insert the Dog into the correct table. You might also specify the
  // `conflictAlgorithm` to use in case the same dog is inserted twice.
  //
  // In this case, replace any previous data.
  var idOfNote = await db.insert(
    'notes',
    note.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
  debugPrint("idOfNote: $idOfNote");
  activeNote.setId(idOfNote);
  note.setId(idOfNote);
}

Future<void> updateNote(Note note) async {
  // Get a reference to the database.
  final db = await database;

  // Update the given NOte.
  await db.update(
    'notes',
    note.toMap(),
    // Ensure that the Dog has a matching id.
    where: 'id = ?',
    // Pass the Dog's id as a whereArg to prevent SQL injection.
    whereArgs: [note.id],
  );
}

Future<void> removeNote(Note note) async {
  final db = await database;

  await db.delete('notes', where: 'id = ?', whereArgs: [note.id]);
}

Future<List<Note>> getNotes() async {
  // Get a reference to the database.
  final db = await database;

  // Query the table for all the notes.
  final List<Map<String, Object?>> noteMaps = await db.query('notes');

  // Convert the list of each note's fields into a list of `Note` objects.
  return [
    for (final {
          'id': id as int,
          'title': title as String,
          'content': content as String,
          'color': color as String,
        }
        in noteMaps)
      // Note(title, content, Color(int.parse(color, radix: 16))),
      Note.withId(id, title, content, Color(int.parse(color, radix: 16))),
  ];
}

/*
List<Note> getNotess() {
  // Get a reference to the database.
  final db = database;

  // Query the table for all the notes.
  final List<Map<String, Object?>> noteMaps = db.query('notes');

  // Convert the list of each note's fields into a list of `Note` objects.
  return [
    for (final {
          'id': id as int,
          'title': title as String,
          'content': content as String,
          'color': color as String,
        }
        in noteMaps)
      // Note(title, content, Color(int.parse(color, radix: 16))),
      Note.withId(id, title, content, Color(int.parse(color, radix: 16))),
  ];
}
*/
var notes;
Future<void> printNotes() async {
  // notes = await getNotes(); // wait for the Future to complete

  for (var note in notes) {
    debugPrint(note.toString());
  }
}

int notesLength() {
  // final notes = await getNotes(); // wait for the Future to complete
  return notes.length;
}
