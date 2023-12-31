import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:gurupoint/dummy/dummy_data.dart';
import 'package:gurupoint/widgets/guru_grid_item.dart';

// Dialog text input
// https://www.youtube.com/watch?v=D6icsXS8NeA

class GuruPointScreen extends StatefulWidget {
  const GuruPointScreen({
    super.key,
    required this.guruId,
    required this.categoryId,
    required this.pointId,
    required this.pointName,
    required this.point,
  });

  final int guruId;
  final int categoryId;
  final int pointId;
  final String pointName;
  final int point;

  @override
  State<GuruPointScreen> createState() => _GuruPointState();
}

class _GuruPointState extends State<GuruPointScreen> {
  final SupabaseClient supabase = Supabase.instance.client;
  late Stream<List<Map<String, dynamic>>> _readStream;

  @override
  void initState() {
    // _readStream = supabase
    //     .from('todos')
    //     .stream(primaryKey: ['id'])
    //     .eq('user_id', supabase.auth.currentUser!.id)
    //     .order('id', ascending: false);
    _readStream = supabase
        .from('member_point')
        .stream(primaryKey: [
          'guru_id',
          'category_id',
          'point_id',
          'member_id',
          'seq'
        ])
        .eq('member_id', supabase.auth.currentUser!.id)
        .order('created_at', ascending: false);

    // .listen(
    // );

    //final fsys = supabase
    // final fsys = supabase
    //     .from('member_point')
    //     .stream(primaryKey: [
    //       'guru_id',
    //       'category_id',
    //       'point_id',
    //       'member_id',
    //       'seq'
    //     ])
    //     .eq('member_id', supabase.auth.currentUser!.id)
    //     .order('created_at', ascending: false)
    //     .listen((List<Map<String, dynamic>> data) {
    //       print("stream listen☆彡 $data");
    //       // Do something awesome with the data
    //     });

    super.initState();
  }

  // Syntax to select data
  Future<List> readData() async {
    print('🔓 readData called');
    final result = await supabase
        .from('member_point')
        .select()
        .eq('guru_id', widget.guruId)
        .eq('category_id', widget.categoryId)
        .eq('point_id', widget.pointId)
        .eq('member_id', supabase.auth.currentUser!.id)
        .order('created_at', ascending: false);

    return result;
  }

  @override
  Widget build(BuildContext context) {
    var pointName = widget.pointName;
    var point = widget.point;
    var title = "$pointName($point)";

    var pointId = widget.pointId;
    print('readData🦖pointId　$pointId');
    var categoryId = widget.categoryId;
    print('readData🦖categoryId　$categoryId');

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pointName),
      ),
      //body: StreamBuilder(
      body: FutureBuilder(
          //stream: _readStream,
          future: readData(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }

            if (snapshot.hasData) {
              if (snapshot.data.length == 0) {
                return const Center(
                  child: Text("No data available"),
                );
              }

              // for (final point in snapshot.data) {
              //   print('readData🦖　$point');
              // }

              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, int index) {
                    var data = snapshot.data[index]; // {} map
                    //var title = "$data['point']ポイント";

                    return ListTile(
                      title: Text(title),
                      trailing: Wrap(
                        spacing: 8, // アイコンの間の幅を調整
                        children: [
                          IconButton(
                              //削除
                              onPressed: () => _dialogBuilder(
                                    context,
                                    0,
                                    data['seq'],
                                    title,
                                    data['memo'],
                                    point,
                                  ),
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.grey,
                              )),
                          IconButton(
                              //編集
                              onPressed: () => _dialogBuilder(context, 2,
                                  data['seq'], title, data['memo'], point),
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.red,
                              )),
                        ],
                      ),
                      // IconButton(
                      //     onPressed: () => _dialogBuilder(context),
                      //     icon: const Icon(
                      //       Icons.edit,
                      //       color: Colors.red,
                      //     )),
                    );
                  });
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          //追加
          _dialogBuilder(context, 1, "", title, "", point); //
        },
      ),
    );
  }

//https://api.flutter.dev/flutter/material/showDialog.html

  Future<void> _dialogBuilder(
    BuildContext context,
    int dialogType,
    String seqUid,
    String title,
    String currentMemo,
    int point,
  ) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        var memo = '';
        return AlertDialog(
          title: (dialogType == 0)
              ? Text('削除します $title')
              : (dialogType == 1)
                  ? Text('登録します $title')
                  : Text('編集します $title'),
          content: (dialogType == 0)
              ? Text(currentMemo)
              : TextFormField(
                  initialValue: currentMemo,
                  autofocus: true,
                  onChanged: (value) {
                    setState(() {
                      memo = value;
                    });
                  },
                  // ダイアログが開いたときに自動でフォーカスを当てる
                ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('キャンセル'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: (dialogType == 0)
                  ? const Text("削除")
                  : (dialogType == 1 ? const Text("登録") : const Text("編集")),
              onPressed: () {
                (dialogType == 0)
                    ? deleteData(seqUid)
                    : (dialogType == 1)
                        ? insertData(memo, point)
                        : updateData(seqUid, memo);
                //Navigator.of(context).pop();
                // 再読み込み
                //callbackFunc;
                setState(() {});
              },
            ),
          ],
        );
      },
    );
  }

  Future deleteData(seqUid) async {
    try {
      String userId = supabase.auth.currentUser!.id;
      await supabase.from('member_point').delete().match({
        'guru_id': widget.guruId,
        'category_id': widget.categoryId,
        'point_id': widget.pointId,
        'member_id': userId,
        'seq': seqUid,
      });

      Navigator.pop(context);
    } catch (e) {
      print("Error inserting data : $e");
      // setState(() {
      //   isLoading = false;
      // });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Something Went Wrong")));
    }
  }

  Future insertData(newText, point) async {
    // setState(() {
    //   isLoading = true;
    // });
    try {
      String userId = supabase.auth.currentUser!.id;
      await supabase.from('member_point').insert({
        'guru_id': widget.guruId,
        'category_id': widget.categoryId,
        'point_id': widget.pointId,
        'member_id': userId,
        'memo': newText,
        'point': point,
      });

      Navigator.pop(context);
    } catch (e) {
      print("Error inserting data : $e");
      // setState(() {
      //   isLoading = false;
      // });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Something Went Wrong")));
    }
  }

  Future updateData(seqUid, newText) async {
    try {
      String userId = supabase.auth.currentUser!.id;
      await supabase.from('member_point').update({'memo': newText}).match({
        'guru_id': widget.guruId,
        'category_id': widget.categoryId,
        'point_id': widget.pointId,
        'member_id': userId,
        'seq': seqUid,
      });

      Navigator.pop(context);
    } catch (e) {
      print("Error inserting data : $e");
      // setState(() {
      //   isLoading = false;
      // });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Something Went Wrong")));
    }
  }
}
