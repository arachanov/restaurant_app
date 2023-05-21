import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'main.dart';
import 'package:riverpod_example/repository/user_repository.dart';
import 'package:riverpod_example/model/user.dart';

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key});

  void onSubmitName(WidgetRef ref, String value) {
    ref.read(userProvider.notifier).updateName(value);
  }

  void onSubmitId(WidgetRef ref, String value) {
    ref.read(userProvider.notifier).updateId(int.parse(value));
  }


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final userRepository = ref.watch(userRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(user.name!),
        centerTitle: true,
      ),
      body: Column(
        children: [
          TextField(
            onSubmitted: (value) => onSubmitName(ref, value),
          ),
          TextField(
            onSubmitted: (value) => onSubmitId(ref, value),
          ),
          ElevatedButton(
              onPressed: () {
                // Route route = MaterialPageRoute(builder: (context) => StudentPage());
                // Navigator.push(context, route);
                //if (user.name != null && user.id != null){
                  userRepository.addUser(User(name: 'Salim',id: 1));
                  userRepository.addUser(User(name: 'Salim',id: 1));
              }, child: (Text('${userRepository.getUserById(1)}')),
          ),
          Center(
            child: Text(user.id.toString()),
          ),
          Expanded(
            child: FutureBuilder(
              future: userRepository.getUsers(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('ID: ${user.id}'),
                          Text('Name: ${user.name}'),
                        ],
                      ));
                }
                if (snapshot.data == null || (snapshot.data as List<User>).length == 0) {
                  return Text('No Data Found');
                }
                return CircularProgressIndicator();
              },
            ),
          ),
        ],
      ),
    );
  }
}