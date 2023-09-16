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
  });

  final int guruId;
  final int categoryId;
  final int pointId;

  @override
  State<GuruPointScreen> createState() => _GuruPointState();
}

class _GuruPointState extends State<GuruPointScreen> {
  final SupabaseClient supabase = Supabase.instance.client;
  late Stream<List<Map<String, dynamic>>> _readStream;

  @override
  void initState() {
    _readStream = supabase
        .from('todos')
        .stream(primaryKey: ['id'])
        .eq('user_id', supabase.auth.currentUser!.id)
        .order('id', ascending: false);
    super.initState();
  }

  // Syntax to select data
  Future<List> readData() async {
    final result = await supabase
        .from('todos')
        .select()
        .eq('user_id', supabase.auth.currentUser!.id)
        .order('id', ascending: false);
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      trailing: IconButton(
                          onPressed: () => _dialogBuilder(context),
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.red,
                          )),
                    );
                  });
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {},
      ),
    );
  }

//https://api.flutter.dev/flutter/material/showDialog.html

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        var memo = '';
        return AlertDialog(
          title: const Text('Basic dialog title'),
          content: TextFormField(
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
              child: const Text('登録'),
              onPressed: () {
                insertData(memo);
                //Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
}
