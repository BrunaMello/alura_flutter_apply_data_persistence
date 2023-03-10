import 'package:nosso_primeiro_projeto/components/task.dart';
import 'package:nosso_primeiro_projeto/data/database.dart';
import 'package:sqflite/sqflite.dart';

class TaskDao {
  static const String tableSql = 'CREATE TABLE $_tablename('
      '$_name TEXT, '
      '$_difficulty INTEGER, '
      '$_image TEXT)';

  static const String _tablename = 'taskTable';
  static const String _name = 'name';
  static const String _difficulty = 'difficulty';
  static const String _image = 'image';

  save(Task task) async {
    print('Initiating the Saving:  ');
    final Database database = await getDatabase();
    var itemExists = await find(task.nome);
    Map<String, dynamic> taskMap = toMap(task);

    if (itemExists.isEmpty) {
      print('task does not exist');
      return await database.insert(_tablename,
          taskMap);
    } else {
      print('task exist');
      return await database.update(_tablename,
          taskMap,
          where: '$_name = ?',
          whereArgs: [task.nome]);
    }
  }

  Map<String, dynamic> toMap(Task task){
    print('Converting task to Map');
    final Map<String, dynamic> taskMap = Map();
    taskMap[_name] = task.nome;
    taskMap[_difficulty] = task.dificuldade;
    taskMap[_image] = task.foto;
    print('TaskMap: $taskMap');
    return taskMap;
  }

  Future<List<Task>> findAll() async {
    print('Assessing the Database:  ');
    final Database database = await getDatabase();
    final List<Map<String, dynamic>> result = await database.query(_tablename);
    print('Searching data on database: $result');
    return toList(result);
  }

  List<Task> toList(List<Map<String, dynamic>> mapTask) {
    print('Converting to List');
    final List<Task> tasks = [];
    for (Map<String, dynamic> row in mapTask) {
      final Task task = Task(row[_name], row[_image], row[_difficulty]);
      tasks.add(task);
    }
    print('Task List: $tasks');
    return tasks;
  }

  Future<List<Task>> find(String taskName) async {
    print('Assessing find');
    final Database database = await getDatabase();
    final List<Map<String, dynamic>> result = await database
        .query(_tablename, where: '$_name = ?', whereArgs: [taskName]);
    print('Task found: ${toList(result)}');
    return toList(result);
  }

  delete(String taskName) async {
    print('Deleting task: $_name');
    final Database database = await getDatabase();
    return database.delete(_tablename, where: '$_name = ?', whereArgs: [taskName]);
  }
}
