import 'dart:developer';

import 'package:flutter_test/flutter_test.dart';

import 'package:tree_data_model/tree_data_model.dart';

typedef TodoList = Tree<Todo, Header>;
typedef Task = Leaf<Todo, Header>;
typedef Folder = Node<Todo, Header>;

class Header {
  final String title;
  final String? description;

  Header({
    required this.title,
    this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
    };
  }

  factory Header.fromJson(Map<String, dynamic> json) {
    return Header(
      title: json['title'] as String,
      description: json['description'] as String?,
    );
  }
}

class Todo {
  final String title;
  final String? description;
  final bool completed;
  final DateTime? dueDate;

  Todo({
    required this.title,
    this.description,
    required this.completed,
    this.dueDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'completed': completed,
      'dueDate': dueDate?.toIso8601String(),
    };
  }

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      title: json['title'] as String,
      description: json['description'] as String?,
      completed: json['completed'] as bool,
      dueDate: json['dueDate'] != null
          ? DateTime.parse(json['dueDate'] as String)
          : null,
    );
  }
}

final TodoList todos =
    Folder(id: 'todos', value: Header(title: 'Todays todo'), subTrees: [
  Folder(
    id: 'exercise',
    value: Header(
      title: 'Exercise',
      description: 'For brain Helthy',
    ),
    subTrees: [
      Task(id: 'running_task', value: Todo(title: 'Running', completed: false)),
      Task(id: 'squat_task', value: Todo(title: 'Squat', completed: false)),
    ],
  ),
  Task(
      id: 'study_math_task', value: Todo(title: 'Study math', completed: false))
]);

