library tree_data_model;

import 'package:uuid/uuid.dart';

sealed class Tree<T, U> {
  const Tree();

  factory Tree.fromJson(Map<String, dynamic> json,
      T Function(Object?) fromJsonT, U Function(Object?) fromJsonU) {
    switch (json['type']) {
      case 'leaf':
        return Leaf.fromJson(json, fromJsonT, fromJsonU);
      case 'node':
        return Node.fromJson(json, fromJsonT, fromJsonU);
      default:
        throw UnsupportedError('no such type...');
    }
  }

  Map<String, dynamic> toJson(Map<String,dynamic> Function(T) toJsonT, Map<String,dynamic> Function(U) toJsonU);

}

final class Leaf<T, U> extends Tree<T, U> {
  Leaf({String? id, required this.value}) 
    :id = id ?? const Uuid().v4();
  

  final String type = 'leaf';
  late final String id;
  final T value;

  Leaf<T, U> copyWith({
    T? value,
  }) {
    return Leaf<T, U>(
      id: id,
      value: value ?? this.value,
    );
  }

  factory Leaf.fromJson(Map<String, dynamic> json,
      T Function(Object?) fromJsonT, U Function(Object?) fromJsonU) {
    return Leaf(
      id: json['id'] as String,
      value: fromJsonT(json['value']),
    );
  }

  @override
  Map<String, dynamic> toJson(
   Map<String,dynamic> Function(T) toJsonT, Map<String,dynamic> Function(U) toJsonU
  ) {
    return {
      'type': type,
      'id': id,
      'value': toJsonT(value),
    };
  }
}

final class Node<T, U> extends Tree<T, U> {
  Node({String? id, required this.value, required this.subTrees})
    :id = id ?? const Uuid().v4();
  

  final String type = 'node';
  late final String id;
  final U value;
  final List<Tree<T, U>> subTrees;


  Node<T, U> createLeaf({required String nodeId, required Leaf<T, U> leaf}) {
    return _createLeaf(root: this, nodeId: nodeId, leaf: leaf);
  }

  Leaf<T, U>? readLeafById({required String id}) {
    return _readLeafById(root: this, id: id);
  }

  Node<T, U> updateLeaf({required String leafId, required Leaf<T, U> leaf}) {
    return _updateLeaf(root: this, leafId: leafId, leaf: leaf);
  }

  Node<T, U> deleteLeafById({required String leafId}) {
    return _deleteLeafById(root: this, leafId: leafId);
  }

  Node<T, U> createNode({required String nodeId, required Node<T, U> node}) {
    return _createNode(root: this, nodeId: nodeId, node: node);
  }

  Node<T, U>? readNodeById({required String nodeId}) {
    return _readNodeById(root: this, nodeId: nodeId);
  }

  Node<T, U> updateNode({required String nodeId, required Node<T, U> node}) {
    return _updateNode(root: this, nodeId: nodeId, node: node);
  }

  Node<T, U>? deleteNodeById({required String nodeId}) {
    return _deleteNodeById(root: this, nodeId: nodeId);
  }

  Set<Leaf<T, U>> leaves() {
    return _leaves(root: this);
  }

  Set<Node<T, U>> nodes() {
    return _nodes(root: this);
  }

  Node<T, U> _createLeaf({required Node<T, U> root, required String nodeId, required Leaf<T, U> leaf}) {
    if (root.id == nodeId) {
      return root.copyWith(
        subTrees: <Tree<T, U>>[...root.subTrees, leaf],
      );
    } else {
      return root.copyWith(
        subTrees: root.subTrees.map(
          (tree) {
            if (tree is Node<T, U>) {
              return _createLeaf(root: tree, nodeId: nodeId, leaf: leaf);
            } else {
              return tree;
            }
          },
        ).toList(),
      );
    }
  }

  Leaf<T, U>? _readLeafById({required Node<T, U> root, required String id}) {
    return _leaves(root: root).where((leaf) => leaf.id == id).firstOrNull;
  }

  Node<T, U> _updateLeaf({required Node<T, U> root, required String leafId, required Leaf<T, U> leaf}) {
    if (root.subTrees.whereType<Leaf<T, U>>().where((l) => l.id == leafId).isNotEmpty) {
      return root.copyWith(
        subTrees: root.subTrees.map((t) => (t is Leaf<T, U> && t.id == leafId) ? leaf : t).toList(),
      );
    } else {
      return root.copyWith(
        subTrees: root.subTrees.map((t) => (t is Node<T, U>) ? _updateLeaf(root: t, leafId: leafId, leaf: leaf) : t).toList(),
      );
    }
  }

