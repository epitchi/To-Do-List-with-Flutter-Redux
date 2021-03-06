import 'package:flutter/foundation.dart';

class Item {
  final int id;
  final String body;
  bool isChecked;

  Item({
    @required this.id,
    @required this.body,
    @required this.isChecked,
  });

  Item copyWith({int id, String body}) {
    return Item(
      id: id ?? this.id,
      body: body ?? this.body,
      isChecked: isChecked ?? this.isChecked,
    );
  }
}

class AppState {
  final List<Item> items;
  AppState({
    @required this.items,
  });

  AppState.initialState() : items = List.unmodifiable(<Item>[]);
}
