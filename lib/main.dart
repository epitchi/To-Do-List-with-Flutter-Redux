import 'package:flutter/material.dart';
import 'package:redux_items/model/model.dart';
import 'package:redux_items/redux/actions.dart';
import 'package:redux_items/redux/reducers.dart';

import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final Store<AppState> store =
        Store<AppState>(appStateReducer, initialState: AppState.initialState());
    return StoreProvider<AppState>(
        store: store,
        child: MaterialApp(
          title: 'To do list',
          theme: ThemeData.dark(),
          home: MyHomePage(),
        ));
  }
} 

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To do list'),
      ),
      backgroundColor: Colors.white,
      body: StoreConnector<AppState, _ViewModel>(
        converter: (Store<AppState> store) => _ViewModel.create(store),
        builder: (BuildContext context, _ViewModel viewModel) => Column(
          children: <Widget>[
            AddItemWidget(viewModel),
            Expanded(child: ItemListWidget(viewModel)),
            RemoveItemsButton(viewModel),
          ],
        )
      ),
    );
  }
}
class RemoveItemsButton extends StatelessWidget {
  final _ViewModel model;

  RemoveItemsButton(this.model);
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: Text('Delete all Items'),
      onPressed: () => model.onRemoveItems(),
    );
  }
}

class ItemListWidget extends StatefulWidget {
  final _ViewModel model;


  ItemListWidget(this.model);

  @override
  _ItemListWidgetState createState() => _ItemListWidgetState();
}

class _ItemListWidgetState extends State<ItemListWidget> {
 

  @override
  Widget build(BuildContext context) {
      Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Colors.red;
    }
    return ListView(
      children: widget.model.items.map((Item item) => ListTile(
        title: Text(item.body, style: TextStyle(color: Colors.black, decoration: item.isChecked ? TextDecoration.lineThrough : TextDecoration.none),),
        leading: Checkbox(
      fillColor: MaterialStateProperty.resolveWith(getColor),
      checkColor: Colors.white,
      value: item.isChecked,
      onChanged: (bool value) {
        setState(() {
          item.isChecked = value;
        });
      },
    ),
        trailing: IconButton(
          color: Colors.black,
          icon: Icon(Icons.delete),
          onPressed: () => widget.model.onRemoveItem(item),
        ),
      )).toList(),
    );
  }
}

class AddItemWidget extends StatefulWidget{
  final _ViewModel model;
  
  AddItemWidget(this.model);

  @override
  State<StatefulWidget> createState() => _AddItemState();
}

class _AddItemState extends State<AddItemWidget>{
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: TextField(
        controller: controller,
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
          hintText: 'Add an Item',
          hintStyle: TextStyle(color: Colors.black38)
        ),
        onSubmitted: (String s){
          widget.model.onAddItem(s);
          controller.text = '';
        },
      ),
    );
  }
}


class _ViewModel{
  final List<Item> items;
  final Function(String) onAddItem;
  final Function(Item) onRemoveItem;
  final Function() onRemoveItems;

  _ViewModel({
    this.items,
    this.onAddItem,
    this.onRemoveItem,
    this.onRemoveItems
  });

  factory _ViewModel.create(Store<AppState> store){
    _onAddItem(String body){
      store.dispatch(AddItemAction(body));
    }

    _onRemoveItem(Item item){
      store.dispatch(RemoveItemAction(item));
    }

    _onRemoveItems(){
      store.dispatch(RemoveItemsAction());
    }
    return _ViewModel(
      items: store.state.items,
      onAddItem: _onAddItem,
      onRemoveItem: _onRemoveItem,
      onRemoveItems: _onRemoveItems,
    );
  }
  
}