  Node<T, U> _deleteLeafById({required Node<T, U> root, required String leafId}) {
    if (root.subTrees.whereType<Leaf<T, U>>().where((l) => l.id == leafId).isNotEmpty) {
      return root.copyWith(
        subTrees: root.subTrees.map((t) => (t is Leaf<T, U> && t.id == leafId) ? null : t).whereType<Tree<T, U>>().toList(),
      );
    } else {
      return root.copyWith(
        subTrees: root.subTrees.map((t) => (t is Node<T, U>) ? _deleteLeafById(root: t, leafId: leafId) : t).toList(),
      );
    }
  }

  Node<T, U> _createNode({required Node<T, U> root, required String nodeId, required Node<T, U> node}) {
    if (root.id == nodeId) {
      return root.copyWith(
        subTrees: [...root.subTrees, node],
      );
    } else {
      return root.copyWith(
        subTrees: root.subTrees.map(
          (tree) {
            if (tree is Node<T, U>) {
              return _createNode(root: tree, nodeId: nodeId, node: node);
            } else {
              return tree;
            }
          },
        ).toList(),
      );
    }
  }

  Node<T, U>? _readNodeById({required Node<T, U> root, required String nodeId}) {
    return _nodes(root: root).where((node) => node.id == nodeId).firstOrNull;
  }

  Node<T, U> _updateNode({required Node<T, U> root, required String nodeId, required Node<T, U> node}) {
    if (root.id == nodeId) {
      return node;
    } else {
      return root.copyWith(
        subTrees: root.subTrees.map((t) => (t is Node<T, U>) ? _updateNode(root: t, nodeId: nodeId, node: node) : t).toList(),
      );
    }
  }

  Node<T, U>? _deleteNodeById({required Node<T, U> root, required String nodeId}) {
    if (root.id == nodeId) {
      return null;
    } else {
      return root.copyWith(
        subTrees: root.subTrees.map((t) => (t is Node<T, U>) ? _deleteNodeById(root: t, nodeId: nodeId) : t).whereType<Tree<T, U>>().toList(),
      );
    }
  }

  Set<Leaf<T, U>> _childLeaves({required Node<T, U> root}) {
    return root.subTrees.whereType<Leaf<T, U>>().toSet();
  }

  Set<Node<T, U>> _childNodes({required Node<T, U> root}) {
    return root.subTrees.whereType<Node<T, U>>().toSet();
  }

  Set<Leaf<T, U>> _leaves({required Node<T, U> root}) {
    final childLeaves = _childLeaves(root: root);
    final childNodes = _childNodes(root: root);

    if (childNodes.isEmpty) {
      return childLeaves;
    } else {
      return childLeaves
        ..addAll(
          childNodes.map((n) => _leaves(root: n)).reduce((set1, set2) => set1..addAll(set2)),
        );
    }
  }

  Set<Node<T, U>> _nodes({required Node<T, U> root}) {
    final childNodes = _childNodes(root: root);
    if (childNodes.isEmpty) {
      return {root};
    } else {
      return {root, ...childNodes}
        ..addAll(
          childNodes.map((n) => _nodes(root: n)).reduce((set1, set2) => set1..addAll(set2)),
        );
    }
  }

  Node<T,U> copyWith({
    U? value,
    List<Tree<T, U>>? subTrees,
  }) {
    return Node<T,U>(
      id: this.id,  // idは変更しない
      value: value ?? this.value,
      subTrees: subTrees ?? this.subTrees,
    );
  }


  factory Node.fromJson(Map<String, dynamic> json,
      T Function(Object?) fromJsonT, U Function(Object?) fromJsonU) {
    final subTrees = json['subTrees']
        .map<Tree<T, U>>((subTreeJson) 
          =>Tree.fromJson(subTreeJson, fromJsonT, fromJsonU)
        )
        .toList();

    return Node<T,U>(
      id: json['id'] as String,
      value: fromJsonU(json['value']),
      subTrees: subTrees,
    );
  }

  @override
  Map<String, dynamic> toJson(Map<String,dynamic> Function(T) toJsonT, Map<String,dynamic> Function(U) toJsonU) {
    return {
      'type': type,
      'id': id,
      'value': toJsonU(value),
      'subTrees': subTrees.map((subTree) => subTree.toJson(toJsonT,toJsonU)).toList(),
    };
  }
}
