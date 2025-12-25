import 'package:flutter/material.dart';
import '../../data/mock_grocery_repository.dart';
import '../../models/grocery.dart';
import 'grocery_form.dart';
import 'tabs/search.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

enum GroceryEnum { groceriesTab, searchTab }

class _GroceryListState extends State<GroceryList> {
  GroceryEnum currentTab = GroceryEnum.groceriesTab;

  void onCreate() async {
    // Navigate to the form screen using the Navigator push
    Grocery? newGrocery = await Navigator.push<Grocery>(
      context,
      MaterialPageRoute(builder: (context) => const GroceryForm()),
    );
    if (newGrocery != null) {
      setState(() {
        dummyGroceryItems.add(newGrocery);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(child: Text('No items added yet.'));

    // Show different content based on the selected tab
    if (currentTab == GroceryEnum.searchTab) {
      content = const GrocerySearch(searchId: 'default');
    } else {
      if (dummyGroceryItems.isNotEmpty) {
        //  Display groceries with an Item builder and  LIst Tile
        content = ListView.builder(
          itemCount: dummyGroceryItems.length,
          itemBuilder: (context, index) =>
              GroceryTile(grocery: dummyGroceryItems[index]),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Groceries'),
        actions: [IconButton(onPressed: onCreate, icon: const Icon(Icons.add))],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentTab.index,
        selectedItemColor: Colors.red,
        onTap: (index) {
          setState(() {
            currentTab = GroceryEnum.values[index];
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_rounded),
            label: 'Groceries',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
        ],
      ),
      body: content,
    );
  }
}

class GroceryTile extends StatelessWidget {
  const GroceryTile({super.key, required this.grocery});

  final Grocery grocery;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(width: 15, height: 15, color: grocery.category.color),
      title: Text(grocery.name),
      trailing: Text(grocery.quantity.toString()),
    );
  }
}
