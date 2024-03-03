import 'package:consumo_avancado_2/post.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final _urlBase = 'https://jsonplaceholder.typicode.com';

  Future<List<Post>> _recuperarPostagens() async {
    var response = await http.get(Uri.parse('$_urlBase/posts'));
    if (response.statusCode == 200) {
      var dadosJson = json.decode(response.body) as List<dynamic>;
      return dadosJson.map((json) => Post.fromJson(json)).toList();
    } else {
      throw Exception('Falha ao carregar postagens');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Consumo de Serviço Avançado"),
      ),
      body: FutureBuilder<List<Post>>(
        future: _recuperarPostagens(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return const Text('Nenhuma conexão');
            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator());
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Text('Lista: Erro ao carregar ${snapshot.error}');
              } else {
                if (snapshot.data != null) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      var post = snapshot.data![index];
                      return ListTile(
                        title: Text(post.title),
                        subtitle: Text(post.body),
                      );
                    },
                  );
                } else {
                  return const Text('Dados nulos');
                }
              }
            default:
              return const Text('Estado desconhecido');
          }
        },
      ),
    );
  }
}
