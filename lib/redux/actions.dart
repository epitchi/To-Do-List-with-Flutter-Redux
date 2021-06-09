import 'package:redux_items/model/model.dart';

class AddItemAction {
  static int _id = 0;
  final String item;
  static bool isChecked;

  AddItemAction(this.item){
    _id++;
    isChecked = false;
  }
  int get id => _id;
}

class RemoveItemAction {
  final Item item;

  RemoveItemAction(this.item);
}

class RemoveItemsAction {}