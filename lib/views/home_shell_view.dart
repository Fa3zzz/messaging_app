import 'package:flutter/material.dart';
import 'package:messaging_app/views/cards_feed_view.dart';
import 'package:messaging_app/views/chats_view.dart';
import 'package:messaging_app/views/my_cards_view.dart';

class HomeShellView extends StatefulWidget {
  const HomeShellView({super.key});

  @override
  State<HomeShellView> createState() => _HomeShellViewState();
}

class _HomeShellViewState extends State<HomeShellView> {

  int _index = 0;
  final _pages = const [
    ChatsView(),
    CardsFeedView(),
    MyCardsView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _pages,),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i ),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white38,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline,),
            label: 'Chats'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.format_quote_outlined),
            label: 'Cards',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_4_outlined),
            label: 'My Cards'
          ),
        ],
      ),
    );
  }
}