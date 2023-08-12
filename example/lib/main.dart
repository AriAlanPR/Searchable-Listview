import 'dart:async';

import 'package:flutter/material.dart';
import 'package:searchable_listview/searchable_listview.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Scaffold(
        body: SafeArea(
          child: ExampleApp(),
        ),
      ),
    );
  }
}

class ExampleApp extends StatefulWidget {
  const ExampleApp({Key? key}) : super(key: key);

  @override
  State<ExampleApp> createState() => _ExampleAppState();
}

class _ExampleAppState extends State<ExampleApp> {
  final List<Actor> actors = [
    Actor(age: 47, name: 'Leonardo', lastName: 'DiCaprio'),
    Actor(age: 58, name: 'Johnny', lastName: 'Depp'),
    Actor(age: 78, name: 'Robert', lastName: 'De Niro'),
    Actor(age: 44, name: 'Tom', lastName: 'Hardy'),
    Actor(age: 66, name: 'Denzel', lastName: 'Washington'),
    Actor(age: 49, name: 'Ben', lastName: 'Affleck'),
  ];

  final Map<String, List<Actor>> mapOfActors = {
    'test 1': [
      Actor(age: 47, name: 'Leonardo', lastName: 'DiCaprio'),
      Actor(age: 66, name: 'Denzel', lastName: 'Washington'),
      Actor(age: 49, name: 'Ben', lastName: 'Affleck'),
    ],
    'test 2': [
      Actor(age: 58, name: 'Johnny', lastName: 'Depp'),
      Actor(age: 78, name: 'Robert', lastName: 'De Niro'),
      Actor(age: 44, name: 'Tom', lastName: 'Hardy'),
    ]
  };

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          const Text('Searchable list with divider'),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: renderSimpleSearchableList(),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: ElevatedButton(
              onPressed: addActor,
              child: const Text('Add actor'),
            ),
          )
        ],
      ),
    );
  }

  void addActor() {
    actors.add(Actor(
      age: 10,
      lastName: 'Ali',
      name: 'ALi',
    ));
    setState(() {});
  }

  Widget renderSimpleSearchableList() {
    return SearchableList<Actor>(
      style: const TextStyle(fontSize: 25),
      onPaginate: () async {
        await Future.delayed(const Duration(milliseconds: 1000));
        setState(() {
          actors.addAll([
            Actor(age: 22, name: 'Fathi', lastName: 'Hadawi'),
            Actor(age: 22, name: 'Hichem', lastName: 'Rostom'),
            Actor(age: 22, name: 'Kamel', lastName: 'Twati'),
          ]);
        });
      },
      builder: (int index) => ActorItem(actor: actors[index]),
      loadingWidget: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(
            height: 20,
          ),
          Text('Loading actors...')
        ],
      ),
      errorWidget: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error,
            color: Colors.red,
          ),
          SizedBox(
            height: 20,
          ),
          Text('Error while fetching actors')
        ],
      ),
      asyncListCallback: () async {
        await Future.delayed(
          const Duration(
            milliseconds: 10000,
          ),
        );
        return actors;
      },
      asyncListFilter: (q, list) {
        return list.where((element) => element.name.contains(q)).toList();
      },
      reverse: true,
      emptyWidget: const EmptyView(),
      onRefresh: () async {},
      onItemSelected: (Actor item) {},
      inputDecoration: InputDecoration(
        labelText: "Search Actor",
        fillColor: Colors.white,
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.blue,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      secondaryWidget: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Container(
          color: Colors.grey[400],
          child: const Padding(
            padding: EdgeInsets.symmetric(
              vertical: 20,
              horizontal: 10,
            ),
            child: Center(
              child: Icon(Icons.sort),
            ),
          ),
        ),
      ),
    );
  }

  Widget sliverListViewBuilder() {
    return SearchableList.sliver(
      initialList: actors,
      filter: (p0) {
        return actors;
      },
      builder: (int index) => ActorItem(actor: actors[index]),
    );
  }

  Widget expansionSearchableList() {
    return SearchableList<Actor>.expansion(
      expansionListData: mapOfActors,
      expansionTitleBuilder: (p0) {
        return Container(
          color: Colors.grey[300],
          width: MediaQuery.of(context).size.width * 0.8,
          height: 30,
          child: Center(
            child: Text(p0.toString()),
          ),
        );
      },
      filterExpansionData: (p0) {
        final filteredMap = {
          for (final entry in mapOfActors.entries)
            entry.key: (mapOfActors[entry.key] ?? [])
                .where((element) => element.name.contains(p0))
                .toList()
        };
        return filteredMap;
      },
      style: const TextStyle(fontSize: 25),
      builder: (int index) => ActorItem(actor: actors[index]),
      emptyWidget: const EmptyView(),
      inputDecoration: InputDecoration(
        labelText: "Search Actor",
        fillColor: Colors.white,
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.blue,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}

class ActorItem extends StatelessWidget {
  final Actor actor;

  const ActorItem({
    Key? key,
    required this.actor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            const SizedBox(
              width: 10,
            ),
            Icon(
              Icons.star,
              color: Colors.yellow[700],
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Firstname: ${actor.name}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Lastname: ${actor.lastName}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Age: ${actor.age}',
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class EmptyView extends StatelessWidget {
  const EmptyView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.error,
          color: Colors.red,
        ),
        Text('no actor is found with this name'),
      ],
    );
  }
}

class Actor {
  int age;
  String name;
  String lastName;

  Actor({
    required this.age,
    required this.name,
    required this.lastName,
  });
}
