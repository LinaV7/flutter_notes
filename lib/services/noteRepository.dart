import 'dart:async';

import 'package:sixteen_pro/objectbox.g.dart';
import 'package:sixteen_pro/model/note.dart';
import 'package:objectbox/objectbox.dart';

class NotesRepository {
  late final Store _store;
  late final Box<Note> _box;
  final _controller = StreamController<List<Note>>.broadcast();

  List<Note> get notes => _box.getAll()..sort((a, b) => b.id.compareTo(a.id));

  Stream<List<Note>> get streamNotes => _controller.stream;

  Stream<List<Note>> get boxStreamNotes =>
      _box.query().watch(triggerImmediately: true).map((query) => query.find());

  Future initDB() async {
    _store = await openStore();
    _box = _store.box<Note>();
    await _updateStream();
  }

  Future addNote(Note note) async {
    await _box.putAsync(note);
    await _updateStream();
  }

  Future update(int id, Note note) async {
    _box.remove(id);
    await _box.putAsync(note);
    await _updateStream();
  }

  Future deleteNote(Note note) async {
    _box.remove(note.id);
    await _updateStream();
  }

  Future _updateStream() async {
    _controller.add(notes);
  }
}



// import 'package:sixteen_pro/objectbox.g.dart';
// import 'package:sixteen_pro/model/note.dart';
// import 'package:objectbox/objectbox.dart';

// class NotesRepository {
//   late final Store _store;
//   late final Box<Note> _box;

//   List<Note> get notes => _box.getAll()..sort((a, b) => b.id.compareTo(a.id));

//   Future initDB() async {
//     _store = await openStore();
//     _box = _store.box<Note>();
//   }

//   Future addNote(Note note) async {
//     await _box.putAsync(note);
//   }

//   Future update(int id, Note note) async {
//     _box.remove(id);
//     await _box.putAsync(note);
//   }
// }
