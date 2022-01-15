import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fruitapp/controllers/fruit_controller.dart';
import 'package:fruitapp/data/fruits.dart';
import 'package:fruitapp/save_fruit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fruit app'),
      ),
      body: FruitList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SaveFuit(),
            ),
          );
        },
        child: Text('Add'),
      ),
    );
  }
}

class FruitList extends StatelessWidget {
  FruitList({Key? key}) : super(key: key);
  final PostController _postController = PostController();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>?>>(
        stream: _postController.getAllPosts(),
        builder: (context, snapshot) {
          return ListView.separated(
              padding: const EdgeInsets.only(top: 10),
              itemCount: snapshot.data == null ? 0 : snapshot.data!.docs.length,
              itemBuilder: (BuildContext context, int index) {
                if (snapshot.connectionState == ConnectionState.waiting &&
                    snapshot.data == null) {
                  return const Center(
                      child: CircularProgressIndicator.adaptive());
                }

                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.data == null) {
                  return const Center(child: Text('No data available'));
                }
                return ListTile(
                  leading: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: NetworkImage(
                          snapshot.data!.docs[index].data()!['image'],
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: const SizedBox(
                      width: 100,
                      height: 100,
                    ),
                  ),
                  title: Text(snapshot.data!.docs[index].data()!['name']),
                  trailing: Container(
                    width: 100,
                    child: Row(
                      children: [
                        IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              final snackBar = SnackBar(
                                content: Text(
                                    snapshot.data!.docs[index].data()!['name']),
                                action: SnackBarAction(
                                  label: 'Undo',
                                  onPressed: () {
                                    // Some code to undo the change.
                                  },
                                ),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const Divider();
              });
        });
  }
}
