import 'package:trabalho_2/DatabaseHelper.dart';
import 'package:trabalho_2/Pessoa.dart';
import 'package:sqflite/sqflite.dart';

class Pessoadao {
  final Databasehelper _dbHelper = Databasehelper();

  Future<void> insertPessoa(Pessoa pessoa) async {
    final db = await _dbHelper.database;
    await db.insert('pessoa', pessoa.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> updatePessoa(Pessoa pessoa) async {
    final db = await _dbHelper.database;
    await db.update('pessoa', pessoa.toMap(),
        where: 'id = ?', whereArgs: [pessoa.id]);
  }

  Future<void> deletePessoa(Pessoa pessoa) async {
    final db = await _dbHelper.database;
    await db.delete(
      'pessoa',
      where: 'id = ?',
      whereArgs: [pessoa.id],
    );
  }

  Future<List<Pessoa>> selectPessoa() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> tipoJSON = await db.query('pessoa');
    return List.generate(
      tipoJSON.length,
      (i) {
        return Pessoa.fromMap(tipoJSON[i]);
      },
    );
  }
}
