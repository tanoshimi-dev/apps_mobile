import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:gurupoint/widgets/category_grid_item.dart';

class GuruCategoryScreen extends StatefulWidget {
  const GuruCategoryScreen({super.key, required this.guruId});
  final int guruId;

  @override
  State<GuruCategoryScreen> createState() => _GuruCategoryState();
}

class _GuruCategoryState extends State<GuruCategoryScreen> {
  final SupabaseClient supabase = Supabase.instance.client;
  //late Stream<List<Map<String, dynamic>>> _readStream;
  List _categories = [];

  @override
  void initState() {
    super.initState();
    readData();
  }

  // Syntax to select data
  Future<void> readData() async {
    final res = await supabase
        .from('guru_category')
        .select('category_id, category_name, guru(guru_id, guru_name)')
        .eq('guru.guru_owner_member_id', supabase.auth.currentUser!.id)
        .order('category_id', ascending: true);
    //return result;
    final data = res.toList();
    setState(() {
      _categories = res.toList();
    });
    for (final category in _categories) {
      print('俺の👒　categories  $category');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GridView(
      padding: const EdgeInsets.all(24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
      children: [
        for (final category in _categories)
          CategoryGridItem(
            categoryId: category['category_id'],
            categoryName: category['category_name'],
            onSelectGuru: () {
              print(category['category_name']);
            },
          )
      ],
    );
  }
}
