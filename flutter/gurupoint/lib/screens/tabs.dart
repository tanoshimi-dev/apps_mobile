import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:gurupoint/widgets/main_drawer.dart';
import 'package:gurupoint/screens/top.dart';
import 'package:gurupoint/screens/guru_point.dart';
import 'package:gurupoint/screens/guru_category.dart';

import 'package:gurupoint/providers/member_provider.dart';

class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});

  @override
  ConsumerState<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  final SupabaseClient supabase = Supabase.instance.client;

  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  void _setScreen(String identifier) async {
    setState(() {
//        _selectedFilters = result ?? kInitialFilters;
    });
  }

  // Widget activePage = GuruPointScreen(
  //   guruId: 1,
  //   categoryId: 1,
  //   pointId: 1,
  // );

  Widget activePage = GuruCategoryScreen(
    guruId: 1,
  );

  @override
  Widget build(BuildContext context) {
    //Widget activePage = TopScreen();
    final memberState = ref.watch(memberStateProvider);
    // print('🙌⚡$memberState');
    // final id = memberState.memberId;
    // print('🙌⚡$id');

    var activePageTitle = 'GuruPoint 🙌';

    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
        actions: [
          IconButton(
              onPressed: () async {
                await supabase.auth.signOut();
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      drawer: MainDrawer(
        onSelectScreen: _setScreen,
      ),
      body: activePage,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          print('clicked');
        },
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   onTap: _selectPage,
      //   currentIndex: _selectedPageIndex,
      //   items: const [
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.set_meal),
      //       label: 'Categories',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.star),
      //       label: 'Favorites',
      //     ),
      //   ],
      // ),
    );
  }
}
