import 'package:flutter/material.dart';

class Note {
  int? id;
  String title;
  String content;
  Color color;

  /*  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.color,
  });*/

  Note(this.title, this.content, this.color);
  Note.withId(this.id, this.title, this.content, this.color);

  Map<String, Object?> toMap() {
    // return {'id': id, 'title': title, 'content': content, 'color': color};
    return {
      'title': title,
      'content': content,
      'color': color.toARGB32().toRadixString(16),
    };
    // return {'id': id, 'title': title, 'content': content,color: color.toARGB32().toRadixString(16)};
  }

  @override
  String toString() {
    return "'id': $id, 'title': $title, 'content': $content,'color': $color.toARGB32().toRadixString(16)";
  }

  int? getId() => id;

  getContent() {
    return content;
  }

  getTitle() {
    return title;
  }

  getColor() {
    return color;
  }

  setContent(String content) {
    this.content = content;
  }

  setTitle(String title) {
    this.title = title;
  }

  setColor(Color color) {
    this.color = color;
  }

  setId(int id) {
    this.id = id;
  }
}
