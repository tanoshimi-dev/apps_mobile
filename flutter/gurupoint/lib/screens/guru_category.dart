import 'package:flutter/material.dart';
import 'package:gurupoint/screens/guru_point.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

//import 'package:gurupoint/widgets/category_grid_item.dart';
import 'package:gurupoint/widgets/point_grid_item.dart';

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
  List _pointList = [];

  @override
  void initState() {
    super.initState();
    readData();
  }

  // Syntax to select data
  Future<void> readData() async {
    // final res = await supabase
    //     .from('guru_category')
    //     .select('category_id, category_name, guru(guru_id, guru_name)')
    //     .eq('guru.guru_owner_member_id', supabase.auth.currentUser!.id)
    //     .order('category_id', ascending: true);

    print('ユーザーの全カテゴリ');
    final res = await supabase.rpc('get_category_list',
        params: {'user_id': supabase.auth.currentUser!.id});
    setState(() {
      _categories = res.toList();
    });
    for (final category in _categories) {
      print('俺の👒　categories  $category');
    }

    //https://www.youtube.com/watch?v=5RoCKuJaYPU

    // final res2 = await supabase.from('guru_category').select(
    //     'guru_id,category_name, guru_point(category_id,point_id,point)');

    // final res2 = await supabase.from('guru').select(
    //     'guru_id,guru_name, guru_category(guru_id,category_name), guru_point(category_id,point_id,point)');
    // .eq('guru_owner_member_id', supabase.auth.currentUser!.id);
    //.order('category_id', ascending: true);

    // final data2 = res2.toList();

    print('ユーザーの全ポイント');
    final data2 = await supabase.rpc('get_point_list',
        params: {'user_id': supabase.auth.currentUser!.id});

    for (final point in data2) {
      print('2つ目の💎　$point');
    }

    setState(() {
      _pointList = data2.toList();
    });
  }

  void _selectGuruPoint(BuildContext context, int guruId, int categoryId,
      int pointId, String pointName, int point) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => GuruPointScreen(
          guruId: guruId,
          categoryId: categoryId,
          pointId: pointId,
          pointName: pointName,
          point: point,
        ),
      ),
    ); // Navigator.push(context, route)
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
        for (final point in _pointList)
          PointGridItem(
            guruId: point['guru_id'],
            categoryId: point['category_id'],
            pointId: point['point_id'],
            pointName: point['point_name'],
            point: point['point'],
            onSelectGuru: () {
              //print(category['category_name']);
              //_selectCategory(context, category);

              _selectGuruPoint(context, point['guru_id'], point['category_id'],
                  point['point_id'], point['point_name'], point['point']);
            },
          )
      ],
    );
  }
}
