import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@immutable
class User {
  String? name;
  int? id;
  User({
    this.name,
    this.id,
  });

  User copyWith({
    String? name,
    int? id,
  }) {
    return User(
      name: name ?? this.name,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'id': id,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      name: map['name'] ?? '',
      id: map['id']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  @override
  String toString() => 'User(name: $name, id: $id)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User &&
        other.name == name &&
        other.id == id;
  }

  @override
  int get hashCode => name.hashCode ^ id.hashCode;
}

class UserNotifier extends StateNotifier<User> {
  UserNotifier() : super(User(name: '', id: 0));

  void updateName(String n) {
    state = state.copyWith(name: n);
  }

  void updateId(int a) {
    state = state.copyWith(id: a);
  }
}