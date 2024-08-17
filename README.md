<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

A model representing tree structure.

## Features
- recursively defined
- JSON serializable
- infinitely extensible
- crud leaf
- crud node

## Usage

```dart
typedef TaskList = Tree<Task, Header>;
typedef Task = Leaf<Task, Header>; 
typedef Folder = Node<Task, Header>;

final TaskList todos =
    Folder(id: 'todos', value: Header(title: 'Todays todo'), subTrees: [
  Folder(
    id: 'exercise',
    value: Header(
      title: 'Exercise',
      description: 'For brain Helthy',
    ),
    subTrees: [
      Task(id: 'running_task', value: Task(title: 'Running', completed: false)),
      Task(id: 'squat_task', value: Task(title: 'Squat', completed: false)),
    ],
  ),
  Task(id: 'study_math_task', value: Task(title: 'Study math', completed: false))
]);
```
