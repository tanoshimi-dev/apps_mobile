import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:gurupoint/dummy/dummy_data.dart';
import 'package:gurupoint/widgets/guru_grid_item.dart';

// Dialog text input
// https://www.youtube.com/watch?v=D6icsXS8NeA

class GuruPointScreen_back extends StatefulWidget {
  const GuruPointScreen_back({
    super.key,
    required this.guruId,
    required this.categoryId,
    required this.pointId,
    required this.pointName,
  });

  final int guruId;
  final int categoryId;
  final int pointId;
  final String pointName;

  @override
  State<GuruPointScreen_back> createState() => _GuruPointState();
}

class _GuruPointState extends State<GuruPointScreen_back> {
  final SupabaseClient supabase = Supabase.instance.client;
  late Stream<List<Map<String, dynamic>>> _readStream;

  @override
  void initState() {
    _readStream = supabase
        .from('todos')
        .stream(primaryKey: ['id'])
        .eq('user_id', supabase.auth.currentUser!.id)
        .order('id', ascending: false);
    // _readStream = supabase
    //     .from('member_point')
    //     .stream(primaryKey: ['guru_id', 'category_id', 'point_id'])
    //     .eq('member_id', supabase.auth.currentUser!.id)
    //     .order('created_at', ascending: false);
    super.initState();
  }

  // Syntax to select data
  Future<List> readData() async {
    final result = await supabase
        .from('todos')
        .select()
        .eq('user_id', supabase.auth.currentUser!.id)
        .order('id', ascending: false);
    // final result = await supabase
    //     .from('todos')
    //     .select()
    //     .eq('user_id', supabase.auth.currentUser!.id)
    //     .order('id', ascending: false);
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pointName),
      ),
      body: StreamBuilder(
          stream: _readStream,
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
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, int index) {
                    var data = snapshot.data[index]; // {} map

                    return ListTile(
                      title: Text(data['title']),
                      trailing: Wrap(
                        spacing: 8, // アイコンの間の幅を調整
                        children: [
                          IconButton(
                              //削除
                              onPressed: () => _dialogBuilder(
                                  context, 0, data['id'], data['title']),
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.grey,
                              )),
                          IconButton(
                              //編集
                              onPressed: () => _dialogBuilder(
                                  context, 2, data['id'], data['title']),
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
          _dialogBuilder(context, 1, 0, ""); //
        },
      ),
    );
  }

//https://api.flutter.dev/flutter/material/showDialog.html

  Future<void> _dialogBuilder(
      BuildContext context, int dialogType, int id, String currentTitle) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        var memo = '';
        return AlertDialog(
          title: (dialogType == 0)
              ? const Text('削除します')
              : (dialogType == 1)
                  ? const Text('登録します')
                  : const Text('編集します'),
          content: (dialogType == 0)
              ? Text(currentTitle)
              : TextFormField(
                  initialValue: currentTitle,
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
                    ? deleteData(id)
                    : (dialogType == 1)
                        ? insertData(memo)
                        : updateData(id, memo);
                //Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future deleteData(id) async {
    try {
      String userId = supabase.auth.currentUser!.id;
      await supabase
          .from('todos')
          .delete()
          .match({'id': id, 'user_id': userId});

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

  Future insertData(newText) async {
    // setState(() {
    //   isLoading = true;
    // });
    try {
      String userId = supabase.auth.currentUser!.id;
      await supabase
          .from('todos')
          .insert({'title': newText, 'user_id': userId});
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

  Future updateData(id, newText) async {
    try {
      String userId = supabase.auth.currentUser!.id;
      await supabase
          .from('todos')
          .update({'title': newText}).match({'id': id, 'user_id': userId});
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
