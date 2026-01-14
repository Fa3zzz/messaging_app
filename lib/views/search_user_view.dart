import 'package:flutter/material.dart';

class SearchUserView extends StatefulWidget {
  const SearchUserView({super.key});

  @override
  State<SearchUserView> createState() => _SearchUserViewState();
}

class _SearchUserViewState extends State<SearchUserView> {

  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _clear() {
    _controller.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final query = _controller.text.trim();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      appBar: AppBar(
        title: const Text('Search Users'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              autocorrect: false,
              autofocus: false,
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Username..',
                hintStyle: TextStyle(
                  color: Colors.blueGrey.shade900,
                ),
                fillColor: Theme.of(context).colorScheme.surface,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: query.isEmpty ? null : IconButton(onPressed: _clear, icon: const Icon(Icons.close)),
              ),
            )
          ],
        ),
      ),
    );
  }
}