void main() {
  group('Test start', () {
    test('toJson test', () {
      final json =
          todos.toJson((todo) => todo.toJson(), (header) => header.toJson());
      expect(json, {
        'type': 'node',
        'id': 'todos',
        'value': {'title': 'Todays todo', 'description': null},
        'subTrees': [
          {
            'type': 'node',
            'id': 'exercise',
            'value': {'title': 'Exercise', 'description': 'For brain Helthy'},
            'subTrees': [
              {
                'type': 'leaf',
                'id': 'running_task',
                'value': {
                  'title': 'Running',
                  'description': null,
                  'completed': false,
                  'dueDate': null
                }
              },
              {
                'type': 'leaf',
                'id': 'squat_task',
                'value': {
                  'title': 'Squat',
                  'description': null,
                  'completed': false,
                  'dueDate': null
                }
              }
            ]
          },
          {
            'type': 'leaf',
            'id': 'study_math_task',
            'value': {
              'title': 'Study math',
              'description': null,
              'completed': false,
              'dueDate': null
            }
          }
        ]
      });
    });
    test('fromJson test', () {
      final json =
          todos.toJson((todo) => todo.toJson(), (header) => header.toJson());
      final decoded = TodoList.fromJson(
          json,
          (todo) => Todo.fromJson(todo as Map<String, dynamic>),
          (header) => Header.fromJson(header as Map<String, dynamic>));
      expect(
          decoded.toJson((todo) => todo.toJson(), (header) => header.toJson()),
          json);
    });
  });

  test('createLeaf test', () {
    final todosAdded = (todos as Folder).createLeaf(
      nodeId: 'exercise',
      leaf: Task(
          id: 'push_up_task', value: Todo(title: 'Push up', completed: false)),
    );
    expect(
        todosAdded.toJson((todo) => todo.toJson(), (header) => header.toJson()),
        {
          'type': 'node',
          'id': 'todos',
          'value': {'title': 'Todays todo', 'description': null},
          'subTrees': [
            {
              'type': 'node',
              'id': 'exercise',
              'value': {'title': 'Exercise', 'description': 'For brain Helthy'},
              'subTrees': [
                {
                  'type': 'leaf',
                  'id': 'running_task',
                  'value': {
                    'title': 'Running',
                    'description': null,
                    'completed': false,
                    'dueDate': null
                  }
                },
                {
                  'type': 'leaf',
                  'id': 'squat_task',
                  'value': {
                    'title': 'Squat',
                    'description': null,
                    'completed': false,
                    'dueDate': null
                  }
                },
                {
                  'type': 'leaf',
                  'id': 'push_up_task',
                  'value': {
                    'title': 'Push up',
                    'description': null,
                    'completed': false,
                    'dueDate': null
                  }
                }
              ]
            },
            {
              'type': 'leaf',
              'id': 'study_math_task',
              'value': {
                'title': 'Study math',
                'description': null,
                'completed': false,
                'dueDate': null
              }
            }
          ]
        });
  });

  test('createNode test', () {
    final todosAdded = (todos as Folder).createNode(
      nodeId: 'exercise',
      node:
          Folder(id: 'stretch', subTrees: [], value: Header(title: 'Stretch')),
    );
    expect(
        todosAdded.toJson((todo) => todo.toJson(), (header) => header.toJson()),
        {
          'type': 'node',
          'id': 'todos',
          'value': {'title': 'Todays todo', 'description': null},
          'subTrees': [
            {
              'type': 'node',
              'id': 'exercise',
              'value': {'title': 'Exercise', 'description': 'For brain Helthy'},
              'subTrees': [
                {
                  'type': 'leaf',
                  'id': 'running_task',
                  'value': {
                    'title': 'Running',
                    'description': null,
                    'completed': false,
                    'dueDate': null
                  }
                },
                {
                  'type': 'leaf',
                  'id': 'squat_task',
                  'value': {
                    'title': 'Squat',
                    'description': null,
                    'completed': false,
                    'dueDate': null
                  }
                },
                {
                  'type': 'node',
                  'id': 'stretch',
                  'value': {'title': 'Stretch', 'description': null},
                  'subTrees': []
                }
              ]
            },
            {
              'type': 'leaf',
              'id': 'study_math_task',
              'value': {
                'title': 'Study math',
                'description': null,
                'completed': false,
                'dueDate': null
              }
            }
          ]
        });
  });
  test('readLeaf test', () {
    final todoRead = (todos as Folder).readLeafById(id: 'running_task')!;

    expect(
      todoRead.toJson((todo) => todo.toJson(), (header) => header.toJson()),
      {
        'type': 'leaf',
        'id': 'running_task',
        'value': {
          'title': 'Running',
          'description': null,
          'completed': false,
          'dueDate': null
        }
      },
    );
  });

  test('readNode test', () {
    final folderRead = (todos as Folder).readNodeById(nodeId: 'exercise')!;

    expect(
      folderRead.toJson((todo) => todo.toJson(), (header) => header.toJson()),
      {
        'type': 'node',
        'id': 'exercise',
        'value': {'title': 'Exercise', 'description': 'For brain Helthy'},
        'subTrees': [
          {
            'type': 'leaf',
            'id': 'running_task',
            'value': {
              'title': 'Running',
              'description': null,
              'completed': false,
              'dueDate': null
            }
          },
          {
            'type': 'leaf',
            'id': 'squat_task',
            'value': {
              'title': 'Squat',
              'description': null,
              'completed': false,
              'dueDate': null
            }
          },
        ]
      },
    );
  });

  test('updateLeaf test', () {
    final todoUpdated = (todos as Folder).updateLeaf(
        leafId: 'squat_task',
        leaf: Task(
            id: 'squat_task', value: Todo(title: 'Squat', completed: true)));

    expect(
        todoUpdated.toJson(
            (todo) => todo.toJson(), (header) => header.toJson()),
        {
          'type': 'node',
          'id': 'todos',
          'value': {'title': 'Todays todo', 'description': null},
          'subTrees': [
            {
              'type': 'node',
              'id': 'exercise',
              'value': {'title': 'Exercise', 'description': 'For brain Helthy'},
              'subTrees': [
                {
                  'type': 'leaf',
                  'id': 'running_task',
                  'value': {
                    'title': 'Running',
                    'description': null,
                    'completed': false,
                    'dueDate': null
                  }
                },
                {
                  'type': 'leaf',
                  'id': 'squat_task',
                  'value': {
                    'title': 'Squat',
                    'description': null,
                    'completed': true,
                    'dueDate': null
                  }
                }
              ]
            },
            {
              'type': 'leaf',
              'id': 'study_math_task',
              'value': {
                'title': 'Study math',
                'description': null,
                'completed': false,
                'dueDate': null
              }
            }
          ]
        });
  });

  test('updateNode test', () {
    final todoUpdated = (todos as Folder).updateNode(
      nodeId: 'exercise',
      node: Folder(
        id: 'exercise',
        value: Header(
          title: 'Exercise',
          description: 'For diet',
        ),
        subTrees: [
          Task(
              id: 'running_task',
              value: Todo(title: 'Running', completed: true)),
          Task(id: 'squat_task', value: Todo(title: 'Squat', completed: true)),
        ],
      ),
    );

    expect(
        todoUpdated.toJson(
            (todo) => todo.toJson(), (header) => header.toJson()),
        {
          'type': 'node',
          'id': 'todos',
          'value': {'title': 'Todays todo', 'description': null},
          'subTrees': [
            {
              'type': 'node',
              'id': 'exercise',
              'value': {'title': 'Exercise', 'description': 'For diet'},
              'subTrees': [
                {
                  'type': 'leaf',
                  'id': 'running_task',
                  'value': {
                    'title': 'Running',
                    'description': null,
                    'completed': true,
                    'dueDate': null
                  }
                },
                {
                  'type': 'leaf',
                  'id': 'squat_task',
                  'value': {
                    'title': 'Squat',
                    'description': null,
                    'completed': true,
                    'dueDate': null
                  }
                }
              ]
            },
            {
              'type': 'leaf',
              'id': 'study_math_task',
              'value': {
                'title': 'Study math',
                'description': null,
                'completed': false,
                'dueDate': null
              }
            }
          ]
        });
  });

  test('deleteLeaf test', () {
    final todoDeleted =
        (todos as Folder).deleteLeafById(leafId: 'running_task');

    expect(
        todoDeleted.toJson(
            (todo) => todo.toJson(), (header) => header.toJson()),
        {
          'type': 'node',
          'id': 'todos',
          'value': {'title': 'Todays todo', 'description': null},
          'subTrees': [
            {
              'type': 'node',
              'id': 'exercise',
              'value': {'title': 'Exercise', 'description': 'For brain Helthy'},
              'subTrees': [
                {
                  'type': 'leaf',
                  'id': 'squat_task',
                  'value': {
                    'title': 'Squat',
                    'description': null,
                    'completed': false,
                    'dueDate': null
                  }
                }
              ]
            },
            {
              'type': 'leaf',
              'id': 'study_math_task',
              'value': {
                'title': 'Study math',
                'description': null,
                'completed': false,
                'dueDate': null
              }
            }
          ]
        });
  });

  test('deleteNode test', () {
    final todoDeleted = (todos as Folder).deleteNodeById(nodeId: 'exercise')!;

    expect(
        todoDeleted.toJson(
            (todo) => todo.toJson(), (header) => header.toJson()),
        {
          'type': 'node',
          'id': 'todos',
          'value': {'title': 'Todays todo', 'description': null},
          'subTrees': [
            {
              'type': 'leaf',
              'id': 'study_math_task',
              'value': {
                'title': 'Study math',
                'description': null,
                'completed': false,
                'dueDate': null
              }
            }
          ]
        });
  });
}


