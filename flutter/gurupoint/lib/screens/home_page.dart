import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:gurupoint/screens/create_page.dart';
import 'package:gurupoint/screens/edit_page.dart';

// Filters

// 1. Equal to : supabase.from('users').select().eq('name','The Rock');
// 2. Not Equal to : supabase.from('users').select().neq('name','Bill Gates');
// 3. Greater than : supabase.from('users').select().gt('age',18);
// 4. Greater than or Equal : supabase.from('users').select().gte('followers',10000);
// 5. Less than : lt() and Less than Equal : lte()
// 6. Column matches a pattern (case sensitive) : supabase.from('users').select().like('name','%The%');
// 7. Column matches a case insensitive pattern : supabase.from('users').select().ilike('name','%the%');
// 8. Column is in the array : supabase.from('users').select().in_('status',['ONLINE','OFFLINE']);

// Modifiers

// 1. Order : supabase.from('users').select().order('id',ascending:false);
// 2. Limit the query : suapbase.from('users').select().limit(10);

// RealTime database
// Syntax : supabase.from('users').stream(primaryKey:['id']).listen((List data){ ..... });
// Using Streambuilder - stream : supabase.from('users').stream(primaryKey: ['id']);

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
      appBar: AppBar(
        title: const Text("Supabase Flutter"),
        actions: [
          IconButton(
              onPressed: () async {
                await supabase.auth.signOut();
              },
              icon: const Icon(Icons.logout))
        ],
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
                      trailing: IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        EditPage(data['title'], data['id'])));
                          },
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
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => CreatePage()));
        },
      ),
    );
  }
}
