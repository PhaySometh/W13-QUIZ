import 'package:flutter/material.dart';
import 'package:w13_quiz/data/mock_grocery_repository.dart';
import 'package:w13_quiz/models/grocery.dart';

class GrocerySearch extends StatefulWidget {
  const GrocerySearch({super.key, required this.searchId});
  final String searchId;

  @override
  State<GrocerySearch> createState() => _GrocerySearchState();
}

class _GrocerySearchState extends State<GrocerySearch> {
  String searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Grocery> get filteredGroceries {
    if (searchQuery.isEmpty) {
      return dummyGroceryItems;
    }
    return dummyGroceryItems
        .where(
          (grocery) =>
              grocery.name.toLowerCase().contains(searchQuery.toLowerCase()),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = filteredGroceries;

    Widget content = const Center(child: Text('No items found.'));

    if (filtered.isNotEmpty) {
      content = ListView.builder(
        itemCount: filtered.length,
        itemBuilder: (context, index) => GroceryTile(grocery: filtered[index]),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search groceries...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          _searchController.clear();
                          searchQuery = '';
                        });
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onChanged: (value) {
              setState(() {
                searchQuery = value;
              });
            },
          ),
        ),
        Expanded(child: content),
      ],
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
