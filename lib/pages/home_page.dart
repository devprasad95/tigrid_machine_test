import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tigrid_machine_test/services/api_service.dart';
import 'package:tigrid_machine_test/services/auth_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    Provider.of<ApiService>(context, listen: false).fetchDatas();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
              onPressed: () {
                AuthService().signOut();
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: Consumer<ApiService>(builder: (context, provider, _) {
        if (provider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return ListView.builder(
              itemCount: provider.randomDatas.length,
              itemBuilder: (context, index) {
                final randomData = provider.randomDatas[index];
                return ListTile(
                  title: Text("${randomData.id} ${randomData.title}"),
                  subtitle: Text(randomData.body ?? ''),
                );
              });
        }
      }),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.refresh),
        onPressed: () {
          Provider.of<ApiService>(context, listen: false).fetchDatas();
        },
      ),
    );
  }
}
